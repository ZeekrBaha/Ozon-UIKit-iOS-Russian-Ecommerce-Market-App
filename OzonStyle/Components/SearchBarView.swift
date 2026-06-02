import UIKit

enum SearchTrailing { case barcode, camera }

// Display-only search bar (design.md §3.1). Height 52, radius 14. Non-interactive
// (a styled view, not a UISearchBar).
final class SearchBarView: UIView {
    init(fill: UIColor = .searchFill, trailing: [SearchTrailing] = []) {
        super.init(frame: .zero)
        backgroundColor = fill
        layer.cornerRadius = Layout.cornerSearch

        let glass = UI.symbol("magnifyingglass", .textSecondary, size: 18)
        let placeholder = UI.label("Искать на Ozon", Typography.body, .textSecondary)
        placeholder.setContentHuggingPriority(.defaultLow, for: .horizontal)

        var views: [UIView] = [glass, placeholder]
        for t in trailing {
            views.append(UI.symbol(t == .barcode ? "barcode.viewfinder" : "camera", .textSecondary, size: 18))
        }
        let stack = UI.hStack(views, spacing: 10)
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 52),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stack.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) not used") }
}
