import UIKit

// One tab's navigation. Builds its root via a closure (injected by AppCoordinator
// so the root can receive its VM + the `showProduct` intent), and pushes the detail
// screen on request.
final class TabCoordinator: Coordinator {
    let navigationController = UINavigationController()
    private let makeRoot: (TabCoordinator) -> UIViewController

    init(makeRoot: @escaping (TabCoordinator) -> UIViewController) {
        self.makeRoot = makeRoot
    }

    func start() {
        navigationController.setViewControllers([makeRoot(self)], animated: false)
    }

    func showProduct(_ product: Product) {
        let vc = AppRoute.productDetail(product).makeViewController()
        navigationController.pushViewController(vc, animated: true)
    }
}
