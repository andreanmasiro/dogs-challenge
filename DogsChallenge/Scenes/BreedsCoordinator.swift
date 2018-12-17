import UIKit
import RxSwift

final class BreedsCoordinator {
    private let disposeBag = DisposeBag()

    private let breedsViewControllerBuilder: BreedsViewController.Builder
    private let imagesViewControllerBuilder: ImagesViewController.Builder

    private var breedsViewController: BreedsViewController?
    private let breedsGateway: BreedsGateway
    private let favoriteBreedsInteractor: FavoriteBreedsInteractor
    private let favoriteBreedsStore: FavoriteBreedsStore

    private let imagesGatewayFactory: ImagesGatewayFactory

    let navigationController = UINavigationController()

    init(breedsViewControllerBuilder: @escaping BreedsViewController.Builder = BreedsViewController.init,
         imagesViewControllerBuilder: @escaping ImagesViewController.Builder = ImagesViewController.init,
         breedsGateway: BreedsGateway = CacheHttpGetGateway<Breeds>(endpoint: .breeds),
         favoriteBreedsStore: FavoriteBreedsStore = UserDefaultsStore<FavoriteBreeds>(),
         imagesGatewayFactory: ImagesGatewayFactory = DefaultImagesGatewayFactory(),
         favoriteBreedsInteractorFactory: FavoriteBreedsInteractorFactory = DefaultFavoriteBreedsInteractorFactory()) {
        self.breedsViewControllerBuilder = breedsViewControllerBuilder
        self.imagesViewControllerBuilder = imagesViewControllerBuilder
        self.breedsGateway = breedsGateway
        self.favoriteBreedsStore = favoriteBreedsStore
        self.imagesGatewayFactory = imagesGatewayFactory
        self.favoriteBreedsInteractor = favoriteBreedsInteractorFactory.make(store: favoriteBreedsStore)
    }

    func start() {
        let breedsViewController = breedsViewControllerBuilder(breedsGateway, favoriteBreedsInteractor)
        navigationController.viewControllers = [breedsViewController]
        bind(to: breedsViewController)
        self.breedsViewController = breedsViewController
    }

    private func navigateToImages(breedName: String, imagesGateway: ImagesGateway) {
        let imagesViewController = imagesViewControllerBuilder(breedName, imagesGateway)
        navigationController.pushViewController(imagesViewController, animated: true)
    }

    private func bind(to viewController: BreedsViewController) {
        viewController.didSelect
            .map { [imagesGatewayFactory] in ($0.name, imagesGatewayFactory.make(endpoint: .images($0.name))) }
            .subscribe(onNext: { [weak self] in
                self?.navigateToImages(breedName: $0.0.capitalized, imagesGateway: $0.1)
            })
            .disposed(by: disposeBag)
    }
}

protocol FavoriteBreedsInteractorFactory {
    func make(store: FavoriteBreedsStore) -> FavoriteBreedsInteractor
}

class DefaultFavoriteBreedsInteractorFactory: FavoriteBreedsInteractorFactory {
    func make(store: FavoriteBreedsStore) -> FavoriteBreedsInteractor {
        return DefaultFavoriteBreedsInteractor(favoriteBreedsStore: store, adapter: BreedAdapter())
    }
}
