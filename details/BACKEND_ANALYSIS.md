# Backend Architecture Analysis - Spring Boot 3 & MongoDB Atlas

## 1. Overview

The backend service for **Campus Mart** is located in `/backend`. It is an enterprise **Spring Boot 3.3.4** application built on **Java 21 LTS**, utilizing **MongoDB Atlas** for document persistence, **Spring Security** with **JJWT 0.12.6** for stateless authentication, and **Cloudinary** for image storage.

---

## 2. Technical Stack & Dependencies (`pom.xml`)

| Dependency | Version | Purpose |
| :--- | :--- | :--- |
| `spring-boot-starter-web` | 3.3.4 | Embedded Tomcat, Spring MVC REST controllers |
| `spring-boot-starter-data-mongodb` | 3.3.4 | Object-Document Mapping and MongoTemplate queries |
| `spring-boot-starter-security` | 3.3.4 | Filter chain, endpoint access rules, BCrypt encoder |
| `spring-boot-starter-validation` | 3.3.4 | Jakarta bean validation (`@NotNull`, `@Email`, etc.) |
| `io.jsonwebtoken:jjwt-api / impl` | 0.12.6 | HMAC SHA-256 JWT generation and token verification |
| `com.cloudinary:cloudinary-http44` | 1.38.0 | Media upload to Cloudinary CDN |

---

## 3. Package Structure

```
backend/src/main/java/com/campusmart/backend/
├── config/
│   ├── CloudinaryConfig.java             # Cloudinary singleton client setup
│   └── DataSeeder.java                   # Auto-populates sample inventory on fresh boot
├── controller/
│   ├── AuthController.java               # /api/auth (register, login, me)
│   ├── ProductController.java            # /api/products (CRUD, filter, search)
│   └── UploadController.java             # /api/upload (multipart image handler)
├── dto/
│   ├── ApiResponse.java                  # Generic JSON wrapper {success, message, data}
│   ├── AuthResponse.java                 # Token & user profile payload
│   ├── ListingRequest.java               # Validation schema for creating/updating listings
│   ├── LoginRequest.java                 # Email + password input DTO
│   └── RegisterRequest.java              # Student registration DTO
├── exception/
│   ├── BadRequestException.java          # 400 Bad Request
│   ├── ResourceNotFoundException.java    # 404 Not Found
│   ├── UnauthorizedException.java        # 401 Unauthorized
│   └── GlobalExceptionHandler.java       # Centralized @RestControllerAdvice
├── model/
│   ├── Listing.java                      # @Document(collection = "listings")
│   ├── SellerSummary.java                # Embedded seller profile snapshot
│   └── User.java                         # @Document(collection = "users")
├── repository/
│   ├── ListingRepository.java            # MongoRepository interface
│   ├── ListingRepositoryCustom.java      # Custom criteria query interface
│   ├── ListingRepositoryCustomImpl.java  # Dynamic query builder using MongoTemplate
│   └── UserRepository.java               # User lookup by email
├── security/
│   ├── JwtAuthenticationFilter.java      # OncePerRequestFilter parsing Bearer tokens
│   ├── JwtUtil.java                      # Token signing, claim extraction & validation
│   └── SecurityConfig.java               # CORS policy, CSRF disabled, Route security rules
└── service/
    ├── CloudinaryService.java            # Cloudinary upload with Base64 fallback
    ├── ListingService.java               # Listing lifecycle management
    └── UserService.java                  # Registration, BCrypt hashing, JWT generation
```

---

## 4. Security Architecture (`SecurityConfig.java` & `JwtAuthenticationFilter.java`)

### 4.1 Stateless JWT Authentication
- **Session Policy:** Configured as `SessionCreationPolicy.STATELESS`.
- **Public Routes:**
  - `POST /api/auth/register` & `POST /api/auth/login`
  - `GET /api/products/**` and `GET /api/listings/**` (read-only search is open to all students)
  - `POST /api/upload` (for media previews)
- **Protected Routes:**
  - `POST /api/products` (requires valid student JWT)
  - `PUT /api/products/{id}` (requires student JWT & ownership verification)
  - `PATCH /api/products/{id}/sold` (requires owner verification)
  - `DELETE /api/products/{id}` (requires owner verification)
  - `GET /api/auth/me` (requires student JWT)

### 4.2 Security Pipeline
```
Incoming HTTP Request
       │
       ▼
[CorsFilter] ──── Accepts requests from localhost:3000, Vite dev ports
       │
       ▼
[JwtAuthenticationFilter]
  ├── Reads 'Authorization: Bearer <token>'
  ├── Validates signature via JwtUtil with HMAC SHA-256
  └── Injects Authentication (userId principal) into SecurityContextHolder
       │
       ▼
[Controller Layer] ──── Accesses authenticated principal via Authentication object
```

---

## 5. Dynamic Query Engine (`ListingRepositoryCustomImpl.java`)

Rather than static queries, Campus Mart uses Spring Data MongoDB's `MongoTemplate` to construct dynamic `Criteria` expressions:

```java
Criteria criteria = new Criteria();
List<Criteria> subCriteria = new ArrayList<>();

// 1. Text search across title, description, and subject code
if (search != null && !search.isBlank()) {
    subCriteria.add(new Criteria().orOperator(
        Criteria.where("title").regex(search, "i"),
        Criteria.where("description").regex(search, "i"),
        Criteria.where("subjectCode").regex(search, "i")
    ));
}

// 2. Department & Semester matching
if (department != null && !department.equalsIgnoreCase("All")) {
    subCriteria.add(Criteria.where("department").is(department));
}

// 3. Price boundary filtering
if (minPrice != null || maxPrice != null) {
    Criteria priceCriteria = Criteria.where("price");
    if (minPrice != null) priceCriteria.gte(minPrice);
    if (maxPrice != null) priceCriteria.lte(maxPrice);
    subCriteria.add(priceCriteria);
}
```

---

## 6. Media Service & Graceful Fallback (`CloudinaryService.java`)

To ensure smooth operation even when third-party cloud credentials are not supplied:
1. If `CLOUDINARY_CLOUD_NAME` is configured, images are uploaded directly to Cloudinary CDN and the secure HTTPS URL is stored.
2. If credentials are empty (local testing/dev), `CloudinaryService` converts the uploaded image into an in-memory Base64 data-URI or returns a placeholder image URL, preventing 500 crashes during onboarding.
