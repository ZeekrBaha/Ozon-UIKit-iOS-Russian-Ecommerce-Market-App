# Design — Ozon-Style E-Commerce (iOS, UIKit)

> UX flows, screens, states, and component APIs. Tokens are in
> `design-system.md` — referenced here, never re-defined. Verified against the 5
> reference screenshots.

## 1. Flows & states

- **Primary flow:** launch → land on Home (Главная) → switch tabs via bottom bar.
- **Navigation flow:** tap any product card → push `ProductDetailViewController`
  (back button returns). Reachable from every product-bearing tab via that tab's
  coordinator.
- **States:** every screen is a single static state. There are no loading/error/auth
  states because there is no data fetching. The empty Cart is the one explicit
  "empty" state and it is the designed default (not a fallback).
- **Inert affordances:** search bars, hearts, chips, CTA buttons, settings rows,
  city pickers, and login buttons render fully but do nothing on tap.

## 2. Shared chrome (see `architecture.md` §6)

Safe-area rule, `AppLogoHeaderView`, bottom `UITabBarController`, and the image
placeholder rule apply to all screens.

### Bottom tab bar (`UITabBarController`, 5 tabs)

| Tab       | Label      | SF Symbol (inactive / active)              |
|-----------|------------|--------------------------------------------|
| Home      | Главная    | `house` / `house.fill`                     |
| Catalog   | Каталог    | `magnifyingglass` (no filled variant; tint changes) |
| Favorites | Избранное  | `heart` / `heart.fill`                     |
| Cart      | Корзина    | `basket` / `basket.fill`                   |
| Profile   | Мой Ozon   | `person` / `person.crop.circle.fill`       |

White bar (`UITabBarAppearance`, opaque, `surfaceCard`). Active icon+label
`brandPrimary` (tint); inactive `textSecondary` (appearance normal state). Icon
~24pt, label `tabLabel` (11). Each tab's VC is a `UINavigationController`.

## 3. Component APIs

> Components are `UIView` subclasses (or `UICollectionViewCell`s for grid items).
> "configure" = a method that sets content; cells reset in `prepareForReuse`.

### 3.1 SearchBarView
`SearchBarView(fill: UIColor = .searchFill, trailing: [SearchTrailing])`
`enum SearchTrailing { case barcode, camera }` → `barcode.viewfinder`, `camera`
Height 52, radius 14, leading `magnifyingglass`, placeholder label "Искать на Ozon",
internal h-padding 16. Non-interactive (a styled view, not a `UISearchBar`).
- Home: `fill: .white`, trailing `[.barcode, .camera]`.
- Catalog/Favorites: `fill: .searchFill`, trailing `[.camera]`.

### 3.2 ProductCardCell (keystone)
`func configure(with product: Product, variant: ProductCardVariant)`
`enum ProductCardVariant { case grid, featuredCompact, viewedGrid }`
All variants share identical internal layout; only the outer cell width differs
(the compositional layout sizes `.featuredCompact` to grid-card width with a
trailing spacer; `.grid`/`.viewedGrid` fill an equal 2-up group).

Internal layout (top → bottom), built with `UIStackView` + Auto Layout:
1. **Image block** — `ProductImageView`, `scaleAspectFill`, `cornerImage` 12, clipped. Overlays:
   - Heart top-right: `heart.fill` in `priceSale` when `isFavorite`, else `heart`
     in white over a subtle white circle. Inert.
   - Badge bottom-left (if `badge != nil`): capsule, `flame.fill` + "СКИДКИ НЕДЕЛИ",
     white text, `badge` font.
   - Page dots bottom-center if `imageCount > 1` (filled = first).
2. **PriceBlockView** (§3.3)
3. **Title** — `cardTitle`, `numberOfLines = 2`, `.byTruncatingTail`.
4. **RatingRowView** (§3.4)
5. **CTA** — `CTAButton(date: product.deliveryDate)` (§3.5)

Cell `contentView` bg `surfaceCard`, radius `cornerCard` 14, padding 10–12, no
heavy border. The whole cell is exposed as one accessibility element
(`accessibilityIdentifier = "productCard"`, button trait) so a tap pushes detail.

