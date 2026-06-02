import Foundation

// Screen 5 state — settings rows + recommended grid.
final class ProfileViewModel {
    let settings: [SettingsItem]
    let recommended: [Product]
    init(repository: ProductRepository) {
        settings = repository.settings()
        recommended = repository.recommendedProducts()
    }
}
