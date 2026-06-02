import UIKit

// Type styles (design-system.md §3). Base system fonts wrapped in UIFontMetrics so
// labels can opt into Dynamic Type via `adjustsFontForContentSizeCategory = true`.
enum Typography {
    static let screenTitle  = scaled(30, .bold,     .largeTitle)
    static let sectionTitle = scaled(28, .bold,     .title1)
    static let priceMain    = scaled(16, .bold,     .body)
    static let installment  = scaled(15, .semibold, .subheadline)
    static let cardTitle    = scaled(14, .regular,  .footnote)
    static let body         = scaled(15, .regular,  .body)
    static let secondary    = scaled(13, .regular,  .caption1)
    static let badge        = scaled(11, .bold,     .caption2)
    static let cta          = scaled(15, .semibold, .body)
    static let tabLabel     = scaled(11, .regular,  .caption2)

    private static func scaled(_ size: CGFloat,
                               _ weight: UIFont.Weight,
                               _ style: UIFont.TextStyle) -> UIFont {
        let base = UIFont.systemFont(ofSize: size, weight: weight)
        return UIFontMetrics(forTextStyle: style).scaledFont(for: base)
    }
}
