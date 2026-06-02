import UIKit

// Composition root. Builds the repository, all five ViewModels, the tab bar, and
// five TabCoordinators once; owns the object graph for the app's lifetime.
final class AppCoordinator {
    private let window: UIWindow
    private let repository: ProductRepository
    private let tabBarController = UITabBarController()
    private var tabCoordinators: [TabCoordinator] = []

    init(window: UIWindow, repository: ProductRepository = SampleDataRepository()) {
        self.window = window
        self.repository = repository
    }

    func start() {
        let homeVM = HomeViewModel(repository: repository)
        let catalogVM = CatalogViewModel(repository: repository)
        let favoritesVM = FavoritesViewModel(repository: repository)
        let cartVM = CartViewModel(repository: repository)
        let profileVM = ProfileViewModel(repository: repository)

        let home = TabCoordinator { coord in
            let vc = HomeViewController(viewModel: homeVM, onSelectProduct: coord.showProduct)
            vc.tabBarItem = Self.tabItem("Главная", "house", selected: "house.fill")
            return vc
        }
        let catalog = TabCoordinator { _ in
            let vc = CatalogViewController(viewModel: catalogVM)
            vc.tabBarItem = Self.tabItem("Каталог", "magnifyingglass", selected: nil)
            return vc
        }
        let favorites = TabCoordinator { coord in
            let vc = FavoritesViewController(viewModel: favoritesVM, onSelectProduct: coord.showProduct)
            vc.tabBarItem = Self.tabItem("Избранное", "heart", selected: "heart.fill")
            return vc
        }
        let cart = TabCoordinator { coord in
            let vc = CartViewController(viewModel: cartVM, onSelectProduct: coord.showProduct)
            vc.tabBarItem = Self.tabItem("Корзина", "basket", selected: "basket.fill")
            return vc
        }
        let profile = TabCoordinator { coord in
            let vc = ProfileViewController(viewModel: profileVM, onSelectProduct: coord.showProduct)
            vc.tabBarItem = Self.tabItem("Мой Ozon", "person", selected: "person.crop.circle.fill")
            return vc
        }

        tabCoordinators = [home, catalog, favorites, cart, profile]
        tabCoordinators.forEach { $0.start() }
        tabBarController.viewControllers = tabCoordinators.map { $0.navigationController }

        configureTabBarAppearance()
        window.rootViewController = tabBarController
    }

    private static func tabItem(_ title: String, _ image: String, selected: String?) -> UITabBarItem {
        UITabBarItem(title: title,
                     image: UIImage(systemName: image),
                     selectedImage: selected.flatMap { UIImage(systemName: $0) })
    }

    // White bar; inactive = textSecondary (active uses the window tint = brandPrimary).
    private func configureTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .surfaceCard
        for layout in [appearance.stackedLayoutAppearance,
                       appearance.inlineLayoutAppearance,
                       appearance.compactInlineLayoutAppearance] {
            layout.normal.iconColor = .textSecondary
            layout.normal.titleTextAttributes = [.foregroundColor: UIColor.textSecondary]
        }
        tabBarController.tabBar.standardAppearance = appearance
        tabBarController.tabBar.scrollEdgeAppearance = appearance
        tabBarController.tabBar.tintColor = .brandPrimary
    }
}
