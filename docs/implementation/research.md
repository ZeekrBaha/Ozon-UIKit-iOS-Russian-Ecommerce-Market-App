# Research — Ozon-Style E-Commerce (iOS, UIKit)

> Spec-first research doc. Every important claim is labelled `Evidence`,
> `Repository fact`, or `Assumption`. No design decisions are made here except
> as clearly marked options.

## 1. Goal

Build a **presentational iOS prototype in UIKit (MVVM-C)** that visually reproduces
an Ozon-style marketplace across five tabs: Home, Catalog, Favorites, Cart (empty),
Profile (logged out), plus a minimal product-detail screen reachable by tapping a
card. This is the UIKit sibling of an existing SwiftUI build — same screens, same
tokens, same data, different framework.

- `Evidence` (reference screenshots, 5 supplied): the UI shows Home with a blue
  gradient header + hero promo, a 3-column Catalog grid, a Favorites screen with
  one compact featured card, an empty Cart with a "Вы смотрели" grid, and a
  logged-out Profile with CTA + settings group.
- `Assumption`: this is a portfolio/learning prototype, not a shipping product —
  so no backend, accounts, or commerce flows are required.

## 2. Audience

- `Assumption`: the developer (Baha) building an iOS portfolio piece, and
  reviewers judging UI fidelity to the reference **and** the MVVM-C structure.

## 3. Success criteria

1. Each of the 5 screens matches its reference screenshot on layout, spacing,
   color, and typography (verified per-screen via simulator screenshot).
2. All 8 acceptance red-lines in `requirements.md` pass.
3. Clean MVVM-C layering: coordinators own navigation, view models own state,
   views are dumb, a repository is the only data path (`requirements.md` §2).
4. Interactive behavior is limited to tab switching + product→detail push;
   everything else is inert by design.
5. Zero third-party dependencies; UIKit (+ first-party Combine) only; iOS 17+.
6. `XCUITest` coverage for every screen + the navigation flow + layout red-lines.

## 4. Constraints (binding)

- `Constraint` (from spec §0, adapted): **iOS 17+, UIKit only, zero third-party
  dependencies.** Native mobile is explicitly requested and the platform is pinned.
  Combine and Foundation are first-party and allowed for binding.
- `Constraint`: **MVVM-C architecture.** View models, a `ProductRepository`, and
  coordinators are required (this is the explicit purpose of the UIKit build).
  Programmatic UI; no storyboards except `LaunchScreen`.
- `Constraint`: **Presentational prototype.** No networking, persistence, auth, or
  async loading. The only navigation is the product-detail push.
- `Constraint`: **Centralized mock data.** All product content comes from one
  `SampleData` source, reached only through the repository. Never hardcode product
  fields inside a view or view model.
- `Constraint`: **One card component.** Every product tile on every screen is the
  same `ProductCardCell`, differing only by a `variant` enum. Per-screen duplicate
  cards are rejected.
- `Constraint`: **Branding behind a config switch.** The literal OZON wordmark and
  colors live in `Brand.swift`, swappable without touching screens.
- `Constraint`: **Localization is Russian/Kazakh-market.** Strings are Russian;
  currency is ₸ (KZT); city is Астана; "Сделано в Казахстане" appears. (Spec ships
  strings inline; a String Catalog is a non-goal but noted as future work.)

## 5. Data sources & APIs

- `Repository fact`: none external. All data is mock and lives in `SampleData`,
  served via `SampleDataRepository`. No API, no network layer.
- `Evidence` (spec §2): the `Product`, `Category`, `QuickAction`, and
  `SettingsItem` model shapes are fully specified, including concrete sample
  values (watch, pedicure tool, swimwear, etc.). Models are `Hashable` for diffable
  data sources.

## 6. Risks & unknowns

- `Risk — IP/Trademark (HIGH).` The prototype reproduces the literal **OZON**
  wordmark, the **О!РАСПРОДАЖА** promo lockup, and apparent third-party product
  photography. Acceptable for a private reference build; **must not be
  redistributed or shipped** without swapping the mark, promo art, and product
  images. Mitigation: all brand identity is isolated in `Brand.swift` + the asset
  catalog so a swap is a localized edit, not a screen rewrite.
- `Risk — asset stalls.` Missing image assets could leave blank space. Mitigation:
  the §3.0 placeholder rule (`searchFill` rect + SF Symbol `photo`) is mandatory at
  every image entry point.
- `Risk — safe-area overlap.` Prior builds let the custom logo pill overlap the
  status bar. Mitigation: hard rule — first content top inset = safeAreaTop + 8;
  logo always below the status bar. This is acceptance red-line #1.
- `Risk — compositional-layout complexity.` Home mixes a visual gradient header, a
  paging carousel, a horizontal rail, and a grid in one collection view. Mitigation:
  one explicit compositional **section** per spec block; build/screenshot Home last,
  after the simpler grid screens validate the layout helpers.
- `Unknown`: exact hero/promo artwork assets. `Assumption`: a styled text lockup
  (IP-safe) plus 4 banner image slides are acceptable; the carousel auto-advances.
- `Unknown`: full contents of `recommended` and a few extra products (bikini,
  wallet/clutch). `Assumption`: author ≥6 plausible products reusing the three
  fully-specified instances plus simple additions; centralize in `SampleData`.

## 7. Non-goals (explicit)

- No add-to-cart logic, no search results, no commerce actions on the detail screen
  (it is a minimal reuse-only view).
- No dark mode tuning beyond Dynamic Type support (light UI matches reference).
- No String Catalog / `Localizable.xcstrings` in v1 (noted as future work).
- No networking, persistence, or auth.
