import UIKit

// App lifecycle. Uses the legacy window-based lifecycle (no SceneDelegate / scene
// manifest) to keep the XcodeGen-generated Info.plist simple — see
// validation-report.md "Known deviations". The window + root are built by
// AppCoordinator (the composition root).
@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private var appCoordinator: AppCoordinator?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.tintColor = .brandPrimary

        let coordinator = AppCoordinator(window: window)
        coordinator.start()

        self.window = window
        self.appCoordinator = coordinator
        window.makeKeyAndVisible()
        return true
    }
}
