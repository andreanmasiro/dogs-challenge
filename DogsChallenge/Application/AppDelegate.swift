import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let window = UIWindow(frame: UIScreen.main.bounds)
        
        #if !TEST
        let viewController = BreedsViewController()
        window.rootViewController = viewController
        #else
        window.rootViewController = UIViewController()
        #endif

        window.makeKeyAndVisible()
        self.window = window

        return true
    }
}
