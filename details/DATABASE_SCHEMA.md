# Campus Mart - Database Schema & Indexing Guide

## 1. Overview

**Campus Mart** uses **MongoDB** as its primary data store. MongoDB was selected for its native JSON handling, flexible schema evolution for diverse academic product categories, and powerful text indexing.

---

## 2. Collections Overview

```
Database: campus_mart (or MongoDB Atlas cluster)
├── users          # Student user profiles & authentication records
└── listings       # Marketplace listings with embedded seller summaries
```

---

## 3. `users` Collection

### 3.1 Schema Definition

| Field | BSON Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `_id` | ObjectId / String | Primary Key | Unique document identifier. |
| `name` | String | Required | Full name of the student. |
| `email` | String | Required, Unique | College or personal email address. |
| `password` | String | Required | BCrypt password hash (`$2a$10$...`). |
| `phone` | String | Required | WhatsApp/Phone contact number. |
| `role` | String | Default: `"Student"` | User role (`Student`, `CampusAmbassador`, `Admin`). |
| `department` | String | Default: `"Computer Science"` | Academic branch (CSE, ECE, Mech, etc.). |
| `batch` | String | Default: `"'28"` | Graduation year representation. |
| `rollNumber` | String | Default: `"24A91A05XX"` | Official university roll number. |
| `isRollVerified` | Boolean | Default: `true` | Badge indicating student roll verification. |
| `rating` | Double | Default: `5.0` | Peer review rating (1.0 to 5.0). |
| `peerSalesCount`| Integer | Default: `0` | Number of successfully completed transactions. |
| `replyTime` | String | Default: `"~5m"` | Average response speed indicator. |
| `avatar` | String | Optional | Image URL of avatar picture. |
| `college` | String | Default: `"SRKR Engg College"` | Affiliated institution name. |
| `createdAt` | Timestamp / Instant | Auto-generated | Account creation ISO timestamp. |

### 3.2 Indexes
```javascript
db.users.createIndex({ "email": 1 }, { unique: true });
```

---

## 4. `listings` Collection

### 4.1 Schema Definition

| Field | BSON Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `_id` | ObjectId / String | Primary Key | Unique product identifier (e.g., `CM-1001`). |
| `title` | String | Required | Product listing title. |
| `category` | String | Required | Academic category (Books, Drafters, Calculators, etc.). |
| `condition` | String | Default: `"Like New"` | Physical grade (`New`, `Like New`, `Good`, `Fair`). |
| `conditionDetail` | String | Optional | Specific note on wear/accessories. |
| `price` | Integer | Required | Selling price in Indian Rupees (₹). |
| `originalPrice` | Integer | Required | Original retail price for discount calculation. |
| `discountPercent` | Integer | Auto-computed | Percentage discount compared to retail. |
| `images` | Array of Strings | Required (>= 1) | CDN URLs of product photos. |
| `department` | String | Required | Academic branch target (`CSE`, `Mechanical`, `All Branches`). |
| `semester` | String | Required | Semester target (`1st Sem` through `8th Sem`). |
| `subjectCode` | String | Optional | Curriculum subject code (e.g. `CS-301`, `EC-204`). |
| `sellerId` | String | Indexed | Foreign reference to `users._id`. |
| `seller` | Embedded Object | Required | Snapshot of seller info (see `SellerSummary`). |
| `location` | String | Required | Designated campus exchange point. |
| `handoverType` | String | Default: `"In-person handover"` | Handover method. |
| `description` | String | Required | Long-form item description. |
| `inspectionPerk` | String | Optional | Trust proposition (e.g. "Test calculator before paying"). |
| `isNegotiable` | Boolean | Default: `true` | Whether seller accepts counter-offers. |
| `isFeatured` | Boolean | Default: `false` | Highlighted on home page banner. |
| `isSold` | Boolean | Default: `false` | Marked as sold once transaction completes. |
| `createdAt` | Timestamp / Instant | Auto-generated | Listing creation timestamp. |
| `updatedAt` | Timestamp / Instant | Auto-generated | Last modification timestamp. |

### 4.2 Embedded `SellerSummary` Schema
```json
{
  "id": "USR-101",
  "name": "Rohan Varma",
  "role": "Final Year",
  "department": "ECE",
  "batch": "'25",
  "isRollVerified": true,
  "rating": 4.9,
  "peerSalesCount": 14,
  "replyTime": "~5m",
  "phone": "+91 98765 43210"
}
```

### 4.3 Indexes
```javascript
// Compound text search index for fast keyword matching
db.listings.createIndex({
  "title": "text",
  "description": "text",
  "category": "text",
  "department": "text"
}, { name: "search_idx" });

// Index for seller lookup
db.listings.createIndex({ "sellerId": 1 });

// Index for filtering active unsold listings by category
db.listings.createIndex({ "isSold": 1, "category": 1, "price": 1 });
```
