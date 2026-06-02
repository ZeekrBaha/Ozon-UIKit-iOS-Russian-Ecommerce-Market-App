import UIKit

// Vertical gradient with optional rounded corners (Home header, design.md §4).
final class GradientView: UIView {
    private let gradient = CAGradientLayer()

    init(colors: [UIColor], roundedCorners: CACornerMask = []) {
        super.init(frame: .zero)
        gradient.colors = colors.map { $0.cgColor }
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        layer.insertSublayer(gradient, at: 0)
        if !roundedCorners.isEmpty {
            layer.cornerRadius = Layout.cornerSheet
            layer.maskedCorners = roundedCorners
            layer.masksToBounds = true
        }
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) not used") }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradient.frame = bounds
    }
}

// 96pt gradient avatar circle with a centered white person glyph (Profile §4.A).
final class AvatarView: UIView {
    private let gradient = CAGradientLayer()

    init() {
        super.init(frame: .zero)
        gradient.colors = [Brand.gradientTop.cgColor, Brand.gradientBottom.cgColor]
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        layer.insertSublayer(gradient, at: 0)

        let glyph = UI.symbol("person.fill", .white, size: 46)
        glyph.translatesAutoresizingMaskIntoConstraints = false
        addSubview(glyph)
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 96),
            heightAnchor.constraint(equalToConstant: 96),
            glyph.centerXAnchor.constraint(equalTo: centerXAnchor),
            glyph.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) not used") }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradient.frame = bounds
        layer.cornerRadius = bounds.width / 2
        layer.masksToBounds = true
    }
}

// Small dark capsule "pill" of arbitrary content (Home Войти / countdown).
final class DarkPillView: UIView {
    init(_ content: UIView, height: CGFloat = 36, hPadding: CGFloat = 16) {
        super.init(frame: .zero)
        backgroundColor = .buttonDark
        layer.cornerRadius = height / 2
        content.translatesAutoresizingMaskIntoConstraints = false
        addSubview(content)
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: height),
            content.leadingAnchor.constraint(equalTo: leadingAnchor, constant: hPadding),
            content.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -hPadding),
            content.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) not used") }
}
