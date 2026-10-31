# 🎓 Campus Mart

> **Verified Student-to-Student Peer Marketplace for Engineering Colleges & Universities**

[![License: Apache 2.0](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![Spring Boot](https://img.shields.io/badge/Spring_Boot-3.3.4-brightgreen.svg)](https://spring.io/projects/spring-boot)
[![Java](https://img.shields.io/badge/Java-21_LTS-orange.svg)](https://www.oracle.com/java/)
[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B.svg)](https://flutter.dev)
[![React](https://img.shields.io/badge/React-19-61DAFB.svg)](https://react.dev)
[![MongoDB](https://img.shields.io/badge/MongoDB-Atlas-47A248.svg)](https://www.mongodb.com)

---

## 📖 About Campus Mart

**Campus Mart** is a student peer-to-peer marketplace tailored to engineering college curriculum lifecycles. Instead of generic classifieds, Campus Mart solves common campus problems:
- **Academic Gear Re-use:** Buy and sell scientific calculators (Casio fx-991EX), mini drafters, engineering drawing sheets, lab coats, and dissection boxes.
- **Textbooks & Lab Records:** Browse verified previous-year lab manuals, semester core textbooks, and branch subject guides sorted by Department and Semester.
- **Roll Verified Profiles:** Safety-first architecture with university roll-number badges, peer reviews, and campus landmark handover coordination (e.g. "Central Library Foyer", "Canteen Ground Floor").

---

## 🏛 System Architecture

Campus Mart features a complete full-stack ecosystem:
1. **Web Frontend (`src/`):** React 19 + TypeScript + Vite with dynamic category/department filtering and mobile device frame toggle.
2. **Mobile Frontend (`flutter_project/`):** Flutter 3 client app with Material Design 3, native calling/WhatsApp coordination, and platform-aware network loopbacks (`10.0.2.2` vs `localhost`).
3. **Backend API (`backend/`):** Spring Boot 3.3.4 + Java 21 REST API powered by Spring Security, stateless JWT, dynamic MongoDB queries, and Cloudinary media storage.

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

## 📂 Detailed Documentation Folder

Comprehensive technical reports and specifications are stored in the [`details/`](./details) folder:

- **[Master Documentation Index](./details/README.md)**
- **[System Architecture & Tech Stack](./details/PROJECT_OVERVIEW.md)**
- **[React 19 Web Frontend Analysis](./details/FRONTEND_WEB_ANALYSIS.md)**
- **[Flutter 3 Mobile Frontend Analysis](./details/FRONTEND_FLUTTER_ANALYSIS.md)**
- **[Spring Boot 3 Backend Architecture](./details/BACKEND_ANALYSIS.md)**
- **[Complete REST API Specification](./details/API_SPECIFICATION.md)**
- **[MongoDB Database Schema & Indexing](./details/DATABASE_SCHEMA.md)**

---

## 🚀 Getting Started

### 1. Spring Boot Backend
```bash
cd backend
# Run backend (boots on http://localhost:8080)
./mvnw spring-boot:run
```

### 2. React Web App
```bash
# Install dependencies
npm install

# Start Vite dev server (boots on http://localhost:3000)
npm run dev
```

### 3. Flutter Mobile App
```bash
cd flutter_project
flutter pub get
flutter run
```

---

## 📄 License
This project is licensed under the Apache 2.0 License.
