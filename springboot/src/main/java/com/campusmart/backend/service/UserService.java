package com.campusmart.backend.service;

import com.campusmart.backend.dto.AuthResponse;
import com.campusmart.backend.dto.LoginRequest;
import com.campusmart.backend.dto.RegisterRequest;
import com.campusmart.backend.exception.BadRequestException;
import com.campusmart.backend.exception.ResourceNotFoundException;
import com.campusmart.backend.model.User;
import com.campusmart.backend.repository.UserRepository;
import com.campusmart.backend.security.JwtUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Service
public class UserService {

    private static final Logger log = LoggerFactory.getLogger(UserService.class);

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtUtil jwtUtil;
    private final Map<String, User> memoryUsers = new ConcurrentHashMap<>();

    public UserService(UserRepository userRepository, PasswordEncoder passwordEncoder, JwtUtil jwtUtil) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
        this.jwtUtil = jwtUtil;

        // Default demo user fallback in memory
        User rohan = new User("usr-rohan-1", "Rohan Varma", "rohan@srkr.edu.in", passwordEncoder.encode("password123"), "+91 98765 43210");
        rohan.setRole("Student");
        rohan.setDepartment("Computer Science");
        rohan.setBatch("'28");
        rohan.setRollNumber("24A91A05XX");
        rohan.setRollVerified(true);
        rohan.setCollege("SRKR Engg College");
        rohan.setAvatar("https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=160&q=80");
        memoryUsers.put(rohan.getEmail(), rohan);
    }

    public AuthResponse register(RegisterRequest request) {
        String email = request.getEmail().toLowerCase().trim();
        try {
            if (userRepository.existsByEmail(email)) {
                throw new BadRequestException("An account with this email already exists");
            }
        } catch (Exception e) {
            log.warn("MongoDB check failed, checking in-memory store: {}", e.getMessage());
            if (memoryUsers.containsKey(email)) {
                throw new BadRequestException("An account with this email already exists");
            }
        }

        User user = new User();
        user.setId("usr-" + System.currentTimeMillis());
        user.setName(request.getName().trim());
        user.setEmail(email);
        user.setPassword(passwordEncoder.encode(request.getPassword()));
        user.setPhone(request.getPhone().trim());
        if (request.getDepartment() != null) user.setDepartment(request.getDepartment());
        if (request.getBatch() != null) user.setBatch(request.getBatch());
        if (request.getRollNumber() != null) user.setRollNumber(request.getRollNumber());
        if (request.getCollege() != null) user.setCollege(request.getCollege());
        user.setAvatar("https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=160&q=80");

        memoryUsers.put(user.getEmail(), user);

        User saved = user;
        try {
            saved = userRepository.save(user);
        } catch (Exception e) {
            log.warn("MongoDB save failed: {}. Preserved in in-memory session.", e.getMessage());
        }

        String token = jwtUtil.generateToken(saved.getId(), saved.getEmail());
        saved.setPassword(null);
        return new AuthResponse(token, saved);
    }

    public AuthResponse login(LoginRequest request) {
        String email = request.getEmail().toLowerCase().trim();
        User user = null;
        try {
            user = userRepository.findByEmail(email).orElse(null);
        } catch (Exception e) {
            log.warn("MongoDB query failed, falling back to in-memory store: {}", e.getMessage());
        }

        if (user == null) {
            user = memoryUsers.get(email);
        }

        if (user == null || !passwordEncoder.matches(request.getPassword(), user.getPassword())) {
            throw new BadRequestException("Invalid email or password");
        }

        String token = jwtUtil.generateToken(user.getId(), user.getEmail());
        User responseUser = new User();
        responseUser.setId(user.getId());
        responseUser.setName(user.getName());
        responseUser.setEmail(user.getEmail());
        responseUser.setPhone(user.getPhone());
        responseUser.setDepartment(user.getDepartment());
        responseUser.setBatch(user.getBatch());
        responseUser.setRollNumber(user.getRollNumber());
        responseUser.setRole(user.getRole());
        responseUser.setCollege(user.getCollege());
        responseUser.setAvatar(user.getAvatar());
        responseUser.setRollVerified(user.isRollVerified());
        return new AuthResponse(token, responseUser);
    }

    public User getProfile(String userId) {
        try {
            var dbUser = userRepository.findById(userId);
            if (dbUser.isPresent()) {
                User u = dbUser.get();
                u.setPassword(null);
                return u;
            }
        } catch (Exception ignored) {}

        for (User u : memoryUsers.values()) {
            if (u.getId().equals(userId)) {
                User copy = new User();
                copy.setId(u.getId());
                copy.setName(u.getName());
                copy.setEmail(u.getEmail());
                copy.setPhone(u.getPhone());
                copy.setDepartment(u.getDepartment());
                copy.setBatch(u.getBatch());
                copy.setRollNumber(u.getRollNumber());
                copy.setRole(u.getRole());
                copy.setCollege(u.getCollege());
                copy.setAvatar(u.getAvatar());
                copy.setRollVerified(u.isRollVerified());
                return copy;
            }
        }

        throw new ResourceNotFoundException("User not found with id: " + userId);
    }
}
