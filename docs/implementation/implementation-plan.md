# Implementation Plan — Ozon-Style E-Commerce (iOS, UIKit MVVM-C)

> Build order (bottom-up so each layer compiles against the one below):
> Scaffold → Tokens → Models/Repository → Coordinators skeleton → shared chrome →
> components → ViewModels → screens (Catalog → Favorites → Cart → Home → Profile)
> → detail + navigation → imagery → final pass. Each task has acceptance criteria;
> nothing is "done" until its criteria pass. Screenshot-verify each screen against
> the reference before starting the next.

## Phase 0 — Project scaffold

**T0. Create the Xcode project (XcodeGen).**
- `project.yml`: app target `OzonStyle` (UIKit, programmatic; `LaunchScreen` only),
  iOS 17 deployment target, no third-party packages; a `bundle.ui-testing` target
  `OzonStyleUITests` + a shared scheme with the test action.
- `App/AppDelegate.swift` + `App/SceneDelegate.swift`; the scene builds the
  `UIWindow` and starts `AppCoordinator`.
- Acceptance: `xcodegen generate` then build/run an empty app on an iOS 17+ sim.

## Phase 1 — Design tokens

**T1. `UIColor+Tokens.swift`, `Layout.swift`, `Typography.swift`, `Brand.swift`.**
- Source: `design-system.md` §1–3, §7 (use table values verbatim).
- Colors asset-catalog backed (12 color sets). Typography = `UIFont` factory wrapped
  in `UIFontMetrics`. `Brand` holds wordmark + brand colors.
- Acceptance: a scratch VC renders all 12 colors + 10 type styles; `window.tintColor`
  = `brandPrimary`. No compile errors.

## Phase 2 — Models & data

**T2. Models.** `Product` (+ `ProductBadge`), `Category`, `QuickAction`,
`SettingsItem`, `Banner` — all `Hashable` (identity via `id`).
- Source: `architecture.md` §3. Acceptance: types compile; usable as diffable IDs.

**T3. `SampleData.swift`.** All mock content centralized: `watch`, `pedicure`,
`swimwear` per spec §2; `recommended` (≥6), `viewed`, `banners` (4), `categories`
(18, exact order), `quickActions` (6), `settings` (5).
- Acceptance: changing `watch.salePrice` here changes it on every screen.

## Phase 3 — Service + Coordinators skeleton

