import UIKit

// All OZON identity isolated here (design-system.md §7, red-line #8). Screens read
// `Brand.*`, never the literal "OZON" string or brand hex.
enum Brand {
    static let wordmark = "OZON"

    static let pillColor: UIColor     = .surfaceCard   // white pill
    static let wordmarkColor: UIColor = .brandPrimary  // blue wordmark

    // Blue gradient used by the Home header + the Profile avatar.
    static let gradientTop    = UIColor(red: 0.13, green: 0.55, blue: 1.0, alpha: 1.0)
    static let gradientBottom = UIColor(red: 0.0,  green: 0.36, blue: 1.0, alpha: 1.0)
}
