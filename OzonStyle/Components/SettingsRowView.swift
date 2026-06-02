import UIKit

// Settings row (design.md §3.9): title, optional value pill, chevron, hairline.
final class SettingsRowView: UIView {
    init(item: SettingsItem, showDivider: Bool) {
        super.init(frame: .zero)

        let title = UI.label(item.title, Typography.body, .textPrimary)
        title.translatesAutoresizingMaskIntoConstraints = false
        let chevron = UI.symbol("chevron.right", .textSecondary, size: 14)
        chevron.translatesAutoresizingMaskIntoConstraints = false

        var trailing: [UIView] = []
        if let value = item.value {
            let pill = UIView()
            pill.backgroundColor = .searchFill
            pill.layer.cornerRadius = 11
            let valueLabel = UI.label(value, Typography.secondary, .textSecondary)
            valueLabel.translatesAutoresizingMaskIntoConstraints = false
            pill.addSubview(valueLabel)
            valueLabel.pinEdges(to: pill, insets: .init(top: 4, left: 10, bottom: 4, right: 10))
            trailing.append(pill)
        }
        trailing.append(chevron)
        let trailingStack = UI.hStack(trailing, spacing: 8)
        trailingStack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(title)
        addSubview(trailingStack)

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 56),
            title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            title.centerYAnchor.constraint(equalTo: centerYAnchor),
            trailingStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            trailingStack.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])

        if showDivider {
            let divider = UIView()
            divider.backgroundColor = .separatorToken
            divider.translatesAutoresizingMaskIntoConstraints = false
            addSubview(divider)
            NSLayoutConstraint.activate([
                divider.heightAnchor.constraint(equalToConstant: 0.5),
                divider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
                divider.trailingAnchor.constraint(equalTo: trailingAnchor),
                divider.bottomAnchor.constraint(equalTo: bottomAnchor),
            ])
        }
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) not used") }
}
