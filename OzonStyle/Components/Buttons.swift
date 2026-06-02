import UIKit

// Button factories (design.md §3.5, §3.11). All inert (no targets) — this is a
// presentational prototype.
enum Buttons {

    // Full-width primary CTA (height 56).
    static func primary(_ title: String) -> UIButton {
        pill(title: title, bg: .brandPrimary, fg: .white,
             height: 56, radius: Layout.cornerButtonLg)
    }

    // Full-width soft secondary (height 56).
    static func soft(_ title: String) -> UIButton {
        pill(title: title, bg: .brandPrimarySoft, fg: .brandPrimary,
             height: 56, radius: Layout.cornerButtonLg)
    }

    // In-card CTA: basket + delivery date, full-width, height 44.
    static func cta(date: String) -> UIButton {
        var cfg = UIButton.Configuration.filled()
        cfg.title = date
        cfg.image = UIImage(systemName: "basket")
        cfg.imagePadding = 6
        cfg.baseBackgroundColor = .brandPrimary
        cfg.baseForegroundColor = .white
        cfg.background.cornerRadius = Layout.cornerButtonSm
        cfg.attributedTitle = AttributedString(date, attributes: AttributeContainer([.font: Typography.cta]))
        let b = UIButton(configuration: cfg)
        b.isUserInteractionEnabled = false
        b.constrainHeight(44)
        return b
    }

    // Cart "Войти" — auto-width soft capsule (height 44).
    static func cartLogin() -> UIButton {
        var cfg = UIButton.Configuration.filled()
        cfg.baseBackgroundColor = .brandPrimarySoft
        cfg.baseForegroundColor = .brandPrimary
        cfg.background.cornerRadius = Layout.cornerButtonSm
        cfg.contentInsets = .init(top: 0, leading: 28, bottom: 0, trailing: 28)
        cfg.attributedTitle = AttributedString("Войти", attributes: AttributeContainer([.font: Typography.cta]))
        let b = UIButton(configuration: cfg)
        b.isUserInteractionEnabled = false
        b.constrainHeight(44)
        return b
    }

    private static func pill(title: String, bg: UIColor, fg: UIColor,
                             height: CGFloat, radius: CGFloat) -> UIButton {
        var cfg = UIButton.Configuration.filled()
        cfg.baseBackgroundColor = bg
        cfg.baseForegroundColor = fg
        cfg.background.cornerRadius = radius
        cfg.attributedTitle = AttributedString(title, attributes: AttributeContainer([.font: Typography.cta]))
        let b = UIButton(configuration: cfg)
        b.isUserInteractionEnabled = false
        b.constrainHeight(height)
        return b
    }
}
