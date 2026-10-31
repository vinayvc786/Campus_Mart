package com.campusmart.backend.service;

import com.campusmart.backend.dto.ListingRequest;
import com.campusmart.backend.exception.ResourceNotFoundException;
import com.campusmart.backend.exception.UnauthorizedException;
import com.campusmart.backend.model.Listing;
import com.campusmart.backend.model.SellerSummary;
import com.campusmart.backend.model.User;
import com.campusmart.backend.repository.ListingRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;
import java.util.stream.Collectors;

@Service
public class ListingService {

    private static final Logger log = LoggerFactory.getLogger(ListingService.class);

    private final ListingRepository listingRepository;
    private final UserService userService;
    private final List<Listing> memoryListings = new CopyOnWriteArrayList<>();

    public ListingService(ListingRepository listingRepository, UserService userService) {
        this.listingRepository = listingRepository;
        this.userService = userService;
        initializeSeedListings();
    }

    private void initializeSeedListings() {
        // 1. Omega Mini Drafter
        Listing l1 = new Listing();
        l1.setId("CM-4829");
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
        l1.setSellerId("usr-aarav-1");

        SellerSummary s1 = new SellerSummary();
        s1.setId("usr-aarav-1");
        s1.setName("Aarav Sharma");
        s1.setRole("Senior");
        s1.setDepartment("B.Tech Mechanical");
        s1.setBatch("'25");
        s1.setRollVerified(true);
        s1.setRating(4.9);
        s1.setPeerSalesCount(12);
        s1.setReplyTime("~15m");
        s1.setPhone("+91 98765 43210");
        s1.setAvatar("https://lh3.googleusercontent.com/aida-public/AB6AXuDFG-Qj800CuQGnTMdCPJYs0Or8qlLwzL6xmvpRgWjo1Tv5JJ-mbrbJhm-dvLWnh0ZVT0e00ptULuYqcWssndpY-AEcX7vtiaeyOXLMPcJoIQJ-anMASy5OAxNA5hVtPFqYu89thY9YpMI-SZ4Da3pdx-TTixRKNnyfh1-cFVqm7ASyZstk4pGezG-hrZOvh8IVp8sT-P413vlvjceAXssskdUh_z0IvV5a-kA7jkgivnMFXybcbVdh");
        l1.setSeller(s1);
        l1.setCreatedAt(Instant.now().minusSeconds(172800));
        memoryListings.add(l1);

        // 2. Casio FX-991EX Calculator
        Listing l2 = new Listing();
        l2.setId("CM-1001");
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
        l2.setSellerId("usr-priya-1");

        SellerSummary s2 = new SellerSummary();
        s2.setId("usr-priya-1");
        s2.setName("Priya S.");
        s2.setRole("Senior");
        s2.setDepartment("Comp Sci");
        s2.setBatch("'25");
        s2.setRollVerified(true);
        s2.setRating(5.0);
        s2.setPeerSalesCount(8);
        s2.setReplyTime("~5m");
        s2.setPhone("+91 98112 34567");
        s2.setAvatar("https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=160&q=80");
        l2.setSeller(s2);
        l2.setCreatedAt(Instant.now().minusSeconds(14400));
        memoryListings.add(l2);

        // 3. Higher Engineering Mathematics
        Listing l3 = new Listing();
        l3.setId("CM-1002");
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
        l3.setSellerId("usr-priya-1");
        l3.setSeller(s2);
        l3.setCreatedAt(Instant.now().minusSeconds(18000));
        memoryListings.add(l3);
    }

    public Listing createListing(ListingRequest request, String sellerId) {
        User seller = null;
        try {
            seller = userService.getProfile(sellerId);
        } catch (Exception ignored) {}

        Listing listing = new Listing();
        listing.setId("CM-" + (System.currentTimeMillis() % 100000));
        populateListingFields(listing, request);

        listing.setSellerId(sellerId);
        SellerSummary summary;
        if (seller != null) {
            summary = new SellerSummary(seller);
        } else {
            summary = new SellerSummary();
            summary.setId(sellerId);
            summary.setName("Rohan Varma (You)");
            summary.setRole("Student");
            summary.setDepartment(request.getDepartment() != null ? request.getDepartment() : "Computer Science");
            summary.setBatch("'28");
            summary.setRollVerified(true);
            summary.setRating(5.0);
            summary.setPeerSalesCount(1);
            summary.setReplyTime("~5m");
            summary.setPhone(request.getPhone() != null && !request.getPhone().isBlank() ? request.getPhone() : "+91 98765 43210");
        }

        if (request.getPhone() != null && !request.getPhone().isBlank()) {
            summary.setPhone(request.getPhone().trim());
        }
        listing.setSeller(summary);
        listing.setCreatedAt(Instant.now());
        listing.setUpdatedAt(Instant.now());

        memoryListings.add(0, listing);

        try {
            return listingRepository.save(listing);
        } catch (Exception e) {
            log.warn("MongoDB save failed: {}. Preserved in in-memory session.", e.getMessage());
            return listing;
        }
    }

