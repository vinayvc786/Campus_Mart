package com.campusmart.backend.model;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.CompoundIndex;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.Duration;
import java.time.Instant;
import java.util.ArrayList;
import java.util.List;

@Document(collection = "listings")
@CompoundIndex(name = "search_idx", def = "{'title': 'text', 'description': 'text', 'category': 'text', 'department': 'text'}")
public class Listing {
    @Id
    private String id;

    private String title;
    private String category;
    private String condition = "Like New";
    private String conditionDetail;
    private int price;
    private int originalPrice;
    private int discountPercent;
    private List<String> images = new ArrayList<>();
    private String department;
    private String semester;
    private String subjectCode;

    @Indexed
    private String sellerId;

    private SellerSummary seller;
    private String location;
    private String handoverType = "In-person handover";
    private String description;
    private String inspectionPerk;
    private boolean isNegotiable = true;
    private boolean isFeatured = false;
    private boolean isSold = false;

    private Instant createdAt = Instant.now();
    private Instant updatedAt = Instant.now();

    public Listing() {}

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getCondition() {
        return condition;
    }

    public void setCondition(String condition) {
        this.condition = condition;
    }

    public String getConditionDetail() {
        return conditionDetail;
    }

    public void setConditionDetail(String conditionDetail) {
        this.conditionDetail = conditionDetail;
    }

    public int getPrice() {
        return price;
    }

    public void setPrice(int price) {
        this.price = price;
    }

    public int getOriginalPrice() {
        return originalPrice;
    }

    public void setOriginalPrice(int originalPrice) {
        this.originalPrice = originalPrice;
    }

    public int getDiscountPercent() {
        return discountPercent;
    }

    public void setDiscountPercent(int discountPercent) {
        this.discountPercent = discountPercent;
    }

    public List<String> getImages() {
        return images;
    }

    public void setImages(List<String> images) {
        this.images = images != null ? images : new ArrayList<>();
    }

    public String getDepartment() {
        return department;
    }

    public void setDepartment(String department) {
        this.department = department;
    }

    public String getSemester() {
        return semester;
    }

    public void setSemester(String semester) {
        this.semester = semester;
    }

    public String getSubjectCode() {
        return subjectCode;
    }

    public void setSubjectCode(String subjectCode) {
        this.subjectCode = subjectCode;
    }

    public String getSellerId() {
        return sellerId;
    }

    public void setSellerId(String sellerId) {
        this.sellerId = sellerId;
    }

    public SellerSummary getSeller() {
        return seller;
    }

    public void setSeller(SellerSummary seller) {
        this.seller = seller;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getHandoverType() {
        return handoverType;
    }

    public void setHandoverType(String handoverType) {
        this.handoverType = handoverType;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getInspectionPerk() {
        return inspectionPerk;
    }

    public void setInspectionPerk(String inspectionPerk) {
        this.inspectionPerk = inspectionPerk;
    }

    public boolean isNegotiable() {
        return isNegotiable;
    }

    public void setNegotiable(boolean negotiable) {
        isNegotiable = negotiable;
    }

    public boolean isFeatured() {
        return isFeatured;
    }

    public void setFeatured(boolean featured) {
        isFeatured = featured;
    }

    public boolean isSold() {
        return isSold;
    }

    public void setSold(boolean sold) {
        isSold = sold;
    }

    public Instant getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Instant createdAt) {
        this.createdAt = createdAt;
    }

    public Instant getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Instant updatedAt) {
        this.updatedAt = updatedAt;
    }

    // Helper property to match Flutter model listedTimeAgo
    public String getListedTimeAgo() {
        if (createdAt == null) return "Recently";
        Duration diff = Duration.between(createdAt, Instant.now());
        long minutes = diff.toMinutes();
        if (minutes < 1) return "Just now";
        if (minutes < 60) return minutes + "m ago";
        long hours = diff.toHours();
        if (hours < 24) return hours + " hours ago";
        long days = diff.toDays();
        if (days == 1) return "1 day ago";
        return days + " days ago";
    }
}
