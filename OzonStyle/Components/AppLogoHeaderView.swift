import UIKit

// Centered brand pill (architecture.md §6, red-line #1). Intrinsic height 30; the
// caller provides the `safeAreaTop + 8` spacing. Pill color + wordmark from Brand.
final class AppLogoHeaderView: UIView {
    init() {
        super.init(frame: .zero)

        let pill = UIView()
        pill.backgroundColor = Brand.pillColor
        pill.layer.cornerRadius = 15
        pill.isAccessibilityElement = true
        pill.accessibilityIdentifier = "brandPill"
        pill.accessibilityLabel = Brand.wordmark
        pill.translatesAutoresizingMaskIntoConstraints = false

        let label = UI.label(Brand.wordmark, .systemFont(ofSize: 15, weight: .heavy), Brand.wordmarkColor)
        label.translatesAutoresizingMaskIntoConstraints = false
        pill.addSubview(label)
        addSubview(pill)

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: pill.leadingAnchor, constant: 14),
            label.trailingAnchor.constraint(equalTo: pill.trailingAnchor, constant: -14),
            label.centerYAnchor.constraint(equalTo: pill.centerYAnchor),
            pill.heightAnchor.constraint(equalToConstant: 30),
            pill.centerXAnchor.constraint(equalTo: centerXAnchor),
            pill.topAnchor.constraint(equalTo: topAnchor),
            pill.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) not used") }
}
