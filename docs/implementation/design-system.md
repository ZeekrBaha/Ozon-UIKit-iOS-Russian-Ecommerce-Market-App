# Design System — Ozon-Style E-Commerce (iOS, UIKit)

> This is the single source of truth for all tokens. Reuse this block **verbatim**
> in every screen spec and every implementation prompt. If a value isn't here,
> it isn't a token — do not invent ad-hoc spacing/colors in a view.

## 1. Color tokens — `UIColor+Tokens.swift` (semantic names, asset-catalog backed)

| Token              | Hex       | Use                                            |
|--------------------|-----------|------------------------------------------------|
| `brandPrimary`     | `#005BFF` | active tab, primary buttons, links, CTAs       |
| `brandPrimarySoft` | `#E4EEFF` | soft / secondary buttons                       |
| `priceSale`        | `#F0117E` | sale price, discount, urgency                  |
| `priceInstallment` | `#F59E0B` | installment price                              |
| `ratingStar`       | `#FFA800` | rating star                                    |
| `textPrimary`      | `#001A34` | titles, prices, body                           |
| `textSecondary`    | `#707F8D` | captions, secondary labels                     |
| `backgroundApp`    | `#F2F3F7` | app background                                 |
| `surfaceCard`      | `#FFFFFF` | cards, grouped sections                        |
| `searchFill`       | `#F4F6FA` | search bars, chips, category tiles             |
| `buttonDark`       | `#050505` | Home "Войти" pill, countdown pill              |
| `separator`        | `#E8EAEE` | list dividers                                  |

- Exposed as `extension UIColor { static var brandPrimary: UIColor { UIColor(named: "brandPrimary")! } … }`.
- Set `window.tintColor = .brandPrimary` (and the tab bar's tint) at app root.
- App background is `backgroundApp` everywhere except inside white surfaces.
- All colors are asset-catalog backed (so light/dark and brand swap are localized).

## 2. Spacing & layout — `Layout.swift`

```
gutter         = 16   // global horizontal screen inset — used EVERYWHERE
sectionSpacing = 24   // vertical gap between sections
gridSpacing    = 12   // inter-item gap in all grids
cardSpacing    = 12   // inter-item gap in 2-col product grid
cornerCard     = 14
cornerImage    = 12
cornerSearch   = 14
cornerButtonLg = 16
cornerButtonSm = 12
cornerSheet    = 24   // rounded bottom corners of gradient/grouped sections
```

> **Decision:** one global `gutter = 16` overrides the draft's scattered "24-ish."
> Applies to Home header row, all search bars, all grids, and Profile buttons.

**Grid math (compute, never eyeball):**
- 2-col product grid card width = `(screenW - 2*gutter - cardSpacing) / 2`
- 3-col category grid card width = `(screenW - 2*gutter - 2*gridSpacing) / 3`
- In `UICollectionViewCompositionalLayout`, express columns as fractional-width
  items in a horizontal group, with `contentInsets`/`interItemSpacing` = the tokens
  above and section `contentInsets.leading/trailing = gutter`. The fractional split
  reproduces the formulas without hardcoding pixel widths.

## 3. Typography — `Typography.swift` (system `UIFont`, Dynamic Type via `UIFontMetrics`)

| Style          | Size / Weight   | Use                                                            |
|----------------|-----------------|----------------------------------------------------------------|
| `screenTitle`  | 30 / bold       | Profile "Войдите в личный кабинет"                             |
| `sectionTitle` | 28 / bold       | "Рекомендуем", "Подобрали для вас", "Вы смотрели", "Корзина пуста" |
| `priceMain`    | 16 / bold       | sale price                                                     |
| `installment`  | 15 / semibold   | installment price (orange)                                     |
| `cardTitle`    | 14 / regular    | product title (2-line truncate)                                |
| `body`         | 15 / regular    | empty-state body, subtitles                                    |
| `secondary`    | 13 / regular    | reviews, captions, old price                                   |
| `badge`        | 11 / bold       | СКИДКИ НЕДЕЛИ                                                   |
| `cta`          | 15 / semibold   | CTA button, primary buttons                                    |
| `tabLabel`     | 11 / regular    | tab bar labels                                                 |

- Exposed as `enum Typography { static func sectionTitle() -> UIFont { … } }` or a
  `UIFont` extension, built with `UIFont.systemFont(ofSize:weight:)`.
- Dynamic Type: wrap each base font in `UIFontMetrics(forTextStyle: .body).scaledFont(for:)`
  and set `label.adjustsFontForContentSizeCategory = true`; 2-line truncation
  (`numberOfLines = 2`, `.byTruncatingTail`) must not clip layout.

## 4. Shape & elevation

- Cards: `layer.cornerRadius = cornerCard` (14), `masksToBounds = true`, no heavy
  border, compact internal padding (10–12).
- Images inside cards: `cornerImage` (12), `contentMode = .scaleAspectFill`, clipped.
- Search bar: height 52, radius `cornerSearch` (14).
- CTA button (in card): height 44, radius `cornerButtonSm` (12).
- Primary/Soft buttons: height 56, radius `cornerButtonLg` (16). Prefer
  `UIButton.Configuration` (iOS 15+) for fill/title styling.
- Gradient header + grouped white sections: rounded **bottom** corners
  `cornerSheet` (24) via `CAGradientLayer` + `maskedCorners`
  (`[.layerMinXMaxYCorner, .layerMaxXMaxYCorner]`).

## 5. Icons

- Single set: **SF Symbols** via `UIImage(systemName:)`, at consistent point sizes
  (`UIImage.SymbolConfiguration`).
- Tab icons ~24pt. Card heart, badge flame, rating star, search glass, etc. as
  named in §component specs. Icon-only controls are inert but still present.

## 6. Motion

- Native `UITabBarController` tab switch + `UINavigationController` push (product →
  detail) are the standard transitions.
- One custom motion: the Home banner carousel auto-advances every 3s (Combine/`Timer`
  → `collectionView.scrollToItem`, wrapping). No other custom animations unless
  matching a reference behavior.

## 7. Brand isolation — `Brand.swift`

- Holds the wordmark image name + brand colors so the OZON identity can be swapped
  without touching screens. Screens reference `Brand`, never literals.
- `AppLogoHeaderView` reads its pill color and wordmark from `Brand`.
