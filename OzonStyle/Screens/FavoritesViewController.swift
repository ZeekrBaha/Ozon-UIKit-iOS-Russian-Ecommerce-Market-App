import UIKit

// Screen 3 — Избранное. Filter row + compact left-aligned featured + 2-col grid.
final class FavoritesViewController: ScrollScreenViewController {
    private let viewModel: FavoritesViewModel
    private let onSelectProduct: (Product) -> Void

    init(viewModel: FavoritesViewModel, onSelectProduct: @escaping (Product) -> Void) {
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
        contentStack.addArrangedSubview(gutterWrap(SearchBarView(fill: .searchFill, trailing: [.camera])))

        // Filter row
        let filters = UI.hStack([SortChipView(), FilterChipView(kind: .filters),
                                 FilterChipView(kind: .brand), UIView()], spacing: 10)
        contentStack.addArrangedSubview(gutterWrap(filters))

        // Featured — compact, left-aligned (red-line #2)
        contentStack.addArrangedSubview(gutterWrap(makeFeaturedRow()))

        contentStack.addArrangedSubview(gutterWrap(SectionHeaderView("Подобрали для вас")))
        let grid = ProductGrid.make(products: viewModel.recommended, onSelect: onSelectProduct)
        contentStack.addArrangedSubview(gutterWrap(grid))
    }

    private func makeFeaturedRow() -> UIView {
        let featured = viewModel.featured
        let card = ProductCardView(product: featured) { [weak self] in
            self?.onSelectProduct(featured)
        }
        let row = UIView()
        card.translatesAutoresizingMaskIntoConstraints = false
        row.addSubview(card)
        NSLayoutConstraint.activate([
            card.leadingAnchor.constraint(equalTo: row.leadingAnchor),
            card.topAnchor.constraint(equalTo: row.topAnchor),
            card.bottomAnchor.constraint(equalTo: row.bottomAnchor),
            card.trailingAnchor.constraint(lessThanOrEqualTo: row.trailingAnchor),
            // grid-card width = (rowWidth - cardSpacing) / 2
            card.widthAnchor.constraint(equalTo: row.widthAnchor, multiplier: 0.5,
                                        constant: -Layout.cardSpacing / 2),
        ])
        return row
    }
}
