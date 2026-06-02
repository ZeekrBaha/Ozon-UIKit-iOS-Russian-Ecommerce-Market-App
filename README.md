# Ozon-Style iOS (UIKit)

A Russian-language e-commerce storefront built in **UIKit** for iOS 17+, recreating
the OZON marketplace UI from a spec + 5 reference screenshots. Structured with
**MVVM-C** (Model · View · ViewModel · Coordinator): five tabs, one reusable product
card, per-tab navigation controllers, zero dependencies. The UIKit sibling of the
[SwiftUI build](../Ozon-SwiftUI-iOS-Russian-Ecommerce-Market-App) — same screens,
tokens, and data; different framework.

> **Status: spec/plan complete — implementation not started.** This repo currently
> holds the spec-first docs (`docs/`) adapted for UIKit MVVM-C. Screenshots and the
> test suite are added once the build lands (begin at task **T0** in the plan).

---

## Screenshots

_Added after the UIKit build (see `docs/implementation/implementation-plan.md`,
Phase 7). The 5 reference screens: Home (Главная), Catalog (Каталог),
Favorites (Избранное), Cart (Корзина), Profile (Мой Ozon)._

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| UI | UIKit (iOS 17), programmatic Auto Layout, no storyboards (except `LaunchScreen`) |
| Architecture | MVVM-C — Model · View · ViewModel · Coordinator |
| Layout | `UICollectionViewCompositionalLayout` + `UICollectionViewDiffableDataSource` |
| State / binding | ViewModels + Combine (`@Published` → `sink`) |
| Navigation | `UITabBarController` + per-tab `UINavigationController`, driven by coordinators |
| Data | `ProductRepository` protocol → `SampleDataRepository` (DI seam) |
| Images | Asset-catalog imagesets + `ProductImageView` placeholder fallback |
| Project | XcodeGen (`project.yml`) |
| Tests | XCUITest — screen, navigation + layout coverage (planned) |
| Dependencies | None |

---

## Architecture

**MVVM-C.** Each layer has one job and one dependency direction (top → down):

- **Coordinator** — `AppCoordinator` is the composition root: it builds the single
  repository, all five ViewModels, the `UITabBarController`, and five
  `TabCoordinator`s (each wrapping a `UINavigationController`). A `TabCoordinator`
  creates its root VC (injecting the VM + an `onSelectProduct` closure) and pushes
  `ProductDetailViewController` on a product tap. **No view controller pushes
  another view controller.**
- **ViewModel** — one per screen, holds `@Published` state and screen logic (e.g.
  the Home carousel index + auto-advance). Depends only on `ProductRepository`;
  imports no UIKit.
- **View** — `UIViewController`s hosting a `UICollectionView` (compositional layout +
  diffable data source) and reusable cells. Render VM state, forward intent.
- **Model** — domain types behind `ProductRepository`; `SampleDataRepository`
  supplies the in-memory `SampleData` (single source of truth), swappable for a
  network/DB layer without touching any View or ViewModel.

```
┌──────────────────────────────────────────────────────────┐
│  SceneDelegate  →  AppCoordinator (composition root)      │
│    ├─ ProductRepository  (SampleDataRepository)           │
│    ├─ 5 ViewModels   (Home · Catalog · Favorites …)       │
│    ├─ UITabBarController                                  │
│    └─ 5 TabCoordinators (one UINavigationController each)  │
└───────────────────────────┬──────────────────────────────┘
                            │ injects VM + onSelectProduct
        ┌───────────────────┴───────────────────────────────┐
        │  ViewControllers (UICollectionView + diffable)     │
        │  Home · Catalog · Favorites · Cart · Profile       │
        │       │ tap card → coordinator → push              │
        │       └────────────→ ProductDetailViewController   │
        └───────────────────┬───────────────────────────────┘
        View → VM (Combine)  │ · View → Coordinator (intent)
        ┌───────────────────┴───────────────────────────────┐
        │  ViewModels  (no UIKit)                            │
        │  read via ↓                                        │
        │  ProductRepository  ←  SampleData (single source)  │
        └────────────────────────────────────────────────────┘
              composed of ↑ Components (ProductCardCell …)
```

### The keystone rule — one cell, every surface

A single `ProductCardCell` renders every product across all screens. Variants change
only the **outer cell width** (via the compositional group), never the internal
layout.

```
ProductCardCell.configure(with:variant:)
  variant ─┬─ .grid           → equal 2-up group cell   (Home/Favorites/Profile)
           ├─ .viewedGrid      → equal 2-up group cell   (Cart "Вы смотрели")
           └─ .featuredCompact → grid-card-width group + trailing spacer
                                                          (Favorites featured)

internal layout (identical for all variants):
  image (1:1, heart · badge · page-dots)
    → PriceBlockView (installment / sale+old+discount / urgency)
    → title (2-line)
    → RatingRowView (★ rating · ru-pluralized review count)
    → CTAButton (basket + delivery date)
```

### Design tokens (single source)

```
DesignSystem/
  UIColor+Tokens.swift  12 semantic colors, asset-catalog backed
                        (extension UIColor { static var brandPrimary … })
  Layout.swift          gutter=16 global · grid math as fractional groups
  Typography.swift      10 UIFont styles (UIFontMetrics for Dynamic Type)
  Brand.swift           OZON wordmark + brand colors isolated here
```

### Brand isolation

All OZON identity (wordmark, brand colors, hero lockup colors) lives in
`Brand.swift`. Screens reference `Brand.*`, never the literal `"OZON"` string or
brand hex — so the identity can be swapped without touching any screen.

