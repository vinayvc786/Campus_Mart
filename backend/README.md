# Campus Mart Backend (Spring Boot + MongoDB Atlas)

Spring Boot REST API backend for the **Campus Mart** student-to-student engineering peer marketplace.

---

## 🛠 Tech Stack

- **Language:** Java 21 LTS
- **Framework:** Spring Boot 3.3.4
- **Database:** MongoDB Atlas (Spring Data MongoDB)
- **Media Storage:** Cloudinary (with automatic local data-URI fallback)
- **Security:** Spring Security + Stateless JJWT + BCrypt Password Encoding
- **Build Tool:** Maven / Maven Wrapper (`mvnw`)

---

## 📂 Project Architecture

```
backend/
├── pom.xml
├── mvnw / mvnw.cmd
├── .env.example
├── src/main/
│   ├── resources/
│   │   └── application.properties
│   └── java/com/campusmart/backend/
│       ├── CampusMartBackendApplication.java
│       ├── config/
│       │   ├── CloudinaryConfig.java
│       │   └── DataSeeder.java               # Automatic database seeder for initial products
│       ├── controller/
│       │   ├── AuthController.java           # Register, login, profile me
│       │   ├── ProductController.java        # CRUD, search, filter, mark as sold
│       │   └── UploadController.java         # Cloudinary multipart image upload
│       ├── dto/
│       │   ├── ApiResponse.java
│       │   ├── AuthResponse.java
│       │   ├── LoginRequest.java
│       │   ├── RegisterRequest.java
│       │   └── ListingRequest.java
│       ├── exception/
│       │   ├── BadRequestException.java
│       │   ├── ResourceNotFoundException.java
│       │   ├── UnauthorizedException.java
│       │   └── GlobalExceptionHandler.java
│       ├── model/
│       │   ├── Listing.java
│       │   ├── SellerSummary.java
│       │   └── User.java
│       ├── repository/
│       │   ├── ListingRepository.java
│       │   ├── ListingRepositoryCustom.java
│       │   ├── ListingRepositoryCustomImpl.java
│       │   └── UserRepository.java
│       ├── security/
│       │   ├── JwtAuthenticationFilter.java
│       │   ├── JwtUtil.java
│       │   └── SecurityConfig.java
│       └── service/
│           ├── CloudinaryService.java
│           ├── ListingService.java
│           └── UserService.java
```

---

## 🚀 Setup & Running Instructions

### 1. Prerequisites
- **Java 21 JDK** installed (`java -version`)
- **MongoDB Atlas** cluster URI (or local MongoDB on `mongodb://localhost:27017/campus_mart`)
- Optional: **Cloudinary** account credentials (if omitted, images gracefully fall back to Base64/mock URLs)

### 2. Configure Environment Variables
Copy `.env.example` to `.env` or set environment variables:

```bash
# Windows PowerShell
$env:MONGODB_URI="mongodb+srv://<username>:<password>@cluster0.abcde.mongodb.net/campus_mart?retryWrites=true&w=majority"
$env:CLOUDINARY_CLOUD_NAME="your_cloud_name"
$env:CLOUDINARY_API_KEY="your_api_key"
$env:CLOUDINARY_API_SECRET="your_api_secret"
$env:JWT_SECRET="campusMartSuperSecureSecretKeyForSigningJwtTokensMinimum256BitsLengthRequired"
$env:PORT="8080"
```

### 3. Build & Run
From the `backend` directory:

```bash
# Using Maven Wrapper (Windows)
.\mvnw.cmd spring-boot:run

# Using Maven Wrapper (Linux / macOS)
./mvnw spring-boot:run

# Or with global Maven installed
mvn spring-boot:run
```

The server will start on `http://localhost:8080`.
Upon first startup, `DataSeeder` automatically populates default campus test users (`rohan@srkr.edu.in` / `password123`) and initial engineering gear listings!

---

## 📡 REST API Documentation

### 1. Authentication APIs

#### Register New Student
* **Endpoint:** `POST /api/auth/register`
* **Body:**
```json
{
  "name": "Rohan Varma",
  "email": "rohan@srkr.edu.in",
  "password": "password123",
  "phone": "+91 98765 43210",
  "department": "Computer Science",
  "batch": "'28",
  "rollNumber": "24A91A05XX",
  "college": "SRKR Engg College"
}
```
* **Response (201 Created):**
```json
{
  "success": true,
  "message": "Registration successful",
  "data": {
    "token": "eyJhbGciOiJIUzI1NiJ9...",
    "tokenType": "Bearer",
    "user": {
      "id": "671a5f...",
      "name": "Rohan Varma",
      "email": "rohan@srkr.edu.in",
      "phone": "+91 98765 43210",
      "role": "Student",
      "department": "Computer Science",
      "batch": "'28",
      "isRollVerified": true
    }
  }
}
```

