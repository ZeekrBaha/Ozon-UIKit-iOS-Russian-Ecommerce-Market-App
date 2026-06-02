import UIKit

// Screen 2 — Каталог. Centered logo + search + 3-col category grid.
final class CatalogViewController: ScrollScreenViewController {
    private let viewModel: CatalogViewModel

    init(viewModel: CatalogViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) not used") }

    override func viewDidLoad() {
        super.viewDidLoad()
        contentStack.spacing = 16

        contentStack.addArrangedSubview(topInsetSpacer(extra: 8))
        contentStack.addArrangedSubview(AppLogoHeaderView())
        contentStack.addArrangedSubview(gutterWrap(SearchBarView(fill: .searchFill, trailing: [.camera])))

        let cards = viewModel.categories.map { CategoryCardView(category: $0) }
        contentStack.addArrangedSubview(gutterWrap(rowsGrid(cards, columns: 3)))
    }
}