### 3.3 PriceBlockView — `configure(with product: Product)`
- Line 1: `"\(installmentPrice) \(installmentTerm)"` in `priceInstallment`, `installment` font.
- Line 2: `salePrice` in `priceMain` (`priceSale` color); if `oldPrice != nil`,
  gray strikethrough (`NSAttributedString` `.strikethroughStyle`) beside it; if
  `discountPercent != nil`, `"-\(n)%"` in `priceSale`.
- Line 3 (if `urgency != nil`): urgency in `priceSale`, `secondary` size.

### 3.4 RatingRowView — `configure(rating:reviewCount:)`
`star.fill` (`ratingStar`) + bold rating + `bubble.left` (`textSecondary`) +
`"\(reviewCount) отзыв(а/ов)"` in `textSecondary`.
Pluralize: 1→отзыв, 2–4→отзыва, else→отзывов (with ru teen-exception: 11–14→отзывов).

### 3.5 CTAButton — `CTAButton(date:)`
Full-width, height 44, radius `cornerButtonSm` 12, `brandPrimary` fill, centered
`basket` + date in white, `cta` font. A configured `UIButton`, inert.

### 3.6 CategoryCardCell — `configure(with category: Category)`
Fill `searchFill`, radius 16, height 188. Label top-left, 2-line max, semibold
(`body`). Image bottom-right, `scaleAspectFit`, bleeds toward lower-right. Padding 12.

### 3.7 FilterChipView
`SortChip()` — round, only `arrow.up.arrow.down`.
`FilterChipView(.filters)` — `slider.horizontal.3` + "Фильтры".
`FilterChipView(.brand)` — "Бренд".
Capsule, fill `searchFill`, height 42, h-padding 16. Inert.

### 3.8 QuickActionCell — `configure(with action: QuickAction)`
56pt rounded image tile (radius 14) + 2-line centered caption (`secondary`).
Lives in a horizontally-scrolling section.

### 3.9 SettingsRowView — `configure(with item: SettingsItem, showDivider:)`
Height 56, leading title (`body`), optional trailing value pill (e.g. KZT in a
`searchFill` capsule), trailing `chevron.right` (`textSecondary`), hairline
`separator` divider below (inset to leading text). Inert.

### 3.10 SectionHeaderView — `configure(title:)`
`sectionTitle` (28 bold, `textPrimary`), leading-aligned, `gutter` inset. A
collection boundary supplementary (`elementKind: header`).

### 3.11 PrimaryButton / SoftButton
- PrimaryButton: height 56, radius `cornerButtonLg` 16, `brandPrimary` fill,
  white `cta`. Full-width within `gutter`.
- SoftButton: same metrics, `brandPrimarySoft` fill, `brandPrimary` text.
- Cart "Войти" is a smaller auto-width capsule variant (Screen 4).
- Implement with `UIButton.Configuration`.

---

## 4. Screens

> Each screen is a `UIViewController` hosting a single `UICollectionView` with a
> `UICollectionViewCompositionalLayout` (per-section layout) and a
> `UICollectionViewDiffableDataSource`. "Sections" below = compositional sections.

### Screen 1 — Home / Главная
Sections top→bottom:
1. **Gradient header** — full-width vertical blue gradient (`CAGradientLayer`),
   height ~360, rounded bottom corners `cornerSheet` 24. A pinned/visual header
   (own section or a layout header) containing, in order:
   - `AppLogoHeaderView` (below safe area).
   - Header row (`gutter` inset): left "Астана" + `chevron.down` (white); right
     "Войти" pill on `buttonDark`, white text.
   - `SearchBarView(fill: .white, trailing: [.barcode, .camera])`.
   - Hero promo: promo artwork + headline ("ПРАЗДНИК ПРИЛЕТИТ" / "О!РАСПРОДАЖА"
     lockup). Countdown pill on `buttonDark`: "19:45:13 до старта" + `chevron.right`.
     **The hero lives inside this gradient — not a separate card below.**
2. **Carousel banner** — full-width minus `gutter`, radius 16, height ~150.
   Orthogonally-scrolling **paging** section over `SampleData.banners` (4 slides);
   page dots; auto-advances every 3s (VM `bannerIndex` → `scrollToItem`, wrapping).
3. **Quick actions rail** — horizontally-scrolling section of `QuickActionCell` in
   order: Каталог, Быстрая доставка, Рассрочка 0-0-12, Сделано в Казахстане,
   Ozon Селект, Товары из Китая.
