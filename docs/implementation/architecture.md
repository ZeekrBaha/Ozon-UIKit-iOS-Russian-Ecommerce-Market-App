# Architecture — Ozon-Style E-Commerce (iOS, UIKit)

## 1. Approach

A **UIKit MVVM-C** app (Model · View · ViewModel · Coordinator), programmatic UI
(no storyboards except `LaunchScreen`). Each layer has one job and one dependency
direction (top → down):

- **Coordinator** owns navigation. `AppCoordinator` is the composition root; it
  builds the repository, the five ViewModels, a `UITabBarController`, and one
  `TabCoordinator` (wrapping a `UINavigationController`) per tab.
- **ViewModel** holds screen state and logic, depends only on a `ProductRepository`
  protocol, and exposes data + Combine `@Published` outputs. No `UIKit` import.
- **View** = `UIViewController` + `UICollectionView` cells/views. Renders VM state,
  forwards user intent (a product tap) to its coordinator via a closure.
- **Model** = domain types behind `ProductRepository`; `SampleDataRepository`
  supplies the in-memory `SampleData` fixtures (single source of truth), swappable
  for a network/DB layer without touching any View or ViewModel.

Binding is **Combine** (first-party, not a third-party dependency): ViewModels
publish, ViewControllers `sink` into snapshots / scroll updates.

## 2. File / group structure

```
OzonStyle/
  App/
    AppDelegate.swift           // app lifecycle (minimal)
    SceneDelegate.swift         // builds UIWindow, starts AppCoordinator

  Coordinators/
    Coordinator.swift           // protocol (navigationController, start())
    AppCoordinator.swift        // composition root: repo + VMs + UITabBarController
    TabCoordinator.swift        // per-tab: owns UINavigationController + showProduct(_:)
    AppRoute.swift              // navigation routes (→ ProductDetailViewController)

  ViewModels/
    HomeViewModel.swift         // banners/quickActions/recommended + carousel index
    CatalogViewModel.swift
    FavoritesViewModel.swift
    CartViewModel.swift         // viewed + isEmpty
    ProfileViewModel.swift      // settings + recommended

  Services/
    ProductRepository.swift     // protocol + SampleDataRepository (DI seam)

  DesignSystem/
    UIColor+Tokens.swift        // semantic colors (design-system §1), asset-backed
    Layout.swift                // spacing/corner constants + grid math (§2)
    Typography.swift            // UIFont factory, Dynamic Type via UIFontMetrics (§3)
    Brand.swift                 // wordmark name + brand colors (config switch)

  Models/
    Product.swift               // Product, ProductBadge  (Hashable for diffable)
    Category.swift              // Category   (Hashable)
    QuickAction.swift           // QuickAction (Hashable)
    SettingsItem.swift          // SettingsItem (Hashable)
    SampleData.swift            // ALL mock content lives here

  Components/                   // UIView / UICollectionViewCell subclasses
    AppLogoHeaderView.swift     // §3.2
    SearchBarView.swift         // §4.1  (+ SearchTrailing enum)
    ProductImageView.swift      // §3.0 placeholder rule
    ProductCardCell.swift       // §4.2  (+ ProductCardVariant enum)
    PriceBlockView.swift        // §4.3
    RatingRowView.swift         // §4.4  (+ ru pluralization)
    CTAButton.swift             // §4.5
    CategoryCardCell.swift      // §4.6
    FilterChipView.swift        // §4.7  (SortChip + FilterChip)
    QuickActionCell.swift       // §4.8
    SettingsRowView.swift       // §4.9
    SectionHeaderView.swift     // §4.10 (collection boundary supplementary)
    PrimaryButton.swift         // §4.11 (PrimaryButton + SoftButton configs)

  Screens/                      // one UIViewController per screen
    HomeViewController.swift          // Screen 1
    CatalogViewController.swift       // Screen 2
    FavoritesViewController.swift     // Screen 3
    CartViewController.swift          // Screen 4
    ProfileViewController.swift       // Screen 5
    ProductDetailViewController.swift // pushed destination

  Resources/
    Assets.xcassets             // colors (asset-backed tokens) + product/category/promo images
    LaunchScreen.storyboard
```

> Layout strategy (intended): each screen as a `UICollectionView` driven by
> `UICollectionViewCompositionalLayout` + `UICollectionViewDiffableDataSource`.
> Sections map to the spec (header / carousel / quick-actions / grid).
>
> **Implementation note:** the shipped v1 instead composes each screen with
> `UIScrollView` + `UIStackView` and reusable `UIView` components (the Home banner
> carousel is the one paging `UICollectionView`). Simpler/robust for static content;
> the MVVM-C layering is identical. See `validation-report.md` deviations. Also, the
> lifecycle uses `AppDelegate` (window-based) rather than `SceneDelegate`.

