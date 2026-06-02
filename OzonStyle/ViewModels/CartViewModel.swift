import Foundation

// Screen 4 state — empty cart + "viewed" grid.
final class CartViewModel {
    let viewed: [Product]
    let isEmpty: Bool = true
    let city = "Астана"
    init(repository: ProductRepository) {
        viewed = repository.viewedProducts()
    }
}
