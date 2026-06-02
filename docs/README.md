# Ozon-Style E-Commerce (iOS, UIKit) — Implementation Docs

Spec-first documentation package for a presentational **UIKit MVVM-C** prototype of
an Ozon-style marketplace (iOS 17+, zero dependencies). The UIKit sibling of the
SwiftUI build — same screens, tokens, and data; UIKit + coordinators instead of
SwiftUI. Built from the v2 build-ready spec + 5 verified reference screenshots.

## Read in this order

1. [`implementation/research.md`](implementation/research.md) — goal, constraints, stack decision, MVVM-C mandate, IP risk, unknowns.
2. [`implementation/requirements.md`](implementation/requirements.md) — functional/architecture/non-functional reqs + the 8 acceptance red-lines.
3. [`implementation/design-system.md`](implementation/design-system.md) — **tokens** (color/spacing/type/shape). Reuse verbatim.
4. [`implementation/design.md`](implementation/design.md) — component APIs (UIKit views/cells) + per-screen specs (all 5 screens + detail).
5. [`implementation/architecture.md`](implementation/architecture.md) — MVVM-C layering, file tree, data model, component reuse map.
6. [`implementation/implementation-plan.md`](implementation/implementation-plan.md) — ordered tasks T0–T21 with acceptance criteria + traceability.
7. [`implementation/validation-plan.md`](implementation/validation-plan.md) — per-screen checklist, MVVM-C review, red-lines, UI-test gate, anti-slop gate.
8. [`prompts/developer.md`](prompts/developer.md) — the implementation prompt (embeds tokens + MVVM-C rules + slop ban).

`implementation/validation-report.md` is a pending template, filled during the
final pass (T21).

## The non-negotiables (one glance)

- **MVVM-C:** coordinators own navigation; view models own state (no UIKit);
  a repository is the only data path; views are dumb.
- One `ProductCardCell` (variant enum) on every product surface — no per-screen cards.
- All content from `SampleData` **via `ProductRepository`** — no literals in views/VMs.
- Brand behind `Brand.swift` — no hardcoded "OZON"/brand hex in screens.
- Logo always below the safe area.
- Build order is fixed; screenshot-verify each screen before the next.

## Status

Planning complete. Coding has **not** started — begin with task **T0** in the
implementation plan once approved.