## 3. Data model (from spec §2)

```swift
enum ProductBadge { case salesOfWeek }   // flame.fill + "СКИДКИ НЕДЕЛИ"

struct Product: Hashable {
    let id = UUID()
    let imageName: String        // asset name; §3.0 fallback if absent
    let imageCount: Int          // page dots (1 = no dots)
    var isFavorite: Bool
    let badge: ProductBadge?
    let installmentPrice: String // "1398 ₸"
    let installmentTerm: String  // "×12 мес"
    let salePrice: String        // "16 769 ₸"
    let oldPrice: String?        // "154 967 ₸" (strikethrough)
    let discountPercent: Int?    // 89 → "-89%"
    let urgency: String?         // "218 шт осталось"
    let title: String
    let rating: Double           // 4.7
    let reviewCount: Int         // 6
    let deliveryDate: String     // "6 июня"
}

struct Category: Hashable { let id = UUID(); let title: String; let imageName: String }
struct QuickAction: Hashable { let id = UUID(); let title: String; let imageName: String }
struct SettingsItem: Hashable { let id = UUID(); let title: String; let value: String? }
```

> Models are `Hashable` (identity via `id`) so they can be section/item identifiers
> in a `UICollectionViewDiffableDataSource` and travel inside an `AppRoute`.

### SampleData (single source; reuse instances across screens)

- `watch` — favorite, `.salesOfWeek` badge, -89%, "218 шт осталось". (Home/Favorites/Cart)
- `pedicure` — not favorite, no badge, no discount/urgency.
- `swimwear` — favorite, "Купальник раздельный…".
- `recommended: [Product]` — ≥6 (bikini, watches, wallet/clutch, …) reusing the above + simple additions.
- `viewed: [Product]` — `[watch, pedicure, swimwear, …]`.
- `banners: [Banner]` — 4 full-bleed promo images (Home carousel).
- `categories: [Category]` — 18, exact order (see design.md Screen 2).
- `quickActions: [QuickAction]` — 6 (see design.md Screen 1).
- `settings: [SettingsItem]` — 5 (Валюта=KZT, Цвет приложения, Язык, Помощь, О приложении).

`SampleData` is reached only through `ProductRepository` — no ViewController or
ViewModel references it directly.

## 4. Component reuse map (the keystone rule)

| Screen     | Uses `ProductCardCell` variant | Grid |
|------------|--------------------------------|------|
| Home       | `.grid`                        | 2-col `recommended` |
| Favorites  | `.featuredCompact` (1) + `.grid` | featured + 2-col `recommended` |
| Cart       | `.viewedGrid`                  | 2-col `viewed` |
| Profile    | `.grid`                        | 2-col `recommended` |
| Catalog    | — (uses `CategoryCardCell`)    | 3-col `categories` |

`ProductCardVariant`: `.grid`, `.featuredCompact`, `.viewedGrid`. All variants
share **identical internal cell layout**; only the outer cell width differs (the
compositional layout gives `.featuredCompact` a grid-card-width group with a
trailing spacer, instead of an equal 2-up group).

## 5. Navigation & state (MVVM-C)

- **`AppCoordinator`** builds a `UITabBarController` whose 5 view controllers are
  the `UINavigationController`s owned by 5 `TabCoordinator`s, and holds the
  repository + all ViewModels. It is retained by `SceneDelegate`.
- **`TabCoordinator`** creates its root `UIViewController` (injecting the VM and a
  `showProduct` closure) and pushes `ProductDetailViewController` when a product is
  tapped (`AppRoute.productDetail`).
- **ViewModels** are plain `final class`es exposing data synchronously (static
  fixtures) plus Combine `@Published` outputs for anything dynamic (e.g. the Home
  carousel index). ViewControllers subscribe with `AnyCancellable`s.
- **Interactive behavior:** tab switching, and tapping any product card pushes the
  detail screen. Everything else (hearts, chips, search, settings rows) is inert.

## 6. Shared chrome rules (spec §3)

- **Safe area (HARD):** first content top inset = `safeAreaTop + 8` (the collection
  view's content/section insets respect `safeAreaLayoutGuide`). Logo pill always
  below the status bar. On Home the logo sits inside the gradient (still below the
  status bar).
- **AppLogoHeaderView:** centered, pill height 30pt, brand-blue capsule, white
  wordmark from `Brand`. Used on Catalog/Favorites/Cart/Profile and inside the Home
  gradient header.
- **Image placeholder (HARD):** `ProductImageView.setImage(named:)` renders the
  `searchFill` background + SF Symbol `photo` fallback when the asset is missing —
  never blank, never crash.
