# Validation Report — Ozon-Style E-Commerce (iOS, UIKit)

> **Status: PENDING.** This is the template to fill during the final pass (T21),
> after the UIKit MVVM-C build. Nothing here is signed off yet — coding has not
> started. Replace each `_pending_` once the corresponding check runs on a
> simulator.

Date: _pending_ · Build: _pending_ (Xcode __, iOS 17 deploy target, iPhone 15
Pro Max sim). Project generated with `xcodegen`.

## Commands run

| Command | Result |
|---------|--------|
| `xcodegen generate` | _pending_ |
| `build_sim` (XcodeBuildMCP) | _pending_ |
| `build_run_sim` | _pending_ |
| `screenshot` per tab | _pending_ |
| `test_sim` (`OzonStyleUITests`) | _pending_ |
| Dynamic Type spot-check (extra-large) | _pending_ (see N2) |

## Per-screen verification (vs reference screenshots)

| Screen | Result | Notes |
|--------|--------|-------|
| Home (Главная) | _pending_ | logo below safe area; city + dark Войти pill; white search; hero + countdown **inside** gradient; auto-advancing carousel (4 dots); 6 quick actions; Рекомендуем 2-col grid. |
| Catalog (Каталог) | _pending_ | centered logo; camera search; 3-col grid, 18 categories in order; computed width. |
| Favorites (Избранное) | _pending_ | filter row; compact **left-aligned** featured watch; Подобрали для вас 2-col grid. |
| Cart (Корзина) | _pending_ | full-width empty band on backgroundApp; auto-width Войти; Вы смотрели grid. |
| Profile (Мой Ozon) | _pending_ | two separate white sections; 96pt gradient avatar; primary+soft buttons; KZT pill + chevrons + hairlines; recommendations grid. |
| Product detail | _pending_ | pushed on card tap; nav bar + back; reuses price/rating/CTA components. |

## MVVM-C layering review

| Check | Status |
|-------|--------|
| VCs read only their ViewModel (no `SampleData`) | _pending_ |
| ViewModels import no `UIKit`; depend on `ProductRepository` | _pending_ |
| No VC pushes another VC (navigation via coordinators) | _pending_ |
| `SampleData` referenced only in `SampleDataRepository` | _pending_ |

## Acceptance red-lines (binary gate)

| # | Red-line | Status |
|---|----------|--------|
| 1 | Logo pill below safe area (all) | _pending_ |
| 2 | Favorites featured compact + left-aligned | _pending_ |
| 3 | Cart empty state full-width band (not inset card) | _pending_ |
| 4 | Profile = two grouped sections | _pending_ |
| 5 | Catalog has centered logo | _pending_ |
| 6 | Home hero inside the gradient | _pending_ |
| 7 | One shared `Product` model + single `ProductCardCell` (no inline tiles) | _pending_ |
| 8 | Brand wordmark/colors isolated in `Brand.swift` | _pending_ |

## UI test suite

| Group | Result |
|-------|--------|
| Functional (structure, screens, nav flow) | _pending_ |
| Layout (red-line frame assertions) | _pending_ |

## Anti-slop gate

_pending_ — real mock data · single SF Symbol set · neutral `backgroundApp` ·
one brand accent + distinct sale/installment/rating colors · tappable rows ≥44pt ·
no emoji as icons.

## Known deviations (record honestly at sign-off)

_pending_ — e.g. brand pill color choice, IP-safe hero lockup, Dynamic Type
fixed-vs-scaled decision, placeholder vs real imagery.

## Sign-off

_pending_ — sign off only when all 5 screens match their references, the MVVM-C
review passes, all 8 red-lines pass on a fresh launch, the XCUITest suite is green,
and the Dynamic Type spot-check is clean.
