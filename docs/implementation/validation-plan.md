# Validation Plan — Ozon-Style E-Commerce (iOS, UIKit)

> Define checks before coding. The gate is **visual fidelity + the 8 red-lines +
> the XCUITest suite + an MVVM-C layering review**, verified per-screen on a running
> simulator — not a clean build alone (spec §6).

## 1. Commands / checks

| Check | How | When |
|-------|-----|------|
| Generate | `xcodegen generate` after any new file | as needed |
| Compile | Xcode build (XcodeBuildMCP `build_sim`) | every task |
| Run | `build_run_sim` on an iOS 17+ simulator | every screen |
| Screenshot | XcodeBuildMCP `screenshot` per tab | every screen |
| Compare | Screenshot vs the matching reference image | every screen |
| UI tests | `test_sim` / `xcodebuild test` (`OzonStyleUITests`) | T20 + final |
| Dynamic Type | Bump Larger Text one step, re-screenshot | final pass (T21) |
| Missing-asset | Pass a bogus asset name to `ProductImageView` | T7 |

## 2. Per-screen verification checklist (run after each screen — spec §6)

For every screen, confirm:
- [ ] Logo pill sits **below** the safe area (never on the status-bar row).
- [ ] Search bar height 52 / radius 14 (where present).
- [ ] `backgroundApp` everywhere except inside white surfaces.
- [ ] Grid spacing 12 and **computed** (fractional) card width (not hardcoded points).
- [ ] `ProductCardCell` width correct for its variant.
- [ ] Tab active = `brandPrimary`, inactive = `textSecondary`.
- [ ] 2-line truncation intact (no clipping).
- [ ] Card radius 14; CTA height 44.
- [ ] Safe-area top inset = `safeAreaTop + 8`.

## 3. MVVM-C layering review (per screen / at integration)

- [ ] The `UIViewController` imports no `SampleData`; it reads only its ViewModel.
- [ ] The ViewModel imports no `UIKit`; it depends only on `ProductRepository`.
- [ ] No VC instantiates or pushes another VC — navigation goes through a coordinator.
- [ ] Product tap is forwarded via the screen's `onSelectProduct` closure, not
      handled inside the cell/VC.
- [ ] `SampleData` is referenced only inside `SampleDataRepository`.

## 4. Acceptance red-lines (binary, reject if ANY fail — spec §7)

| # | Red-line | Screen |
|---|----------|--------|
| 1 | Logo pill never aligned with status-bar clock/battery (must be below safe area) | all |
| 2 | Favorites featured card never full-width (compact, left-aligned) | Favorites |
| 3 | Cart empty state never an inset white card (full-width band on `backgroundApp`) | Cart |
| 4 | Profile CTA + Settings never one block (two grouped sections) | Profile |
| 5 | Catalog never missing the centered logo | Catalog |
| 6 | Home hero never detached from the gradient header | Home |
| 7 | No product tile outside the shared `Product` model + single `ProductCardCell` | all |
| 8 | Brand wordmark/colors never hardcoded inside screen views | all |

## 5. UI test gate (`OzonStyleUITests`)

- [ ] Functional: 5-tab structure; each screen renders its content marker;
      product → `ProductDetailViewController` → back from ≥2 tabs.
- [ ] Layout (frame assertions): tab bar pinned to bottom; logo pill below safe
      area + centered (#1); Favorites featured compact + left-aligned (#2); Cart
      band full-width (#3); Home 2-col + Catalog 3-col grid geometry (#5).
- [ ] All green on iPhone 15 Pro Max.

## 6. Anti-slop gate (native iOS)

- [ ] Real, plausible mock data on every card (no "Lorem"/placeholder titles).
- [ ] Single icon set (SF Symbols) at consistent sizes.
- [ ] Neutral background (`backgroundApp` #F2F3F7), not pure `#fff`, behind cards.
- [ ] One accent for brand (`brandPrimary`), distinct sale/installment/rating colors.
- [ ] Touch targets / tappable rows ≥ 44pt where applicable.
- [ ] Dynamic Type supported; contrast of secondary text on white passes AA.
- [ ] No emoji used as UI icons (flame/heart/star are SF Symbols, per spec).

## 7. IP / brand check before any sharing

- [ ] If this leaves a private reference context, the OZON wordmark,
      О!РАСПРОДАЖА lockup, and third-party product photos are swapped (all
      isolated in `Brand.swift` + asset catalog).

## 8. Sign-off

Build is acceptable when: all 5 screens pass their per-screen checklist, the MVVM-C
review passes, all 8 red-lines pass on a fresh launch, the XCUITest suite is green,
the Dynamic Type spot-check is clean, and `validation-report.md` records the
commands run and any skipped checks.
