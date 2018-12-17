import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var coordinator: BreedsCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let window = UIWindow(frame: UIScreen.main.bounds)
        
        #if !TEST
        let coordinator = BreedsCoordinator(window: window)
        coordinator.start()
        self.coordinator = coordinator
        #else
        window.rootViewController = UIViewController()
        #endif

        window.makeKeyAndVisible()
        self.window = window

        return true
    }
}
