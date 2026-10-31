package com.campusmart.backend.repository;

import com.campusmart.backend.model.Listing;
import java.util.List;

public interface ListingRepositoryCustom {
    List<Listing> findWithFilters(
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
    );
}
