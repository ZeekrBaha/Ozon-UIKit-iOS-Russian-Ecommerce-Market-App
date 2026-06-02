import UIKit

// Screen 4 — Корзина (empty). Full-width empty band (red-line #3) + "Вы смотрели".
final class CartViewController: ScrollScreenViewController {
    private let viewModel: CartViewModel
    private let onSelectProduct: (Product) -> Void

    init(viewModel: CartViewModel, onSelectProduct: @escaping (Product) -> Void) {
        self.viewModel = viewModel
        self.onSelectProduct = onSelectProduct
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) not used") }

    override func viewDidLoad() {
        super.viewDidLoad()
        contentStack.spacing = 16

        contentStack.addArrangedSubview(topInsetSpacer(extra: 8))
        contentStack.addArrangedSubview(AppLogoHeaderView())

        // City row
        let city = UI.hStack([UI.label(viewModel.city, Typography.body, .textPrimary),
                              UI.symbol("chevron.down", .textPrimary, size: 13, weight: .semibold),
                              UIView()], spacing: 4)
        contentStack.addArrangedSubview(gutterWrap(city))

        if viewModel.isEmpty {
            contentStack.addArrangedSubview(makeEmptyBand())
        }

        contentStack.addArrangedSubview(gutterWrap(SectionHeaderView("Вы смотрели")))
        let grid = ProductGrid.make(products: viewModel.viewed, onSelect: onSelectProduct)
        contentStack.addArrangedSubview(gutterWrap(grid))
    }

    // Full-width band on backgroundApp (NOT an inset card).
    private func makeEmptyBand() -> UIView {
        let band = UIView()
        band.accessibilityIdentifier = "cartEmptyBand"
        band.isAccessibilityElement = true
        band.accessibilityLabel = "Корзина пуста"

        let title = UI.label("Корзина пуста", Typography.sectionTitle, .textPrimary)
        title.textAlignment = .center
        let body = UI.label("Воспользуйтесь поиском, чтобы найти всё, что нужно. Если в Корзине были товары, войдите, чтобы посмотреть список",
                            Typography.body, .textSecondary, lines: 0)
        body.textAlignment = .center
        let button = Buttons.cartLogin()

        let stack = UI.vStack([title, body, button], spacing: 12, alignment: .center)
        stack.translatesAutoresizingMaskIntoConstraints = false
        band.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: band.topAnchor, constant: 32),
            stack.bottomAnchor.constraint(equalTo: band.bottomAnchor, constant: -32),
            stack.leadingAnchor.constraint(equalTo: band.leadingAnchor, constant: Layout.gutter),
            stack.trailingAnchor.constraint(equalTo: band.trailingAnchor, constant: -Layout.gutter),
            body.widthAnchor.constraint(lessThanOrEqualTo: stack.widthAnchor),
        ])
        return band
    }
}
