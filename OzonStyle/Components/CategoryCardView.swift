import UIKit

// Category tile (design.md §3.6). Label top-left; transparent cutout bottom-right,
// `.scaleAspectFit` over the light card. Height 188.
final class CategoryCardView: UIView {
    init(category: Category) {
        super.init(frame: .zero)
        backgroundColor = .searchFill
        layer.cornerRadius = 16
        layer.masksToBounds = true

        let image = ProductImageView()
        image.backgroundColor = .clear
        image.configure(named: category.imageName, fitMode: .scaleAspectFit)
        image.translatesAutoresizingMaskIntoConstraints = false

        let label = UI.label(category.title, .systemFont(ofSize: 15, weight: .semibold), .textPrimary, lines: 2)
        label.translatesAutoresizingMaskIntoConstraints = false

        addSubview(image)
        addSubview(label)

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 188),

            label.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            label.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -12),

            image.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            image.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            image.heightAnchor.constraint(equalToConstant: 116),
            image.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.62),
        ])

        isAccessibilityElement = true
        accessibilityIdentifier = "categoryCard"
        accessibilityLabel = category.title
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) not used") }
}
