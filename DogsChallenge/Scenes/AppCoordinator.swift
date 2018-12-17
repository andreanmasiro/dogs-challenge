import UIKit
import RxSwift

final class AppCoordinator {
    private let window: UIWindow

    private let favoriteBreedsStore: FavoriteBreedsStore
    private let favoriteBreedsInteractor: FavoriteBreedsInteractor
    private let imagesGatewayFactory: ImagesGatewayFactory
    private let imagesInteractor: ImagesInteractor

    private let favoriteBreedsViewControllerBuilder: FavoriteBreedsViewController.Builder

    private let breedsCoordinator: BreedsCoordinator

    private let tabBarController = UITabBarController()

    init(window: UIWindow,
         breedsCoordinator: BreedsCoordinator,
         favoriteBreedsStore: FavoriteBreedsStore = UserDefaultsStore<FavoriteBreeds>(),
         favoriteBreedsInteractorFactory: FavoriteBreedsInteractorFactory = DefaultFavoriteBreedsInteractorFactory(),
         imagesGatewayFactory: ImagesGatewayFactory = DefaultImagesGatewayFactory(),
         favoriteBreedsViewControllerBuilder: @escaping FavoriteBreedsViewController.Builder = FavoriteBreedsViewController.init) {
        self.window = window
        self.favoriteBreedsStore = favoriteBreedsStore
        self.favoriteBreedsInteractor = favoriteBreedsInteractorFactory.make(store: favoriteBreedsStore)
        self.favoriteBreedsViewControllerBuilder = favoriteBreedsViewControllerBuilder
        self.breedsCoordinator = breedsCoordinator
        self.imagesGatewayFactory = imagesGatewayFactory
        self.imagesInteractor = DefaultImagesInteractor(imagesGatewayFactory: imagesGatewayFactory)
    }

    func start() {
        breedsCoordinator.start()
        let favoriteBreedsViewController = favoriteBreedsViewControllerBuilder(
            favoriteBreedsInteractor, favoriteBreedsStore, imagesInteractor
        )
        let favoriteNavigationController = UINavigationController(rootViewController: favoriteBreedsViewController)
        tabBarController.viewControllers = [breedsCoordinator.navigationController, favoriteNavigationController]

        breedsCoordinator.navigationController.tabBarItem = UITabBarItem(title: "Breeds",
                                                                         image: nil,
                                                                         selectedImage: nil)
        favoriteBreedsViewController.tabBarItem = UITabBarItem(title: "Favorites",
                                                               image: nil,
                                                               selectedImage: nil)

        window.rootViewController = tabBarController
    }
}