#### Login
* **Endpoint:** `POST /api/auth/login`
* **Body:**
```json
{
  "email": "rohan@srkr.edu.in",
  "password": "password123"
}
```

#### Get Current Authenticated Profile
* **Endpoint:** `GET /api/auth/me`
* **Header:** `Authorization: Bearer <TOKEN>`

---

### 2. Product / Listing APIs

#### View All Listings / Search & Filter (Public)
* **Endpoint:** `GET /api/products` (or `GET /api/listings`)
* **Query Parameters:**
  - `search`: Keyword search across title, description, category, and department (e.g., `drafter`, `calculator`)
  - `category`: Filter by category (e.g., `Drafters`, `Calculators`, `Books`, `Lab Records`)
  - `department`: Filter by department (e.g., `cs`, `mech`, `civil`, `ee`)
  - `semester`: Filter by semester (e.g., `Sem 1`, `Sem 2`, `Sem 3`)
  - `condition`: Filter by condition (`New`, `Like New`, `Good`, `Fair`)
  - `minPrice`: Minimum price in INR
  - `maxPrice`: Maximum price in INR
  - `isSold`: `false` for active only, `true` for sold
  - `sortBy`: `recommended`, `low-to-high`, `high-to-low`, `newest`

* **Example:** `GET /api/products?category=Drafters&maxPrice=500&sortBy=low-to-high`

#### View Single Product (Public)
* **Endpoint:** `GET /api/products/{id}`

#### Create Product (Seller Authenticated)
* **Endpoint:** `POST /api/products`
* **Header:** `Authorization: Bearer <TOKEN>`
* **Body:**
```json
{
  "title": "Omega Mini Drafter with Case & Clips",
  "category": "Drafters",
  "condition": "Like New",
  "conditionDetail": "1 Sem Used",
  "price": 450,
  "originalPrice": 1200,
  "images": [
    "https://res.cloudinary.com/demo/image/upload/sample.jpg"
  ],
  "department": "Engineering First Year (All Branches)",
  "semester": "Sem 1 & Sem 2",
  "subjectCode": "Engg Graphics (EG)",
  "location": "SRKR Mechanical Block / Central Library",
  "handoverType": "Campus Pickup",
  "description": "Smooth protractor head, zero wobble on tightening knob.",
  "inspectionPerk": "Bring drawing sheet to inspect calibration live.",
  "isNegotiable": true
}
```

#### Update Product (Only Seller Who Created It)
* **Endpoint:** `PUT /api/products/{id}`
* **Header:** `Authorization: Bearer <TOKEN>`
* *Note: If a user tries to edit another student's product, the backend returns `403 Forbidden`.*

#### Mark Product as Sold (Only Seller Who Created It)
* **Endpoint:** `PATCH /api/products/{id}/sold`
* **Header:** `Authorization: Bearer <TOKEN>`

#### Delete Product (Only Seller Who Created It)
* **Endpoint:** `DELETE /api/products/{id}`
* **Header:** `Authorization: Bearer <TOKEN>`

#### View Seller's Own Products
* **Endpoint:** `GET /api/products/seller/me`
* **Header:** `Authorization: Bearer <TOKEN>`

---

### 3. Image Upload API (Cloudinary)

* **Endpoint:** `POST /api/upload`
* **Content-Type:** `multipart/form-data`
* **Form Field:** `file` (Image binary: JPG, PNG, WEBP)
* **Response:**
```json
{
  "success": true,
  "message": "Image uploaded successfully",
  "data": {
    "url": "https://res.cloudinary.com/your_cloud_name/image/upload/v12345/campus_mart_products/xyz.jpg"
  }
}
```

---

## 🧪 Testing with cURL

```bash
# 1. Login
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"rohan@srkr.edu.in","password":"password123"}'

# 2. Get Public Products
curl http://localhost:8080/api/products

# 3. Search and Filter Products
curl "http://localhost:8080/api/products?search=drafter&maxPrice=600&sortBy=low-to-high"

# 4. Upload Image
curl -X POST http://localhost:8080/api/upload \
  -F "file=@/path/to/drafter.jpg"
```