---

## Project Structure (planned)

```
OzonStyle/
├── App/
│   ├── AppDelegate.swift         app lifecycle
│   └── SceneDelegate.swift       builds UIWindow, starts AppCoordinator
├── Coordinators/
│   ├── Coordinator.swift         protocol
│   ├── AppCoordinator.swift      composition root + UITabBarController
│   ├── TabCoordinator.swift      per-tab UINavigationController + showProduct
│   └── AppRoute.swift            navigation routes (→ ProductDetailViewController)
├── ViewModels/
│   ├── HomeViewModel.swift       banners/quick-actions/recommended + carousel
│   ├── CatalogViewModel · FavoritesViewModel
│   └── CartViewModel · ProfileViewModel
├── Services/
│   └── ProductRepository.swift   protocol + SampleDataRepository (DI seam)
├── DesignSystem/
│   ├── UIColor+Tokens.swift      12 semantic colors
│   ├── Layout.swift              spacing / corner constants + grid math
│   ├── Typography.swift          10 UIFont styles
│   └── Brand.swift               wordmark + brand colors (isolated)
├── Models/
│   ├── Product.swift             Product + ProductBadge (Hashable)
│   ├── Category.swift  QuickAction.swift  SettingsItem.swift  Banner.swift
│   └── SampleData.swift          ALL mock content
├── Components/                   UIView / UICollectionViewCell subclasses
│   ├── ProductCardCell.swift     keystone (+ ProductCardVariant)
│   ├── PriceBlockView · RatingRowView · CTAButton
│   ├── SearchBarView · ProductImageView · CategoryCardCell
│   ├── FilterChipView (Sort + Filter) · QuickActionCell
│   ├── SettingsRowView · SectionHeaderView · PrimaryButton (+ SoftButton)
│   └── AppLogoHeaderView.swift    centered brand pill
├── Screens/                      one UIViewController per screen
│   ├── HomeViewController.swift          gradient header + carousel + grid
│   ├── CatalogViewController.swift       3-col category grid
│   ├── FavoritesViewController.swift     filter row + compact featured + grid
│   ├── CartViewController.swift          empty-state band + "Вы смотрели"
│   ├── ProfileViewController.swift       two grouped sections + settings
│   └── ProductDetailViewController.swift pushed destination
└── Resources/
    ├── Assets.xcassets           12 color sets · AppIcon · imagesets
    └── LaunchScreen.storyboard

OzonStyleUITests/
└── (functional + layout XCUITests — every screen + nav flow)
```

---

## Setup

### Prerequisites

- Xcode 16+ , iOS 17 simulator
- [XcodeGen](https://github.com/yonaskolb/XcodeGen): `brew install xcodegen`

### Steps

```bash
git clone <repo>
cd Ozon-UIKit-iOS-Russian-Ecommerce-Market-App

xcodegen generate          # regenerates OzonStyle.xcodeproj
open OzonStyle.xcodeproj
```

The project has **no third-party packages** — it builds and runs as-is.

---

## Design fidelity & validation

Verified against the 5 reference screenshots on an iPhone 15 Pro Max simulator.
The gate is visual fidelity + an **MVVM-C layering review** + **8 binary red-lines**
+ the **XCUITest suite** (full report in
[`docs/implementation/validation-report.md`](docs/implementation/validation-report.md)):

| # | Red-line | Status |
|---|----------|--------|
| 1 | Logo pill always below the safe area | ⏳ pending build |
| 2 | Favorites featured card compact + left-aligned (never full-width) | ⏳ |
| 3 | Cart empty state is a full-width band (not an inset card) | ⏳ |
| 4 | Profile = two separate grouped sections | ⏳ |
| 5 | Catalog has the centered logo | ⏳ |
| 6 | Home hero lives inside the gradient header | ⏳ |
| 7 | One shared `Product` model + single `ProductCardCell` (no inline tiles) | ⏳ |
| 8 | Brand wordmark/colors never hardcoded in screen views | ⏳ |

---

## Tests (planned)

UI tests (`XCUITest`) will cover the full app surface — every screen, the
coordinator navigation flow (product → `ProductDetailViewController` → back), and the
visual red-lines as `XCUIElement.frame` assertions (no pixel-snapshot library →
zero-dependency). See `docs/implementation/validation-plan.md` §5.

```bash
xcodegen generate
xcodebuild test -scheme OzonStyle \
  -destination 'platform=iOS Simulator,name=iPhone 15 Pro Max'
```

---

## Known constraints (v1 prototype)

- **Mostly inert** — search bars, hearts, chips, CTAs, settings rows, and login
  buttons render fully but do nothing on tap. Interactive paths: tab switching, and
  tapping any product card pushes `ProductDetailViewController` via its tab coordinator.
- **Placeholder → real imagery** — product/category photos are low-res
  keyword-matched stand-ins (`ProductImageView` falls back to a `photo` glyph when an
  asset is missing). Category tiles use transparent cutouts.
- **Fixed-vs-scaled type** — fonts target the fixed-size reference; Dynamic Type is
  supported via `UIFontMetrics` where enabled (recorded as a deviation at sign-off).
- **IP** — the OZON wordmark, the О!РАСПРОДАЖА hero lockup, and the third-party
  stand-in photos are isolated in `Brand.swift` + the asset catalog and should be
  swapped before any non-prototype use.

---

## Documentation

Spec-first docs that drive the build live in [`docs/`](docs/):
research, requirements, design-system, design, architecture, implementation-plan,
validation-plan, validation-report, and the developer prompt — all adapted for
UIKit MVVM-C.
