---
name: Campus Mart
colors:
  surface: '#fbf8ff'
  surface-dim: '#dad9e4'
  surface-bright: '#fbf8ff'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f4f2fe'
  surface-container: '#eeedf8'
  surface-container-high: '#e8e7f2'
  surface-container-highest: '#e3e1ed'
  on-surface: '#1a1b23'
  on-surface-variant: '#474554'
  inverse-surface: '#2f3038'
  inverse-on-surface: '#f1effb'
  outline: '#787586'
  outline-variant: '#c8c4d7'
  surface-tint: '#5746d6'
  primary: '#422ec2'
  on-primary: '#ffffff'
  primary-container: '#5b4bdb'
  on-primary-container: '#e0dbff'
  inverse-primary: '#c6c0ff'
  secondary: '#006c49'
  on-secondary: '#ffffff'
  secondary-container: '#6cf8bb'
  on-secondary-container: '#00714d'
  tertiary: '#005724'
  on-tertiary: '#ffffff'
  tertiary-container: '#007231'
  on-tertiary-container: '#5cfc89'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#e4dfff'
  primary-fixed-dim: '#c6c0ff'
  on-primary-fixed: '#150066'
  on-primary-fixed-variant: '#3e28be'
  secondary-fixed: '#6ffbbe'
  secondary-fixed-dim: '#4edea3'
  on-secondary-fixed: '#002113'
  on-secondary-fixed-variant: '#005236'
  tertiary-fixed: '#66ff8e'
  tertiary-fixed-dim: '#3de273'
  on-tertiary-fixed: '#002109'
  on-tertiary-fixed-variant: '#005322'
  background: '#fbf8ff'
  on-background: '#1a1b23'
  surface-variant: '#e3e1ed'
typography:
  headline-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
  headline-lg-mobile:
    fontFamily: Plus Jakarta Sans
    fontSize: 26px
    fontWeight: '700'
    lineHeight: 34px
  headline-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 22px
    fontWeight: '600'
    lineHeight: 28px
  headline-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 24px
  title-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 16px
    fontWeight: '600'
    lineHeight: 22px
  body-lg:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  body-sm:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '400'
    lineHeight: 16px
  label-lg:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 20px
  label-md:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
  label-sm:
    fontFamily: Inter
    fontSize: 11px
    fontWeight: '600'
    lineHeight: 14px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  gutter: 0.75rem
  gutter-desktop: 1.5rem
  margin: 1rem
  margin-desktop: 2rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 1rem
  space-lg: 1.5rem
  space-xl: 2rem
---

## Brand & Style
The design system establishes a high-trust, student-to-student peer marketplace optimized for mobile-first Android interactions (360–430dp). The brand tone balances academic credibility with youthful, vibrant commerce—moving away from cluttered classified boards into an organized, app-native campus trading hub.

The visual style merges Material Design 3 surface logic with modern, crisp consumer-app aesthetics. It leverages clean surfaces, intentional micro-interactions, distinct categorical color tagging, and structured item hierarchy. The interface prioritizes swift visual scanning of gear condition, price fairness, and instant chat initiation without unnecessary decorative noise.

## Colors
The palette utilizes an energetic, academic royal indigo as the primary anchor, paired with fresh emerald mint for transactional validation and success states. A dedicated communication green provides immediate recognition for off-app transaction coordination.

- **Primary (`#5B4BDB`):** Drives top app bars, primary actions, selected navigation items, and active state indicators.
- **Secondary (`#10B981` / `#059669`):** Represents verified student badges, active price highlights, and secondary confirmation flows.
- **Tertiary / Action Accent (`#25D366`):** Dedicated exclusively to buyer-to-seller communication actions (e.g., "Chat on WhatsApp"), establishing an unmissable call-to-action standard across all listing screens.
- **Background & Surfaces:** App canvas is grounded on `#F7F7FC`, avoiding stark blue light fatigue while contrasting against `#FFFFFF` elevated cards.
- **Condition Tonal Tokens:**
  - *Like New:* `#ECFDF5` surface with `#047857` label.
  - *Good:* `#EFF6FF` surface with `#1D4ED8` label.
  - *Fair:* `#FFFBEB` surface with `#B45309` label.

## Typography
The system employs **Plus Jakarta Sans** for headlines and title-level pricing displays to convey a friendly, energetic, and contemporary collegiate tone. **Inter** handles all long-form item descriptions, meta attributes, condition flags, and transactional buttons to maximize legibility on dense mobile viewports.

