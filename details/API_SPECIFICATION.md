# Campus Mart - REST API Specification

## 1. Overview & Base URLs

The Campus Mart backend exposes a standard JSON REST API. All endpoints are prefixed under `/api`.

| Environment | Base URL |
| :--- | :--- |
| **Local Web / iOS / Desktop** | `http://localhost:8080/api` |
| **Android Emulator** | `http://10.0.2.2:8080/api` |
| **Production Server** | `https://api.campusmart.yourdomain.com/api` |

---

## 2. Standard Envelope Format

All responses follow a consistent `ApiResponse<T>` structure:

### Success Response
```json
{
  "success": true,
  "message": "Operation completed successfully",
  "data": { ... }
}
```

### Error Response
```json
{
  "success": false,
  "message": "Detailed error explanation",
  "data": null
}
```

---

## 3. Authentication Endpoints (`/api/auth`)

### 3.1 Register New Student
- **Method / Path:** `POST /api/auth/register`
- **Auth Required:** No
- **Request Body:**
```json
{
  "name": "Vinay Kumar",
  "email": "vinay@srkr.edu.in",
  "password": "SecurePassword123",
  "phone": "+91 98765 43210",
  "department": "Computer Science",
  "batch": "'26",
  "college": "SRKR Engg College",
  "rollNumber": "22A91A05XX"
}
```
- **Response (201 Created):**
```json
{
  "success": true,
  "message": "Registration successful",
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "user": {
      "id": "6724a1b...",
      "name": "Vinay Kumar",
      "email": "vinay@srkr.edu.in",
      "phone": "+91 98765 43210",
      "department": "Computer Science",
      "batch": "'26",
      "isRollVerified": true,
      "rating": 5.0,
      "peerSalesCount": 0
    }
  }
}
```

### 3.2 Login Student
- **Method / Path:** `POST /api/auth/login`
- **Auth Required:** No
- **Request Body:**
```json
{
  "email": "vinay@srkr.edu.in",
  "password": "SecurePassword123"
}
```
- **Response (200 OK):** Same payload as registration, containing JWT token.

### 3.3 Get Current User Profile
- **Method / Path:** `GET /api/auth/me`
- **Auth Required:** Yes (`Bearer <token>`)
- **Response (200 OK):** User object of currently logged in student.

---

## 4. Product / Listing Endpoints (`/api/products`)

### 4.1 Search & Filter Listings
- **Method / Path:** `GET /api/products` (also `/api/listings`)
- **Auth Required:** No
- **Query Parameters:**
  - `search` (string): Text keyword search across title, description, subject code.
  - `category` (string): E.g., `Calculators`, `Drafters`, `Books`.
  - `department` (string): Academic department (e.g. `Computer Science`, `Mechanical`).
  - `semester` (string): E.g., `3rd Sem`, `5th Sem`.
  - `condition` (string): `New`, `Like New`, `Good`, `Fair`.
  - `minPrice` (int): Minimum price in INR.
  - `maxPrice` (int): Maximum price in INR.
  - `sellerId` (string): Filter items posted by specific student.
  - `isSold` (boolean): `true` or `false` (default: `false`).
  - `sortBy` (string): `recommended`, `low-to-high`, `high-to-low`, `newest`.

- **Response (200 OK):**
```json
{
  "success": true,
  "message": null,
  "data": [
    {
      "id": "CM-1001",
      "title": "Casio fx-991EX ClassWiz Scientific Calculator",
      "category": "Calculators",
      "condition": "Like New",
      "conditionDetail": "Scratch-less LCD, original hard slip-on case included",
      "price": 850,
      "originalPrice": 1495,
      "discountPercent": 43,
      "images": ["https://images.unsplash.com/..."],
      "department": "All Branches",
      "semester": "1st - 8th Sem",
      "subjectCode": "MATH-101",
      "location": "Central Library Foyer",
      "handoverType": "In-person handover",
      "isNegotiable": true,
      "isFeatured": true,
      "isSold": false,
      "seller": {
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
    }
  ]
}
```

### 4.2 Get Listing by ID
- **Method / Path:** `GET /api/products/{id}`
- **Auth Required:** No
- **Response (200 OK):** Single `Listing` object.

### 4.3 Create New Listing
- **Method / Path:** `POST /api/products`
- **Auth Required:** Yes (`Bearer <token>`)
- **Request Body (`ListingRequest`):**
```json
{
  "title": "Engineering Mechanics Mini Drafter (Omega)",
  "category": "Drafters",
  "condition": "Good",
  "conditionDetail": "Steel clamping knob intact, dual scale clean",
  "price": 320,
  "originalPrice": 650,
  "images": ["https://res.cloudinary.com/..."],
  "department": "Mechanical",
  "semester": "1st - 2nd Sem",
  "subjectCode": "ME-102",
  "location": "Workshop Building Ground Floor",
  "handoverType": "In-person handover",
  "description": "Used only for 1 semester during Engg Graphics. Includes clamp.",
  "inspectionPerk": "Test clamp on my drawing board before payment",
  "isNegotiable": true
}
```
- **Response (201 Created):** Created `Listing` object.

### 4.4 Update Listing
- **Method / Path:** `PUT /api/products/{id}`
- **Auth Required:** Yes (Owner only)
- **Response (200 OK):** Updated `Listing` object.

### 4.5 Mark Product as Sold
- **Method / Path:** `PATCH /api/products/{id}/sold`
- **Auth Required:** Yes (Owner only)
- **Response (200 OK):** Updated listing with `isSold: true`.

### 4.6 Delete Listing
- **Method / Path:** `DELETE /api/products/{id}`
- **Auth Required:** Yes (Owner only)
- **Response (200 OK):** Success deletion acknowledgment.

---

## 5. Media Upload Endpoint (`/api/upload`)

### 5.1 Upload Product Image
- **Method / Path:** `POST /api/upload`
- **Auth Required:** Optional / Public
- **Content-Type:** `multipart/form-data`
- **Body Field:** `file` (binary image file)
- **Response (200 OK):**
```json
{
  "success": true,
  "message": "Image uploaded successfully",
  "data": {
    "url": "https://res.cloudinary.com/campusmart/image/upload/v1729800000/listing_img.jpg"
  }
}
```
