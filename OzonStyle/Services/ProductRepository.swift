import Foundation

// Data-access seam (MVVM-C "Model" boundary). ViewModels depend on this protocol,
// never on `SampleData` directly — so the mock source can be swapped for a
// network/database layer without touching any ViewModel or View.
protocol ProductRepository {
    func banners() -> [Banner]
    func quickActions() -> [QuickAction]
    func recommendedProducts() -> [Product]
    func viewedProducts() -> [Product]
    func featuredFavorite() -> Product
    func categories() -> [Category]
    func settings() -> [SettingsItem]
}

// Concrete implementation backed by the in-memory `SampleData` fixtures.
struct SampleDataRepository: ProductRepository {
    func banners() -> [Banner] { SampleData.banners }
    func quickActions() -> [QuickAction] { SampleData.quickActions }
    func recommendedProducts() -> [Product] { SampleData.recommended }
    func viewedProducts() -> [Product] { SampleData.viewed }
    func featuredFavorite() -> Product { SampleData.watch }
    func categories() -> [Category] { SampleData.categories }
    func settings() -> [SettingsItem] { SampleData.settings }
}
