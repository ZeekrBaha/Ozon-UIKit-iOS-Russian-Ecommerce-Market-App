import UIKit

// Spacing / corner constants (design-system.md §2). One global gutter = 16.
enum Layout {
    static let gutter: CGFloat         = 16   // global horizontal screen inset
    static let sectionSpacing: CGFloat = 24   // vertical gap between sections
    static let gridSpacing: CGFloat    = 12   // inter-item gap in all grids
    static let cardSpacing: CGFloat    = 12   // inter-item gap in 2-col product grid
    static let cornerCard: CGFloat     = 14
    static let cornerImage: CGFloat    = 12
    static let cornerSearch: CGFloat   = 14
    static let cornerButtonLg: CGFloat = 16
    static let cornerButtonSm: CGFloat = 12
    static let cornerSheet: CGFloat    = 24   // rounded bottom of gradient/grouped sections
    static let cornerBanner: CGFloat   = 16   // home promo carousel
    static let bannerHeight: CGFloat   = 150  // home promo carousel

    // Grid math (compute, never eyeball). Compositional layout uses fractional
    // groups; these helpers are for any explicit sizing / verification.
    static func productCardWidth(screenW: CGFloat) -> CGFloat {
        (screenW - 2 * gutter - cardSpacing) / 2
    }
    static func categoryCardWidth(screenW: CGFloat) -> CGFloat {
        (screenW - 2 * gutter - 2 * gridSpacing) / 3
    }
}
