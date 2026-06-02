import Foundation

// Screen 2 state — the category grid.
final class CatalogViewModel {
    let categories: [Category]
    init(repository: ProductRepository) {
        categories = repository.categories()
    }
}
