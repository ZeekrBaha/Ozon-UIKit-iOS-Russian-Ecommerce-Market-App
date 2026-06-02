import UIKit

// Small factory helpers to keep component code declarative.
enum UI {
    static func symbol(_ name: String,
                       _ color: UIColor,
                       size: CGFloat = 17,
                       weight: UIImage.SymbolWeight = .regular) -> UIImageView {
        let cfg = UIImage.SymbolConfiguration(pointSize: size, weight: weight)
        let iv = UIImageView(image: UIImage(systemName: name, withConfiguration: cfg))
        iv.tintColor = color
        iv.contentMode = .scaleAspectFit
        iv.setContentHuggingPriority(.required, for: .horizontal)
        iv.setContentCompressionResistancePriority(.required, for: .horizontal)
        return iv
    }

    static func label(_ text: String?,
                      _ font: UIFont,
                      _ color: UIColor,
                      lines: Int = 1) -> UILabel {
        let l = UILabel()
        l.text = text
        l.font = font
        l.textColor = color
        l.numberOfLines = lines
        l.adjustsFontForContentSizeCategory = true
        return l
    }

    static func hStack(_ views: [UIView], spacing: CGFloat = 0,
                       alignment: UIStackView.Alignment = .center) -> UIStackView {
        let s = UIStackView(arrangedSubviews: views)
        s.axis = .horizontal; s.spacing = spacing; s.alignment = alignment
        return s
    }

    static func vStack(_ views: [UIView], spacing: CGFloat = 0,
                       alignment: UIStackView.Alignment = .fill) -> UIStackView {
        let s = UIStackView(arrangedSubviews: views)
        s.axis = .vertical; s.spacing = spacing; s.alignment = alignment
        return s
    }
}

extension UIView {
    func pinEdges(to other: UIView, insets: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: other.leadingAnchor, constant: insets.left),
            trailingAnchor.constraint(equalTo: other.trailingAnchor, constant: -insets.right),
            topAnchor.constraint(equalTo: other.topAnchor, constant: insets.top),
            bottomAnchor.constraint(equalTo: other.bottomAnchor, constant: -insets.bottom),
        ])
    }

    func constrainHeight(_ h: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: h).isActive = true
    }
}
