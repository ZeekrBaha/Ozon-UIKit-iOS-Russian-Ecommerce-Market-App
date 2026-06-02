import UIKit

// Builds an N-column product grid as a vertical stack of horizontal rows, each
// card a `ProductCardView`. Cards in a row are equal-height (.fill). The screen
// insets the result by `gutter`. Keeps the keystone rule (one card view) without a
// collection-view data source for this static content.
enum ProductGrid {
    static func make(products: [Product],
                     columns: Int = 2,
                     onSelect: @escaping (Product) -> Void) -> UIStackView {
        let rows = stride(from: 0, to: products.count, by: columns).map { start -> UIStackView in
            let slice = Array(products[start..<min(start + columns, products.count)])
            var cards: [UIView] = slice.map { product in
                ProductCardView(product: product) { onSelect(product) }
            }
            // Pad the final short row so cards keep grid-cell width.
            while cards.count < columns { cards.append(UIView()) }
            let row = UIStackView(arrangedSubviews: cards)
            row.axis = .horizontal
            row.spacing = Layout.cardSpacing
            row.distribution = .fillEqually
            row.alignment = .fill
            return row
        }
        let grid = UIStackView(arrangedSubviews: rows)
        grid.axis = .vertical
        grid.spacing = Layout.gridSpacing
        grid.alignment = .fill
        return grid
    }
}
