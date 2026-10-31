package com.campusmart.backend.repository;

import com.campusmart.backend.model.Listing;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ListingRepository extends MongoRepository<Listing, String>, ListingRepositoryCustom {
    List<Listing> findBySellerIdOrderByCreatedAtDesc(String sellerId);
    List<Listing> findByIsSoldFalseOrderByCreatedAtDesc();
}
