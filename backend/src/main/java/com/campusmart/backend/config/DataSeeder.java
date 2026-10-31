package com.campusmart.backend.config;

import com.campusmart.backend.model.Listing;
import com.campusmart.backend.model.SellerSummary;
import com.campusmart.backend.model.User;
import com.campusmart.backend.repository.ListingRepository;
import com.campusmart.backend.repository.UserRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import java.time.Instant;
import java.util.List;

@Component
public class DataSeeder implements CommandLineRunner {

    private static final Logger log = LoggerFactory.getLogger(DataSeeder.class);

    private final UserRepository userRepository;
    private final ListingRepository listingRepository;
    private final PasswordEncoder passwordEncoder;

    public DataSeeder(UserRepository userRepository, ListingRepository listingRepository, PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.listingRepository = listingRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @Override
    public void run(String... args) {
        try {
            if (userRepository.count() == 0) {
                log.info("Seeding initial campus users...");

            // 1. Rohan Varma (Default demo user matching Flutter frontend)
            User rohan = new User();
            rohan.setName("Rohan Varma");
            rohan.setEmail("rohan@srkr.edu.in");
            rohan.setPassword(passwordEncoder.encode("password123"));
            rohan.setPhone("+91 98765 43210");
            rohan.setRole("Student");
            rohan.setDepartment("Computer Science");
            rohan.setBatch("'28");
            rohan.setRollNumber("24A91A05XX");
            rohan.setRollVerified(true);
            rohan.setRating(5.0);
            rohan.setPeerSalesCount(2);
            rohan.setReplyTime("~5m");
            rohan.setCollege("SRKR Engg College");
            rohan.setAvatar("https://lh3.googleusercontent.com/aida-public/AB6AXuBzbfHDH0nFQfxijNb9v9QxFSxSqYFkYpiCMXWlLG3cwq_5Pxy0xIw6T9wZSqRTAEjO621bZ6rcdcSElmPwI7q6rdJ7O-gae--GdiNmmAJcuFs69-Cb3JspriTBYoqvLtW2fm_0k7hupCi5Z8aNzQt4wVsO7ev8JXKX6ELv7L8z-UUxHPsYR0nJRADOBTAew0RgKrDZh8NoPBV1-hX-a59JDNRQSXDm4MRZyQjrz0CLq7NY1vHD5-O3");
            userRepository.save(rohan);

            // 2. Aarav Sharma (Senior Mechanical)
            User aarav = new User();
            aarav.setName("Aarav Sharma");
            aarav.setEmail("aarav@srkr.edu.in");
            aarav.setPassword(passwordEncoder.encode("password123"));
            aarav.setPhone("+91 98765 43210");
            aarav.setRole("Senior");
            aarav.setDepartment("B.Tech Mechanical");
            aarav.setBatch("'25");
            aarav.setRollNumber("21A91A03XX");
            aarav.setRollVerified(true);
            aarav.setRating(4.9);
            aarav.setPeerSalesCount(12);
            aarav.setReplyTime("~15m");
            aarav.setCollege("SRKR Engg College");
            aarav.setAvatar("https://lh3.googleusercontent.com/aida-public/AB6AXuDFG-Qj800CuQGnTMdCPJYs0Or8qlLwzL6xmvpRgWjo1Tv5JJ-mbrbJhm-dvLWnh0ZVT0e00ptULuYqcWssndpY-AEcX7vtiaeyOXLMPcJoIQJ-anMASy5OAxNA5hVtPFqYu89thY9YpMI-SZ4Da3pdx-TTixRKNnyfh1-cFVqm7ASyZstk4pGezG-hrZOvh8IVp8sT-P413vlvjceAXssskdUh_z0IvV5a-kA7jkgivnMFXybcbVdh");
            userRepository.save(aarav);

            // 3. Priya S. (Senior CS)
            User priya = new User();
            priya.setName("Priya S.");
            priya.setEmail("priya@srkr.edu.in");
            priya.setPassword(passwordEncoder.encode("password123"));
            priya.setPhone("+91 98112 34567");
            priya.setRole("Senior");
            priya.setDepartment("Comp Sci");
            priya.setBatch("'25");
            priya.setRollNumber("21A91A05XX");
            priya.setRollVerified(true);
            priya.setRating(5.0);
            priya.setPeerSalesCount(8);
            priya.setReplyTime("~5m");
            priya.setCollege("SRKR Engg College");
            priya.setAvatar("https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=160&q=80");
            userRepository.save(priya);

            log.info("Seeded initial users successfully.");
        }

        if (listingRepository.count() == 0) {
            log.info("Seeding initial marketplace listings...");
            User aarav = userRepository.findByEmail("aarav@srkr.edu.in").orElse(null);
            User priya = userRepository.findByEmail("priya@srkr.edu.in").orElse(null);

            if (aarav != null) {
                Listing l1 = new Listing();
                l1.setTitle("Omega Deluxe Mini Drafter + Free Protective Canvas Bag");
                l1.setCategory("Drafters");
                l1.setCondition("Like New");
                l1.setConditionDetail("1 Sem Used");
                l1.setPrice(450);
                l1.setOriginalPrice(1200);
                l1.setDiscountPercent(62);
                l1.setImages(List.of(
                        "https://lh3.googleusercontent.com/aida-public/AB6AXuCFsBI-jYBDC9S4Ljf6CszniaqmVnVeSSTy2cGVDQQRUzX2AAIUrsPThMKhDA0cTuYenoGdVc1aGAaqs6PJaQHrH-ftuavK4w10gcGZWPi-HmXi9Er9qeGzq_2UtcHUYa7qxK8E74vvThvifUX3EFWsA_1OEqwtVObh-c-J2_foZV3epm-rZpiq-Uu6E6yuG1X4ODzS-eLmTW3WxP709Qa2fodi1c7WiB4UxdRN9jNGmpuPjsx2oZA",
                        "https://lh3.googleusercontent.com/aida-public/AB6AXuCUK2dREePB_BQ8o2w59xfGQG_tks6HEjflJP8BSpMk7Bn4r1Wv438oP5XMcPBMt15BzqAKktznjiXE0meUabrfnsLAHcE1jfkeiQchn1_XomQu3V4Xj80HyafTWGNwPFuNVEPytAXUexkDh0VS5Iglsk7MeN9C3p1zJYSfw5dKc1F4UPhXr45yj6lWrkLCTONufXgYDu9sIylug731KwkxxPWsBns8fKh1Rrr8qkpXdYyB57z9LHVz"
                ));
                l1.setDepartment("Mech / Civil / FY Core");
                l1.setSemester("Semester 1 & 2");
                l1.setSubjectCode("Engg Graphics (EG)");
                l1.setLocation("SRKREC Campus, Bhimavaram");
                l1.setHandoverType("In-person handover");
                l1.setDescription("Used carefully during First Year Engg Drawing (ED). Complete with desk clamp, precision 360° protractor, dual scale ruler, and canvas carrying case. No cracks or loose screws. Can hand over at SRKR Main Block or Central Library academic area.");
                l1.setInspectionPerk("Bring your drawing sheet to inspect calibration live before paying!");
                l1.setNegotiable(true);
                l1.setFeatured(true);
                l1.setSellerId(aarav.getId());
                l1.setSeller(new SellerSummary(aarav));
                l1.setCreatedAt(Instant.now().minusSeconds(172800)); // 2 days ago
                listingRepository.save(l1);
            }

            if (priya != null) {
                Listing l2 = new Listing();
                l2.setTitle("Casio FX-991EX Scientific Calculator - ClassWiz");
                l2.setCategory("Calculators");
                l2.setCondition("Like New");
                l2.setConditionDetail("Barely used, 0 scratches");
                l2.setPrice(850);
                l2.setOriginalPrice(1495);
                l2.setDiscountPercent(43);
                l2.setImages(List.of(
                        "https://lh3.googleusercontent.com/aida-public/AB6AXuAOxjH8xcRskwDB3LonqLxUsZJV6z0z7ZE-v3HM1funMUe3TKFPGBTTj8oh1deOgQFNOvvoec4_L9WaKV9IezRzauEJ3ygPV9XJKoQLtE38IDh-6psoOOkosPpShbqtteWfMLEqc0ROHTjrvIgj8n3QsWoGZ1tlCjnGpt08g5gCk9mT8MymwON4chz6OuOc9datuS2O-lS9IqRd40o9j_jstMhFNigjpnxERT2uhvK2YZ6sUmz0DD3I"
                ));
                l2.setDepartment("Comp Sci");
                l2.setSemester("Sem 1 - 8");
                l2.setLocation("Hostel 3 Common Room");
                l2.setHandoverType("Library pickup");
                l2.setDescription("Pristine ClassWiz with natural textbook display and high-res matrix LCD. Comes with original hard slide-on case. Battery is at 100%.");
                l2.setInspectionPerk("Test matrix inverse, calculus integrals live on spot.");
                l2.setNegotiable(false);
                l2.setFeatured(true);
                l2.setSellerId(priya.getId());
                l2.setSeller(new SellerSummary(priya));
                l2.setCreatedAt(Instant.now().minusSeconds(14400)); // 4 hours ago
                listingRepository.save(l2);

                Listing l3 = new Listing();
                l3.setTitle("Higher Engineering Mathematics (44th Ed)");
                l3.setCategory("Books");
                l3.setCondition("Like New");
                l3.setPrice(380);
                l3.setOriginalPrice(850);
                l3.setDiscountPercent(55);
                l3.setImages(List.of(
                        "https://lh3.googleusercontent.com/aida-public/AB6AXuDfprd_iqw2jepfMBe4GFGydB4xpug9EL8zTCHXmIRM5_SDnA6iO3ke389XT0zJ9hIVo0pojqOpm7G4ugw6Xeu5ktXRNuUXK_l4LXH6Ja9ec25N4EOIloRJ7jrDUXJxmTeCQ2R02ABaC-Xas_U6eB-EJypW0iUMZQ1eFyjJRfz6otwM2CgxrIWH-i4QSnewmyv4WPWmLRVpN50dehcEvbMhlyU9GOhgJXaj_JwbBcyLPxupzvdh28lu"
                ));
                l3.setDepartment("Civil");
                l3.setSemester("Sem 1 & 2");
                l3.setLocation("SRKR Main Block");
                l3.setHandoverType("Between lectures");
                l3.setDescription("Crisp unmarked pages without pencil underlines. Includes differential calculus, Laplace transforms, and vector calculus problem solutions.");
                l3.setNegotiable(false);
                l3.setFeatured(true);
                l3.setSellerId(priya.getId());
                l3.setSeller(new SellerSummary(priya));
                l3.setCreatedAt(Instant.now().minusSeconds(18000));
                listingRepository.save(l3);
            }

            log.info("Seeded initial listings successfully.");
        }
        } catch (Exception e) {
            log.warn("MongoDB is not reachable at the configured URI ({}). Backend running in resilient mode.", e.getMessage());
        }
    }
}
