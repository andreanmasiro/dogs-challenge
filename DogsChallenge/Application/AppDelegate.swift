import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let window = UIWindow(frame: UIScreen.main.bounds)
        
        #if !TEST
        let breedsCoordinator = BreedsCoordinator()
        let appCoordinator = AppCoordinator(window: window, breedsCoordinator: breedsCoordinator)
        appCoordinator.start()
        self.appCoordinator = appCoordinator
        #else
        window.rootViewController = UIViewController()
        #endif

        window.makeKeyAndVisible()
        self.window = window

        return true
    }
}