4. `SectionHeaderView("Рекомендуем")` → 2-col `ProductCardCell(variant: .grid)` from
   `SampleData.recommended`. Cards may begin partially under the tab bar.

### Screen 2 — Catalog / Каталог
Order: `AppLogoHeaderView` →
`SearchBarView(fill: .searchFill, trailing: [.camera])` → 3-col grid section of
`CategoryCardCell`, `gutter` inset, `gridSpacing` 12.

Categories (exact order): Женская одежда, Мужская одежда, Обувь, Детская одежда,
Ювелирные украшения, Электроника, Бытовая техника, Красота и здоровье, Дом и сад,
Мебель, Аксессуары, Строительство и ремонт, Автотовары, Продукты питания,
Товары для животных, Детские товары, Спорт и отдых, Книги.

### Screen 3 — Favorites / Избранное
Order:
1. `AppLogoHeaderView`
2. `SearchBarView(fill: .searchFill, trailing: [.camera])`
3. Filter row (horizontal, `gutter` inset): `SortChip()`, `FilterChipView(.filters)`, `FilterChipView(.brand)`.
4. Featured product — left-aligned, compact: a single-item section sized to
   grid-card width with a trailing spacer (blank `backgroundApp` to the right),
   `gutter` inset. `ProductCardCell(product: SampleData.watch, variant: .featuredCompact)`.
5. `SectionHeaderView("Подобрали для вас")` → 2-col `.grid` from `SampleData.recommended`.

### Screen 4 — Cart / Корзина (empty)
Order:
1. `AppLogoHeaderView`
2. City row (`gutter` inset): "Астана" + `chevron.down` (`textPrimary`).
3. **Empty-state band** — full-width, background `backgroundApp` (NOT an inset
   white card). Centered, top/bottom padding 32:
   - Title "Корзина пуста" (`sectionTitle`).
   - Body (`body`, `textSecondary`, centered): "Воспользуйтесь поиском, чтобы найти
     всё, что нужно. Если в Корзине были товары, войдите, чтобы посмотреть список".
   - Button "Войти": `brandPrimarySoft` fill, `brandPrimary` text, capsule-ish
     rounded rect, auto-width (not full-width), centered.
4. `SectionHeaderView("Вы смотрели")` → 2-col `.viewedGrid` from `SampleData.viewed`.
   First card (watch) has filled red heart; second (pedicure) shows no
   discount/urgency. A third row (swimwear) peeks above the tab bar.

### Screen 5 — Profile / Мой Ozon (logged out)
**Two separate white grouped sections** on `backgroundApp`:

**A. CTA section** — full-width white surface, rounded bottom corners
`cornerSheet` 24, centered content, top→bottom:
1. `AppLogoHeaderView`
2. Avatar: 96pt circle, blue linear gradient, centered white `person.fill`.
3. Title "Войдите в личный кабинет" (`screenTitle` 30 bold).
4. Subtitle (`body`, `textSecondary`, centered, 2 lines): "Отслеживайте заказы,
   копите баллы и пользуйтесь персональными скидками".
5. `PrimaryButton("Войти или зарегистрироваться")`.
6. `SoftButton("Покупайте как юрлицо")`.
7. Caption (`secondary`, `textSecondary`): "Применяем" + blue inline link
   "рекомендательные технологии".

**B. Settings group** — white surface, rounded corners 20, `gutter` inset,
`SettingsRowView`s with hairline separators:
Валюта (value pill KZT), Цвет приложения, Язык, Помощь, О приложении.

**C.** `SectionHeaderView("Подобрали по вашим интересам")` → 2-col `.grid`
(top edge visible above tab bar).

## 5. Reviewer pass (design)

- ✅ Single `ProductCardCell` covers all 4 product surfaces (red-line #7).
- ✅ Favorites featured is compact + left-aligned (red-line #2).
- ✅ Cart empty state is a full-width band, not an inset card (red-line #3).
- ✅ Profile is two grouped sections (red-line #4).
- ✅ Home hero inside the gradient (red-line #6).
- ✅ Catalog has centered logo (red-line #5).
- ⚠️ Confirm during build: `featuredCompact` width equals computed grid-card
  width (not an arbitrary fixed point).
- ⚠️ Confirm: page dots only render when `imageCount > 1`.
