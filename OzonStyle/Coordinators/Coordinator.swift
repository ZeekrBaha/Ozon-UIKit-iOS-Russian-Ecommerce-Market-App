import UIKit

// Owns a navigation stack and its start-up. Concrete coordinators wire view models
// and view controllers; views never push other views directly.
protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get }
    func start()
}
