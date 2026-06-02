import UIKit

// Screen 5 — Мой Ozon (logged out). Two separate white grouped sections (red-line
// #4) + recommendations grid.
final class ProfileViewController: ScrollScreenViewController {
    private let viewModel: ProfileViewModel
    private let onSelectProduct: (Product) -> Void

    init(viewModel: ProfileViewModel, onSelectProduct: @escaping (Product) -> Void) {
        self.viewModel = viewModel
        self.onSelectProduct = onSelectProduct
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) not used") }

    override func viewDidLoad() {
        super.viewDidLoad()
        contentStack.spacing = 16

        contentStack.addArrangedSubview(makeCTASection())   // bleeds under status bar
        contentStack.addArrangedSubview(gutterWrap(makeSettingsGroup()))
        contentStack.addArrangedSubview(gutterWrap(SectionHeaderView("Подобрали по вашим интересам")))
        let grid = ProductGrid.make(products: viewModel.recommended, onSelect: onSelectProduct)
        contentStack.addArrangedSubview(gutterWrap(grid))
    }

    // A. White CTA surface with rounded bottom corners.
    private func makeCTASection() -> UIView {
        let section = UIView()
        section.backgroundColor = .surfaceCard
        section.layer.cornerRadius = Layout.cornerSheet
        section.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        section.layer.masksToBounds = true

        let avatarBox = UIView()
        let avatar = AvatarView()
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatarBox.addSubview(avatar)
        NSLayoutConstraint.activate([
            avatar.centerXAnchor.constraint(equalTo: avatarBox.centerXAnchor),
            avatar.topAnchor.constraint(equalTo: avatarBox.topAnchor),
            avatar.bottomAnchor.constraint(equalTo: avatarBox.bottomAnchor),
        ])

        let title = UI.label("Войдите в личный кабинет", Typography.screenTitle, .textPrimary, lines: 0)
        title.textAlignment = .center
        let subtitle = UI.label("Отслеживайте заказы, копите баллы и пользуйтесь персональными скидками",
                                Typography.body, .textSecondary, lines: 0)
        subtitle.textAlignment = .center

        let caption = UILabel()
        caption.numberOfLines = 0
        caption.textAlignment = .center
        let cap = NSMutableAttributedString(string: "Применяем ",
            attributes: [.foregroundColor: UIColor.textSecondary, .font: Typography.secondary])
        cap.append(NSAttributedString(string: "рекомендательные технологии",
            attributes: [.foregroundColor: UIColor.brandPrimary, .font: Typography.secondary]))
        caption.attributedText = cap

        let inner = UI.vStack([
            AppLogoHeaderView(), avatarBox, title, subtitle,
            Buttons.primary("Войти или зарегистрироваться"),
            Buttons.soft("Покупайте как юрлицо"),
            caption,
        ], spacing: 14, alignment: .fill)
        inner.translatesAutoresizingMaskIntoConstraints = false
        section.addSubview(inner)

        let top = inner.topAnchor.constraint(equalTo: section.topAnchor)
        registerTopInset(top, extra: 8)
        NSLayoutConstraint.activate([
            top,
            inner.leadingAnchor.constraint(equalTo: section.leadingAnchor, constant: Layout.gutter),
            inner.trailingAnchor.constraint(equalTo: section.trailingAnchor, constant: -Layout.gutter),
            inner.bottomAnchor.constraint(equalTo: section.bottomAnchor, constant: -24),
        ])
        return section
    }

    // B. White settings group with hairline separators.
    private func makeSettingsGroup() -> UIView {
        let container = UIView()
        container.backgroundColor = .surfaceCard
        container.layer.cornerRadius = 20
        container.layer.masksToBounds = true

        let rows = viewModel.settings.enumerated().map { index, item in
            SettingsRowView(item: item, showDivider: index < viewModel.settings.count - 1)
        }
        let stack = UI.vStack(rows, spacing: 0, alignment: .fill)
        stack.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(stack)
        stack.pinEdges(to: container)
        return container
    }
}
