package com.campusmart.backend.controller;

import com.campusmart.backend.dto.ApiResponse;
import com.campusmart.backend.dto.ListingRequest;
import com.campusmart.backend.model.Listing;
import com.campusmart.backend.service.ListingService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping({"/api/products", "/api/listings"})
public class ProductController {

    private final ListingService listingService;

    public ProductController(ListingService listingService) {
        this.listingService = listingService;
    }

    // 1. Create a product (Authenticated seller)
    @PostMapping
    public ResponseEntity<ApiResponse<Listing>> createProduct(
            @Valid @RequestBody ListingRequest request,
            Authentication authentication
    ) {
        String sellerId = (String) authentication.getPrincipal();
        Listing created = listingService.createListing(request, sellerId);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.ok("Product listed successfully on Campus Mart", created));
    }

    // 2. View, search, and filter all products (Public)
    @GetMapping
    public ResponseEntity<ApiResponse<List<Listing>>> getAllProducts(
            @RequestParam(required = false) String search,
            @RequestParam(required = false) String category,
            @RequestParam(required = false) String department,
            @RequestParam(required = false) String semester,
            @RequestParam(required = false) String condition,
            @RequestParam(required = false) Integer minPrice,
            @RequestParam(required = false) Integer maxPrice,
            @RequestParam(required = false) String sellerId,
            @RequestParam(required = false) Boolean isSold,
            @RequestParam(required = false, defaultValue = "recommended") String sortBy
    ) {
        List<Listing> listings = listingService.getAllListings(
                search, category, department, semester, condition,
                minPrice, maxPrice, sellerId, isSold, sortBy
        );
        return ResponseEntity.ok(ApiResponse.ok(listings));
    }

    // 3. View single product by ID (Public)
    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<Listing>> getProductById(@PathVariable String id) {
        Listing listing = listingService.getListingById(id);
        return ResponseEntity.ok(ApiResponse.ok(listing));
    }

    // 4. Update product (Seller only)
    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<Listing>> updateProduct(
            @PathVariable String id,
            @Valid @RequestBody ListingRequest request,
            Authentication authentication
    ) {
        String currentUserId = (String) authentication.getPrincipal();
        Listing updated = listingService.updateListing(id, request, currentUserId);
        return ResponseEntity.ok(ApiResponse.ok("Product updated successfully", updated));
    }

    // 5. Mark as sold (Seller only)
    @PatchMapping("/{id}/sold")
    public ResponseEntity<ApiResponse<Listing>> markAsSold(
            @PathVariable String id,
            Authentication authentication
    ) {
        String currentUserId = (String) authentication.getPrincipal();
        Listing updated = listingService.markAsSold(id, currentUserId);
        return ResponseEntity.ok(ApiResponse.ok("Product marked as sold", updated));
    }

    // 6. Delete product (Seller only)
    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> deleteProduct(
            @PathVariable String id,
            Authentication authentication
    ) {
        String currentUserId = (String) authentication.getPrincipal();
        listingService.deleteListing(id, currentUserId);
        return ResponseEntity.ok(ApiResponse.ok("Product deleted successfully", null));
    }

    // 7. Get seller's own products
    @GetMapping("/seller/me")
    public ResponseEntity<ApiResponse<List<Listing>>> getMyProducts(Authentication authentication) {
        String currentUserId = (String) authentication.getPrincipal();
        List<Listing> myListings = listingService.getListingsBySeller(currentUserId);
        return ResponseEntity.ok(ApiResponse.ok(myListings));
    }
}