**T4. `Services/ProductRepository.swift`.** Protocol + `SampleDataRepository`.
- Acceptance: every collection is reachable via the protocol; `SampleData` is not
  referenced anywhere else (red-line #7 / F4 precursor).

**T5. Coordinators.** `Coordinator` protocol; `AppCoordinator` (composition root:
builds repo, 5 VMs once available, `UITabBarController`, 5 `TabCoordinator`s);
`TabCoordinator` (owns a `UINavigationController`, `start()`, `showProduct(_:)`);
`AppRoute`.
- Acceptance: app launches into a 5-tab bar with placeholder VCs; `SceneDelegate`
  retains `AppCoordinator`; tab switching works (F1).

## Phase 4 — Shared chrome

**T6. `AppLogoHeaderView.swift`.** Centered pill 30pt, brand capsule, white wordmark.
- Acceptance: top inset = `safeAreaTop + 8`; pill below the status bar (red-line #1).

**T7. `ProductImageView.swift`.** Asset load with `searchFill` + `photo` fallback.
- Acceptance: a bogus asset name renders the placeholder, never blank/crash (F6/N6).

**T8. `SearchBarView.swift`** (+ `SearchTrailing`). Per `design.md` §3.1.
- Acceptance: height 52, radius 14, correct trailing icons per fill variant.

## Phase 5 — Components

**T9. `ProductCardCell.swift`** (+ `ProductCardVariant`) — the keystone. §3.2.
- Sub-views: `PriceBlockView` (§3.3), `RatingRowView` (§3.4, ru pluralization),
  `CTAButton` (§3.5). Whole cell = one a11y element (`productCard`, button trait).
- Acceptance: configures `watch` (badge + discount + urgency + dots), `pedicure`
  (none), favorite vs non-favorite heart; `prepareForReuse` resets overlays.

**T10. Remaining components.** `CategoryCardCell` (§3.6, height 188, `categoryCard`
a11y id), `FilterChipView`/`SortChip` (§3.7), `QuickActionCell` (§3.8),
`SettingsRowView` (§3.9), `SectionHeaderView` (§3.10, boundary supplementary),
`PrimaryButton`/`SoftButton` (§3.11).
- Acceptance: each matches its spec metrics in an isolated harness VC.

## Phase 6 — ViewModels

**T11. Five ViewModels** (no `UIKit` import), repository-injected:
`HomeViewModel` (banners/quickActions/recommended + `@Published bannerIndex` +
`advanceBanner()` + 3s Combine timer), `CatalogViewModel`, `FavoritesViewModel`
(featured + recommended), `CartViewModel` (viewed + `isEmpty`), `ProfileViewModel`
(settings + recommended).
- Acceptance: each exposes exactly the data its screen needs; unit-constructable
  with a `SampleDataRepository`.

## Phase 7 — Screens (build + verify each before the next)

> Each screen = a `UIViewController` with one `UICollectionView`
> (`UICollectionViewCompositionalLayout` + diffable data source), bound to its VM,
> created and pushed by its `TabCoordinator`. After each: build → screenshot →
> compare to reference → run that screen's checks in `validation-plan.md`.

**T12. CatalogViewController** (Screen 2). Simplest; validates grid math + logo.
- Acceptance: centered logo; 3-col grid, 18 categories in order; computed
  (fractional) card width; red-line #5.

**T13. FavoritesViewController** (Screen 3).
- Acceptance: filter row; compact left-aligned featured `watch`; 2-col grid;
  red-line #2.

**T14. CartViewController** (Screen 4, empty).
- Acceptance: full-width empty band on `backgroundApp` (not inset card); auto-width
  "Войти"; 2-col `viewed` grid; red-line #3.

**T15. HomeViewController** (Screen 1).
- Acceptance: gradient header (logo + city + Войти pill + white search + hero +
  countdown), all inside the gradient; paging carousel with dots; quick-actions
  rail (6, order); "Рекомендуем" 2-col grid; red-lines #6.

**T16. ProfileViewController** (Screen 5).
- Acceptance: two separate white grouped sections; 96pt gradient avatar; primary +
  soft buttons; settings rows (KZT pill + chevrons + hairlines); recommendations
  grid; red-line #4.

## Phase 8 — Detail + navigation

**T17. `ProductDetailViewController` + wiring.**
- Reuses `ProductImageView`/`PriceBlockView`/`RatingRowView`/`CTAButton`. Cards call
  the screen's `onSelectProduct` → `TabCoordinator.showProduct` → push
  (`AppRoute.productDetail`). Detail shows the nav bar + back; tab roots hide it.
- Acceptance: tapping a card from any product tab pushes detail; back returns (F2).

## Phase 9 — Imagery & motion polish

**T18. Real imagery.** Product/quick-action images keyword-matched + downscaled
(max 200px, low JPEG). Category images = transparent cutouts (`rembg`, trimmed,
300px PNG). Acceptance: clean isolated category products; placeholder still fires
for any missing asset.

**T19. Carousel auto-advance.** VM `bannerIndex` advances every 3s and wraps; the
VC scrolls the paging section accordingly; 4 dots.
- Acceptance: dots = 4; banner auto-advances + wraps (verify via two screenshots 4s
  apart).

## Phase 10 — Final pass + tests

**T20. UI tests (`OzonStyleUITests`).** Functional: 5-tab structure, each screen's
content marker, product→detail→back from ≥2 tabs. Layout: tab bar pinned bottom,
logo pill below safe area + centered (#1), Favorites featured compact/left (#2),
Cart band full-width (#3), Home 2-col & Catalog 3-col geometry (#5) via
`XCUIElement.frame`.
- Acceptance: all tests green on iPhone 15 Pro Max (`xcodebuild test`).

**T21. Red-line sweep + Dynamic Type spot-check + `validation-report.md`.**
- Acceptance: all 8 red-lines pass on a fresh launch across tabs; bump Dynamic Type
  one step, confirm no clipped layouts / truncation holds (N2); write the report.

> New files require `xcodegen generate` before building.

## Requirements → tasks → validation traceability

| Req | Task(s)        | Validated by |
|-----|----------------|--------------|
| F1  | T5             | Tab switch check |
| F2  | T17            | Detail nav UI test |
| F3  | T9             | Red-line #7 |
| F4  | T3/T4          | Red-line #7 / repo-only access |
| F5  | T1 (Brand)     | Red-line #8 |
| F6  | T7             | Placeholder check |
| F7  | T15/T19        | Home checks, red-line #6 |
| F8  | T12            | Catalog checks, red-line #5 |
| F9  | T13            | Favorites checks, red-line #2 |
| F10 | T14            | Cart checks, red-line #3 |
| F11 | T16            | Profile checks, red-line #4 |
| F12 | T8             | SearchBar variant check |
| A1–A4 | T4/T5/T11/T17 | MVVM-C layering review |
| N3  | T6             | Red-line #1 |
| N5  | T9/T12         | Grid-math (fractional) check |
| N7  | T20            | UI test run |

## Role review notes

- **PM:** scope is intentionally minimal — reject any add beyond the detail push.
- **Developer:** never duplicate a card; reuse `ProductCardCell`. Express grid
  widths as fractional compositional groups, not pixel constants.
- **Architect:** keep the dependency direction one-way (View → VM → Repository;
  Coordinator wires them). No `UIKit` in ViewModels; no navigation in views.
- **Junior dev:** copy token values exactly from `design-system.md`; don't eyeball.
- **Tester:** the gate is visual + the 8 red-lines + the UI suite, run per-screen.
- **Reviewer:** check for inline product literals, hardcoded brand strings/hex,
  safe-area overlaps, and VCs that push other VCs (must go through a coordinator).
- **Team lead:** enforce build order; each screen verified before the next.
