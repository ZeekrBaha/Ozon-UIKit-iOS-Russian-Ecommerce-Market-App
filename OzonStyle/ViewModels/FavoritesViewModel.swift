import Foundation

// Screen 3 state — featured favorite + recommended grid.
final class FavoritesViewModel {
    let featured: Product
    let recommended: [Product]
    init(repository: ProductRepository) {
        featured = repository.featuredFavorite()
        recommended = repository.recommendedProducts()
    }
}
