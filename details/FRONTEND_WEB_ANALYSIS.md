# Frontend Web Analysis - React 19 & TypeScript

## 1. Overview

The web client for **Campus Mart** is built using **React 19**, **TypeScript**, and **Vite 8**, styled with **Tailwind CSS v4** and enriched with **Lucide React** icons and **Framer Motion** transitions. It provides an ultra-responsive interface designed with a mobile-first philosophy while accommodating desktop browsers with an optional mobile-device frame toggle.

---

## 2. Directory & Component Structure

```
web/
├── src/
│   ├── components/
│   │   ├── BottomNav.tsx          # 4-tab sticky bottom navigation bar
│   │   ├── FilterSortSheet.tsx    # Slide-up modal for filtering & sorting
│   │   ├── Header.tsx             # Campus selector, search input & mic trigger
│   │   ├── ListingDetailView.tsx  # Full product view with seller trust metrics
│   │   ├── ProfileView.tsx        # User profile, verified status & active listings
│   │   ├── SavedView.tsx          # Bookmarked items collection
│   │   ├── SellView.tsx           # Product creation & upload form
│   │   └── Toast.tsx              # Transient notification component
│   ├── data/
│   │   └── mockData.ts            # Realistic campus dataset & default categories
│   ├── types.ts                   # TypeScript interfaces & domain types
│   ├── App.tsx                    # Central state coordinator & view router
│   ├── main.tsx                   # ReactDOM entrypoint
│   └── index.css                  # Global Tailwind CSS definitions
├── public/                        # Static assets & images
├── index.html                     # Application HTML entry point
├── package.json                   # Dependencies & build scripts
├── tsconfig.json                  # TypeScript compiler configuration
└── vite.config.ts                 # Vite bundler configuration
```

---

## 3. Core State Management (`App.tsx`)

`App.tsx` functions as the single source of truth for the web application, handling client-side routing, filtering, search execution, and persistence:

### 3.1 Key State Variables
- `activeTab`: `'home' | 'saved' | 'sell' | 'profile'` - Controls primary navigation.
- `selectedListing`: `Listing | null` - When populated, renders the full-screen `ListingDetailView`.
- `savedIds`: `string[]` - Set of saved listing IDs for the user's wishlist.
- `filterState`: Encapsulates search query, price bounds, academic department, semester, condition, and sorting criterion.
- `isDeviceFrame`: Toggle allowing desktop users to view the app wrapped in an iPhone-style chassis or expanded full-width.
- `toastMessage`, `isToastVisible`: Global notification queue.

### 3.2 Dynamic Filtering Logic
The application uses React's `useMemo` hook to filter items with sub-millisecond latency:
1. **Category Filter:** Matches category name or passes all if `'All'`.
2. **Text Search:** Matches query string against product title, description, department, and subject code.
3. **Price Bounds:** Evaluates `listing.price >= minPrice && listing.price <= maxPrice`.
4. **Condition & Academic Attributes:** Matches Department and Semester tags.
5. **Sorting:** Applies ordering by `recommended`, `low-to-high`, `high-to-low`, or `newest`.

---

## 4. Component Deep Dive

### 4.1 `Header.tsx`
- **Campus Selector:** Displays active institution (e.g., "SRKR Engg College") with easy location awareness.
- **Search & Mic:** Integrated search input with simulated voice search trigger and animated speech detection banner.

### 4.2 `FilterSortSheet.tsx`
- **Modal Drawer:** Slides up from the bottom with background backdrop blur.
- **Academic Department Pills:** CSE, ECE, Mechanical, Civil, IT, AI&DS.
- **Condition Matrix:** 'New', 'Like New', 'Good', 'Fair'.
- **Price Range Control:** Interactive dual slider with real-time price count preview.

### 4.3 `ListingDetailView.tsx`
- **Product Gallery:** Multi-image preview carousel with zoom and aspect ratio preservation.
- **Seller Trust Card:** Displays the seller's roll verification badge (`isRollVerified`), department, batch, rating (e.g., 4.9★), and response time (`~5m`).
- **Direct Peer Actions:** WhatsApp message launcher and direct call launcher pre-populated with inquiry template.
- **Campus Exchange Warning:** Safety badge reminding students to meet in public campus zones (Canteen, Library, Hostels).

### 4.4 `SellView.tsx`
- Form for posting gear with automatic calculation of discount percentage from original price.
- Pre-filled academic attributes (Department, Semester, Subject code).
- Condition description and negotiable flag toggle.

### 4.5 `SavedView.tsx` & `ProfileView.tsx`
- Quick access to bookmarked items with instant un-save capability.
- Profile dashboard showing listings created by the authenticated student, total earnings, and verified student ID card preview.