Letter spacing remains tight (`-0.01em` to `-0.02em`) on display titles to conserve horizontal space for long academic titles (e.g., "Advanced Engineering Mathematics 10th Ed"). Tabular numeric settings are mandatory for pricing tags to prevent layout shifts across item feeds.

## Layout & Spacing
Designed primarily for mobile screen widths ranging from 360dp to 430dp, utilizing a 4-column fluid layout on mobile viewports with `16px` outer canvas margins and `12px` column gutters. 

- **Grid Behavior:** Marketplace feeds default to a 2-column card arrangement on devices $\ge$ 360dp width. Single-column lists take over for user profile histories, purchase trackers, and notification panels.
- **Rhythm & Padding:** Component interiors strictly adhere to a 4dp/8dp base unit increment. Inner card padding matches `space-sm` (8px) for media containers and `space-md` (16px) for textual content wrappers.
- **Safe Areas:** Screens account for the Android navigation bar and standard system status bar with dynamic bottom padding extending to `space-xl` when sticky floating action buttons or bottom sheets are mounted.

## Elevation & Depth
Elevation in this system uses ambient lighting combined with hairline structure to maintain clean separation without heavy drop-shadows.

- **Level 0 (Canvas):** Flat `#F7F7FC` background without borders or shadows.
- **Level 1 (Listing Cards, Filter Chips):** Pure `#FFFFFF` surface accompanied by a subtle border (`1px solid rgba(118, 118, 128, 0.12)`) and a restrained ambient drop shadow: `0px 2px 8px rgba(91, 75, 219, 0.04)`.
- **Level 2 (Active Cards, Floating App Bar):** `#FFFFFF` surface with an elevated shadow: `0px 4px 16px rgba(18, 18, 23, 0.08)`.
- **Level 3 (Bottom Navigation Bar, WhatsApp CTA Dock):** Grounded floating layers featuring an upward diffuse shadow: `0px -4px 20px rgba(0, 0, 0, 0.05)`, backed by `backdrop-filter: blur(12px)` when scrolling over feed items.
- **Level 4 (Modals, Condition Filter Bottom Sheets):** Elevated sheet with `0px 8px 32px rgba(0, 0, 0, 0.16)` paired with a 40% `#0B0B14` scrim.

## Shapes
Surfaces feature a modern, generous curvature that feels approachable and distinctly mobile-native. 

Standard cards, image containers, input fields, and bottom sheet containers utilize a base 16px radius (`rounded-lg`), scaling to 20px–24px (`rounded-xl`) for main modal dialogues, contextual pop-up menus, and active product preview cards. Circular shapes (full pill, 9999px) are strictly reserved for condition indicators, status chips, count badges, and compact action buttons.

## Components

### Buttons
- **Primary Action:** Solid `#5B4BDB` background, white label, full-width or compact, with a 16px corner radius and 48px standard touch height.
- **WhatsApp Direct Connect:** Solid `#25D366` surface with contrasting white text and WhatsApp SVG icon; placed persistently at the bottom of listing detail views.
- **Secondary / Tertiary Buttons:** Tonal backgrounds using primary-light (`rgba(91, 75, 219, 0.08)`) with `#5B4BDB` labels, or ghost styles with zero fill and 1px border.

### Condition Chips & Status Badges
- Compact pill-shaped elements (`rounded-full`) with `4px 10px` internal padding.
- Text uses `label-sm` in all-caps or title case:
  - **Like New:** Mint tint `#ECFDF5`, text `#047857`.
  - **Good:** Soft blue tint `#EFF6FF`, text `#1D4ED8`.
  - **Fair:** Amber tint `#FFFBEB`, text `#B45309`.
- Includes verified student badge: `#10B981` fill checkmark inside an 8-point star or circle.

### Marketplace Listing Cards
- Built on a white canvas with a 16px radius and hairline border (`1px solid rgba(0,0,0,0.06)`).
- Card composition:
  - 1:1 Aspect ratio photo at top, with condition badge pinned to the top-left with `8px` offset.
  - Price formatted in `title-md` using Plus Jakarta Sans bold.
  - Item title capped at 2 lines, truncated with ellipsis.
  - Bottom meta line: Campus building/hostel distance tag and upload freshness timestamp.

### Input Fields & Search
- Surface: Filled `#FFFFFF` with standard 16px radius and inset border.
- Leading icon for academic category search (e.g., "Search Drafters, Casio FX-991, Books...").
- Active focus displays a 2px outer ring in `#5B4BDB` with zero layout shift.

### Selection Controls
- Checkboxes and radio buttons adhere to a 6px corner radius and circular boundary respectively, snapping into `#5B4BDB` when active with high-contrast white glyph indicators.