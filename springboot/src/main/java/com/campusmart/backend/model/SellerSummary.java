package com.campusmart.backend.model;

public class SellerSummary {
    private String id;
    private String name;
    private String avatar;
    private String role;
    private String department;
    private String batch;
    private boolean isRollVerified;
    private double rating;
    private int peerSalesCount;
    private String replyTime;
    private String phone;

    public SellerSummary() {}

    public SellerSummary(User user) {
        if (user != null) {
            this.id = user.getId();
            this.name = user.getName();
            this.avatar = user.getAvatar();
            this.role = user.getRole();
            this.department = user.getDepartment();
            this.batch = user.getBatch();
            this.isRollVerified = user.isRollVerified();
            this.rating = user.getRating();
            this.peerSalesCount = user.getPeerSalesCount();
            this.replyTime = user.getReplyTime();
            this.phone = user.getPhone();
        }
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getDepartment() {
        return department;
    }

    public void setDepartment(String department) {
        this.department = department;
    }

    public String getBatch() {
        return batch;
    }

    public void setBatch(String batch) {
        this.batch = batch;
    }

    public boolean isRollVerified() {
        return isRollVerified;
    }

    public void setRollVerified(boolean rollVerified) {
        isRollVerified = rollVerified;
    }

    public double getRating() {
        return rating;
    }

    public void setRating(double rating) {
        this.rating = rating;
    }

    public int getPeerSalesCount() {
        return peerSalesCount;
    }

    public void setPeerSalesCount(int peerSalesCount) {
        this.peerSalesCount = peerSalesCount;
    }

    public String getReplyTime() {
        return replyTime;
    }

    public void setReplyTime(String replyTime) {
        this.replyTime = replyTime;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }
}
