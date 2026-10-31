package com.campusmart.backend;

import com.campusmart.backend.dto.LoginRequest;
import com.campusmart.backend.dto.RegisterRequest;
import com.campusmart.backend.model.Listing;
import com.campusmart.backend.model.User;
import com.campusmart.backend.repository.ListingRepository;
import com.campusmart.backend.repository.UserRepository;
import com.campusmart.backend.service.ListingService;
import com.campusmart.backend.service.UserService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.TestPropertySource;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
@TestPropertySource(properties = {
        "spring.data.mongodb.uri=mongodb://localhost:27017/campus_mart_test",
        "cloudinary.cloud-name=",
        "cloudinary.api-key=",
        "cloudinary.api-secret="
})
class CampusMartBackendApplicationTests {

    @Autowired(required = false)
    private UserService userService;

    @Autowired(required = false)
    private ListingService listingService;

    @Test
    void contextLoads() {
        assertNotNull(userService, "UserService should be loaded in application context");
        assertNotNull(listingService, "ListingService should be loaded in application context");
    }
}
