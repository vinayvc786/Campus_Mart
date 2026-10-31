# Frontend Flutter Analysis - Flutter 3 & Material 3

## 1. Overview

The mobile application for **Campus Mart** is located in `frontend/flutter/`. It is a production-ready **Flutter 3** application designed for cross-platform deployment on **Android** and **iOS**, with complete support for Material Design 3 guidelines.

---

## 2. Dependencies & Build Configuration (`pubspec.yaml`)

```yaml
dependencies:
  flutter:
    sdk: flutter
  google_fonts: ^6.1.0        # Plus Jakarta Sans / Inter typography
  url_launcher: ^6.2.1        # Direct peer calls and WhatsApp integration
  cached_network_image: ^3.3.0# Smooth image loading with disk caching
  intl: ^0.19.0               # Currency and date formatting (INR ₹)
  http: ^1.2.0                # REST API communication
```

---

## 3. Architecture & Project Layout

```
frontend/flutter/
├── lib/
│   ├── data/
│   │   └── mock_data.dart                 # High-fidelity offline fallback items
│   ├── models/
│   │   └── listing.dart                   # Data classes: Listing, Seller, FilterState
│   ├── screens/
│   │   ├── auth_screen.dart               # Student registration & login forms
│   │   ├── home_screen.dart               # Grid browse, category filter & search
│   │   ├── listing_detail_screen.dart     # Detailed inspection & contact triggers
│   │   ├── profile_screen.dart            # Verified user dashboard & seller items
│   │   ├── saved_screen.dart              # Wishlist & bookmarked inventory
│   │   └── sell_screen.dart               # Multi-step gear listing wizard
│   ├── services/
│   │   └── api_service.dart               # Singleton REST client with auto-IP detection
│   ├── theme/
│   │   └── app_theme.dart                 # Material 3 colors, typography, button styles
│   ├── widgets/
│   │   └── filter_sort_bottom_sheet.dart  # Interactive filter & sort modal
│   └── main.dart                          # Application entry & navigation shell
├── pubspec.yaml                           # Flutter dependencies & assets
└── android/ ios/ macos/ windows/ web/     # Platform target runners
```
```

---

## 4. Platform-Aware Networking Layer (`api_service.dart`)

One of the standout architectural patterns in the Flutter application is **dynamic loopback resolution**:

```dart
static String get defaultBaseUrl {
  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    // Android emulator routes host machine loopback to 10.0.2.2
    return 'http://10.0.2.2:8080/api';
  }
  // iOS simulator, desktop, and web use standard localhost
  return 'http://localhost:8080/api';
}
```

### 4.1 Resilient Fallback Strategy
When starting the app (`main.dart`):
1. `ApiService.fetchProducts()` attempts to load listings from the live Spring Boot server.
2. If the backend is running, live MongoDB data populates the app.
3. If the backend server is offline or unreachable, the app catches the exception and immediately falls back to `mock_data.dart`, ensuring an uninterrupted user and reviewer experience.

---

## 5. Screen Implementations

### 5.1 `HomeScreen` (`home_screen.dart`)
- **Institution Header:** Visual badge for college affiliation.
- **Search Header:** Text query listener and modal filter trigger.
- **Category Chips:** Horizontal scrolling list for fast branch selection (Books, Drafters, Calculators, Lab Records, Stationery, etc.).
- **Product Card Grid:** Staggered dual-column card display showing image thumbnail, title, price with discount tag, seller verified tick, and instant bookmark toggle.

### 5.2 `ListingDetailScreen` (`listing_detail_screen.dart`)
- **Image Pager:** Interactive image viewing.
- **Verified Student Card:** Shows seller department, graduation batch, peer rating, and response time.
- **Handover Details:** Clear campus landmark meetup instructions (e.g., "Civil Dept Foyer", "Canteen").
- **Direct Connect Buttons:**
  - `tel:<phone>`: Native phone dialer invocation.
  - `https://wa.me/<phone>?text=...`: Direct WhatsApp conversation with pre-filled product inquiry.

### 5.3 `SellScreen` (`sell_screen.dart`)
- Form with validation for academic category, condition, original vs. selling price, and negotiable indicator.
- Connects directly to `ApiService.createProduct()` when authenticated, or appends locally if offline.

### 5.4 `AuthScreen` (`auth_screen.dart`)
- Tabbed interface switching between **Login** and **Register**.
- College email field validation ensuring official student credentials.
- Stores JWT token in memory for authenticated requests.

