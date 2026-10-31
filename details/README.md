# Campus Mart - Project Architecture & Technical Documentation

Welcome to the technical documentation repository for **Campus Mart**, a verified student-to-student peer marketplace engineered for college campuses.

---

## 📑 Documentation Index

| Document | Purpose & Description |
| :--- | :--- |
| **[PROJECT_OVERVIEW.md](./PROJECT_OVERVIEW.md)** | System overview, architectural patterns, tech stack summary, setup guides, and cross-platform communication. |
| **[FRONTEND_WEB_ANALYSIS.md](./FRONTEND_WEB_ANALYSIS.md)** | Full architectural breakdown of the React 19 + Vite web application, state management, component hierarchy, and design system. |
| **[FRONTEND_FLUTTER_ANALYSIS.md](./FRONTEND_FLUTTER_ANALYSIS.md)** | Deep analysis of the Flutter 3 client app, Material 3 design, screen workflows, offline fallback, and platform-adaptive API layer. |
| **[BACKEND_ANALYSIS.md](./BACKEND_ANALYSIS.md)** | Complete analysis of the Spring Boot 3.3.4 + Java 21 backend, Spring Security, Stateless JWT, BCrypt, Cloudinary service, and custom MongoDB queries. |
| **[API_SPECIFICATION.md](./API_SPECIFICATION.md)** | REST API contract, authentication schemes, endpoint routes, JSON payloads, query parameters, and error status codes. |
| **[DATABASE_SCHEMA.md](./DATABASE_SCHEMA.md)** | MongoDB document schemas (`users`, `listings`), compound indexes, text search indexing, and embedded subdocuments. |

---

## 🏛 High-Level Architecture Overview

```
                      +---------------------------------------+
                      |             CLIENT APPS               |
                      +---------------------------------------+
                           /                             \
                          /                               \
                         v                                 v
        +--------------------------------+   +--------------------------------+
        |        Web Frontend            |   |       Flutter Mobile App       |
        |  - React 19 + TypeScript       |   |  - Flutter 3 (Android/iOS)     |
        |  - Vite + Tailwind CSS         |   |  - Material 3 Design System    |
        |  - Dynamic Filter & Sort       |   |  - Dynamic Device IP Switcher  |
        +--------------------------------+   +--------------------------------+
                         \                                 /
                          \        REST API (JSON)        /
                           +--------------+--------------+
                                          |
                                          v
                      +---------------------------------------+
                      |         SPRING BOOT BACKEND           |
                      |  - Java 21 LTS + Spring Boot 3.3.4    |
                      |  - Spring Security (Stateless JWT)    |
                      |  - DataSeeder with Sample Inventory   |
                      |  - Multipart File Upload Handler      |
                      +---------------------------------------+
                                   /             \
                                  /               \
                                 v                 v
                 +-----------------------+   +------------------------+
                 |    MongoDB Atlas      |   |       Cloudinary       |
                 | - Users Collection    |   | - Product Image CDN    |
                 | - Listings Collection |   | - Automatic Fallback   |
                 | - Compound Text Index |   +------------------------+
                 +-----------------------+
```

---

## 🚀 Key Features

1. **Student Verification & Trust:** Peer profiles display department, batch, roll number verification badge, ratings, and average reply speed.
2. **Campus-Specific Filtering:** Tailored for college curriculum—filter items by department (CSE, ECE, Mech, Civil, IT), semester (1st through 8th), and condition.
3. **Dual Client Support:** Native mobile experience via Flutter and fast desktop/mobile web portal via React.
4. **Resilient Data Architecture:** Seamless transition between local seed datasets and live Spring Boot REST endpoints.
