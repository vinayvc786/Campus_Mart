# Campus Mart - Project Overview & System Architecture

## 1. Executive Summary

**Campus Mart** is a specialized peer-to-peer marketplace designed specifically for engineering colleges and university campuses. Unlike generic classifieds, Campus Mart is purpose-built around academic lifecycles:
- **Academic Equipment Re-use:** Drafters, scientific calculators (e.g., Casio fx-991EX), lab coats, dissection boxes, and Arduino kits.
- **Textbooks & Records:** Core branch books, approved lab manuals, and previous year question banks organized by Semester and Department.
- **Trust & Campus Safety:** Roll-number verified student badges, direct WhatsApp/call coordination, and campus-landmark exchange points (e.g., "Library Foyer", "Canteen Ground Floor", "Main Gate").

---

## 2. Technology Stack Breakdown

| Tier | Technology | Key Libraries & Frameworks | Description |
| :--- | :--- | :--- | :--- |
| **Web Frontend** | React 19, TypeScript, Vite 8 | Tailwind CSS v4, Lucide React, Framer Motion | Modern, lightweight, fast web application with device-preview frame toggle. |
| **Mobile Frontend** | Flutter 3.x, Dart 3.x | Google Fonts, CachedNetworkImage, http, intl, url_launcher | Cross-platform mobile app targeting Android and iOS with Material 3 styling. |
| **Backend API** | Java 21 LTS, Spring Boot 3.3.4 | Spring Security, JJWT 0.12.6, Spring Data MongoDB, Cloudinary | Robust enterprise REST service managing authentication, listings, filtering, and media. |
| **Database** | MongoDB Atlas / Local MongoDB | Spring Data Mongo Criteria Queries | Flexible NoSQL document store with compound text indexes for search. |
| **Media Storage** | Cloudinary API | Cloudinary Java SDK | High-performance CDN for user-uploaded product images with fallback support. |

---

## 3. High-Level Workflows

### 3.1 Authentication Flow
```
User (Client)              Spring Boot API (/api/auth)             MongoDB Atlas
     |                                    |                              |
     |---- POST /register (Details) ----->|                              |
     |                                    |--- Check Duplicate Email --->|
     |                                    |<-- User Exists / OK ---------|
     |                                    |--- Hash Password (BCrypt) -->|
     |                                    |--- Insert User Document ---->|
     |                                    |<-- Insert OK ----------------|
     |                                    |--- Generate JWT Token ------>|
     |<--- 201 Created + JWT Token -------|                              |
     |                                    |                              |
     |---- GET /api/auth/me (Bearer) ---->|                              |
     |                                    |--- Validate JWT Token ------>|
     |<--- 200 OK (User Profile) ---------|                              |
```

### 3.2 Listing & Search Flow
```
Student Seller                       Spring Boot API                       MongoDB
     |                                      |                                 |
     |--- POST /api/upload (Multipart) ---->| (Upload to Cloudinary CDN)      |
     |<-- Image URL ------------------------|                                 |
     |                                      |                                 |
     |--- POST /api/products (JSON) ------->|                                 |
     |    (Title, Price, Dept, Sem, etc.)   |--- Save Listing Record -------->|
     |<-- 201 Created (Listing ID) ---------|<-- Save Success ----------------|
     |                                      |                                 |
Student Buyer                               |                                 |
     |--- GET /api/products?dept=CSE&sem=4->|                                 |
     |                                      |--- Dynamic Criteria Query ----->|
     |<-- Filtered Listings List -----------|<-- Document Matches ------------|
```

---

## 4. Repository Structure

```
CampusMart/
├── details/                    # Comprehensive system documentation
│   ├── README.md               # Master documentation index
│   ├── PROJECT_OVERVIEW.md     # Architecture & system summary
│   ├── FRONTEND_WEB_ANALYSIS.md# Web client breakdown
│   ├── FRONTEND_FLUTTER_ANALYSIS.md # Flutter client breakdown
│   ├── BACKEND_ANALYSIS.md     # Spring Boot server breakdown
│   ├── API_SPECIFICATION.md    # REST API contracts
│   └── DATABASE_SCHEMA.md      # Data models & queries
├── src/                        # React 19 Web Application
│   ├── components/             # Reusable UI modules (Header, BottomNav, Views, etc.)
│   ├── data/                   # Initial fallback mock dataset
│   ├── types.ts                # TypeScript domain models
│   ├── App.tsx                 # Core application shell & state coordinator
│   ├── main.tsx                # Entry point
│   └── index.css               # Styling definitions
├── flutter_project/            # Flutter 3 Mobile Application
│   ├── lib/
│   │   ├── data/               # Local campus mock dataset
│   │   ├── models/             # Dart domain models
│   │   ├── screens/            # Home, Sell, Saved, Profile, Auth screens
│   │   ├── services/           # ApiService singleton with auto-IP detection
│   │   ├── theme/              # Material 3 colors, typography, shapes
│   │   └── widgets/            # Bottom sheets, custom cards
│   ├── pubspec.yaml            # Flutter dependencies
│   └── android/ ios/ etc.      # Platform configurations
├── backend/                    # Spring Boot 3.3.4 Backend
│   ├── src/main/java/          # Java source code
│   │   └── com/campusmart/backend/
│   │       ├── config/         # Cloudinary, DataSeeder configurations
│   │       ├── controller/     # Auth, Product, Upload REST controllers
│   │       ├── dto/            # Request and Response transfer objects
│   │       ├── exception/      # Centralized exception handling
│   │       ├── model/          # MongoDB document entities
│   │       ├── repository/     # Custom & Spring Data Mongo repositories
│   │       ├── security/       # JWT Filters, SecurityFilterChain, JwtUtil
│   │       └── service/        # Business logic services
│   ├── src/main/resources/     # application.properties
│   └── pom.xml                 # Maven build dependencies
├── package.json                # Web frontend dependencies & scripts
├── vite.config.ts              # Vite bundler configuration
└── README.md                   # Root project readme
```

---

## 5. Local Development Quickstart

### 5.1 Starting the Spring Boot Backend
```bash
cd backend
./mvnw spring-boot:run
# Backend will boot on http://localhost:8080
```

### 5.2 Starting the React Web Frontend
```bash
npm install
npm run dev
# Web application will serve on http://localhost:3000
```

### 5.3 Starting the Flutter Mobile App
```bash
cd flutter_project
flutter pub get
flutter run
# Select your Android Emulator, iOS Simulator, or Chrome
```
