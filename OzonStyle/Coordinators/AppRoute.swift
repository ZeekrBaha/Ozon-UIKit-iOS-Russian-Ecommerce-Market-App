import UIKit

// Navigation destinations a coordinator can push. One route today; add cases here
// as the prototype grows.
enum AppRoute {
    case productDetail(Product)

    func makeViewController() -> UIViewController {
        switch self {
        case .productDetail(let product):
            return ProductDetailViewController(product: product)
        }
    }
}