    public List<Listing> getAllListings(
            String search,
            String category,
            String department,
            String semester,
            String condition,
            Integer minPrice,
            Integer maxPrice,
            String sellerId,
            Boolean isSold,
            String sortBy
    ) {
        try {
            List<Listing> dbResults = listingRepository.findWithFilters(
                    search, category, department, semester, condition,
                    minPrice, maxPrice, sellerId, isSold, sortBy
            );
            if (dbResults != null && !dbResults.isEmpty()) {
                return dbResults;
            }
        } catch (Exception e) {
            log.warn("MongoDB query failed, serving from memory store: {}", e.getMessage());
        }

        // In-memory filter fallback
        return memoryListings.stream().filter(l -> {
            if (isSold != null && l.isSold() != isSold) return false;
            if (sellerId != null && !sellerId.isBlank() && !sellerId.equals(l.getSellerId())) return false;
            if (category != null && !category.equalsIgnoreCase("All") && !l.getCategory().equalsIgnoreCase(category)) return false;
            if (minPrice != null && minPrice > 0 && l.getPrice() < minPrice) return false;
            if (maxPrice != null && maxPrice > 0 && l.getPrice() > maxPrice) return false;
            if (condition != null && !condition.isBlank() && !l.getCondition().toLowerCase().contains(condition.toLowerCase())) return false;

            if (search != null && !search.isBlank()) {
                String q = search.toLowerCase();
                boolean matches = l.getTitle().toLowerCase().contains(q) ||
                        l.getDescription().toLowerCase().contains(q) ||
                        l.getCategory().toLowerCase().contains(q) ||
                        (l.getDepartment() != null && l.getDepartment().toLowerCase().contains(q));
                if (!matches) return false;
            }
            return true;
        }).sorted((a, b) -> {
            if ("low-to-high".equalsIgnoreCase(sortBy)) {
                return Integer.compare(a.getPrice(), b.getPrice());
            } else if ("high-to-low".equalsIgnoreCase(sortBy)) {
                return Integer.compare(b.getPrice(), a.getPrice());
            }
            return b.getCreatedAt().compareTo(a.getCreatedAt());
        }).collect(Collectors.toList());
    }

    public Listing getListingById(String id) {
        try {
            var dbListing = listingRepository.findById(id);
            if (dbListing.isPresent()) return dbListing.get();
        } catch (Exception ignored) {}

        return memoryListings.stream()
                .filter(l -> l.getId().equals(id))
                .findFirst()
                .orElseThrow(() -> new ResourceNotFoundException("Listing not found with id: " + id));
    }

    public Listing updateListing(String id, ListingRequest request, String currentUserId) {
        Listing listing = getListingById(id);

        if (!listing.getSellerId().equals(currentUserId)) {
            throw new UnauthorizedException("You can only edit your own listings");
        }

        populateListingFields(listing, request);
        if (request.getPhone() != null && !request.getPhone().isBlank() && listing.getSeller() != null) {
            listing.getSeller().setPhone(request.getPhone().trim());
        }
        listing.setUpdatedAt(Instant.now());

        try {
            return listingRepository.save(listing);
        } catch (Exception e) {
            return listing;
        }
    }

    public Listing markAsSold(String id, String currentUserId) {
        Listing listing = getListingById(id);

        if (!listing.getSellerId().equals(currentUserId)) {
            throw new UnauthorizedException("You can only change status for your own listings");
        }

        listing.setSold(true);
        listing.setUpdatedAt(Instant.now());

        try {
            return listingRepository.save(listing);
        } catch (Exception e) {
            return listing;
        }
    }

    public void deleteListing(String id, String currentUserId) {
        Listing listing = getListingById(id);

        if (!listing.getSellerId().equals(currentUserId)) {
            throw new UnauthorizedException("You can only delete your own listings");
        }

        memoryListings.removeIf(l -> l.getId().equals(id));
        try {
            listingRepository.delete(listing);
        } catch (Exception ignored) {}
    }

    public List<Listing> getListingsBySeller(String sellerId) {
        try {
            List<Listing> list = listingRepository.findBySellerIdOrderByCreatedAtDesc(sellerId);
            if (list != null && !list.isEmpty()) return list;
        } catch (Exception ignored) {}

        return memoryListings.stream()
                .filter(l -> sellerId.equals(l.getSellerId()))
                .collect(Collectors.toList());
    }

    private void populateListingFields(Listing listing, ListingRequest request) {
        listing.setTitle(request.getTitle().trim());
        listing.setCategory(request.getCategory().trim());
        if (request.getCondition() != null) listing.setCondition(request.getCondition().trim());
        listing.setConditionDetail(request.getConditionDetail());
        listing.setPrice(request.getPrice());
        listing.setOriginalPrice(request.getOriginalPrice());

        if (request.getOriginalPrice() > request.getPrice()) {
            int discount = (int) Math.round(
                    ((double) (request.getOriginalPrice() - request.getPrice()) / request.getOriginalPrice()) * 100
            );
            listing.setDiscountPercent(discount);
        } else {
            listing.setDiscountPercent(0);
        }

        if (request.getImages() != null && !request.getImages().isEmpty()) {
            listing.setImages(request.getImages());
        }

        listing.setDepartment(request.getDepartment());
        listing.setSemester(request.getSemester());
        listing.setSubjectCode(request.getSubjectCode());
        listing.setLocation(request.getLocation());
        if (request.getHandoverType() != null) listing.setHandoverType(request.getHandoverType());
        listing.setDescription(request.getDescription());
        listing.setInspectionPerk(request.getInspectionPerk());
        listing.setNegotiable(request.isNegotiable());
        listing.setFeatured(request.isFeatured());
    }
}
