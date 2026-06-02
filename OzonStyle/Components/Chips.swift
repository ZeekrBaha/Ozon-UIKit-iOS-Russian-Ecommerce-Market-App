import UIKit

// Filter row chips (design.md §3.7). All inert.

// Round sort chip — icon only.
final class SortChipView: UIView {
    init() {
        super.init(frame: .zero)
        backgroundColor = .searchFill
        layer.cornerRadius = 21
        let icon = UI.symbol("arrow.up.arrow.down", .textPrimary, size: 16)
        icon.translatesAutoresizingMaskIntoConstraints = false
        addSubview(icon)
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 42),
            heightAnchor.constraint(equalToConstant: 42),
            icon.centerXAnchor.constraint(equalTo: centerXAnchor),
            icon.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) not used") }
}

enum FilterKind { case filters, brand }

// Capsule filter chip — optional icon + label.
final class FilterChipView: UIView {
    init(kind: FilterKind) {
        super.init(frame: .zero)
        backgroundColor = .searchFill
        layer.cornerRadius = 21

        var views: [UIView] = []
        switch kind {
        case .filters:
            views.append(UI.symbol("slider.horizontal.3", .textPrimary, size: 15))
            views.append(UI.label("Фильтры", Typography.body, .textPrimary))
        case .brand:
            views.append(UI.label("Бренд", Typography.body, .textPrimary))
        }
        let row = UI.hStack(views, spacing: 6)
        row.translatesAutoresizingMaskIntoConstraints = false
        addSubview(row)
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 42),
            row.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            row.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            row.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) not used") }
}
