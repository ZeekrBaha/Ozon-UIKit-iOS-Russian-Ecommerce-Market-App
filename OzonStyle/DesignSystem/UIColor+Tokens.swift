import UIKit

// Semantic color tokens (design-system.md §1), asset-catalog backed. Force-unwrap
// is intentional: a missing color set is a build-config bug that must fail loudly.
extension UIColor {
    static var brandPrimary: UIColor     { UIColor(named: "brandPrimary")! }
    static var brandPrimarySoft: UIColor { UIColor(named: "brandPrimarySoft")! }
    static var priceSale: UIColor        { UIColor(named: "priceSale")! }
    static var priceInstallment: UIColor { UIColor(named: "priceInstallment")! }
    static var ratingStar: UIColor       { UIColor(named: "ratingStar")! }
    static var textPrimary: UIColor      { UIColor(named: "textPrimary")! }
    static var textSecondary: UIColor    { UIColor(named: "textSecondary")! }
    static var backgroundApp: UIColor    { UIColor(named: "backgroundApp")! }
    static var surfaceCard: UIColor      { UIColor(named: "surfaceCard")! }
    static var searchFill: UIColor       { UIColor(named: "searchFill")! }
    static var buttonDark: UIColor       { UIColor(named: "buttonDark")! }
    static var separatorToken: UIColor   { UIColor(named: "separator")! }
}
