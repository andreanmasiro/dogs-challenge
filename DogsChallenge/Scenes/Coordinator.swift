import UIKit
import RxSwift

final class Coordinator {
    private let disposeBag = DisposeBag()

    private let window: UIWindow

    private let breedsViewControllerBuilder: BreedsViewController.Builder
    private let imagesViewControllerBuilder: ImagesViewController.Builder

    private var breedsViewController: BreedsViewController?
    private let breedsGateway: BreedsGateway
    private let favoriteBreedsRepository: FavoriteBreedsStore

    private let imagesGatewayFactory: ImagesGatewayFactory

    private var navigationController: UINavigationController?

    init(window: UIWindow,
         breedsViewControllerBuilder: @escaping BreedsViewController.Builder = BreedsViewController.init,
         imagesViewControllerBuilder: @escaping ImagesViewController.Builder = ImagesViewController.init,
         breedsGateway: BreedsGateway = CacheHttpGetGateway<Breeds>(endpoint: .breeds),
         favoriteBreedsRepository: FavoriteBreedsStore = UserDefaultsStore<FavoriteBreeds>(),
         imagesGatewayFactory: ImagesGatewayFactory = DefaultImagesGatewayFactory()) {
        self.window = window
        self.breedsViewControllerBuilder = breedsViewControllerBuilder
        self.imagesViewControllerBuilder = imagesViewControllerBuilder
        self.breedsGateway = breedsGateway
        self.favoriteBreedsRepository = favoriteBreedsRepository
        self.imagesGatewayFactory = imagesGatewayFactory
    }

    func start() {
        let breedsViewController = breedsViewControllerBuilder(breedsGateway, favoriteBreedsRepository)
        navigationController = UINavigationController(rootViewController: breedsViewController)
        window.rootViewController = navigationController

        bind(to: breedsViewController)
        self.breedsViewController = breedsViewController
    }

    private func navigateToImages(breedName: String, imagesGateway: ImagesGateway) {
        let imagesViewController = imagesViewControllerBuilder(breedName, imagesGateway)
        navigationController?.pushViewController(imagesViewController, animated: true)
    }

    private func bind(to viewController: BreedsViewController) {
        viewController.didSelect
            .map { [imagesGatewayFactory] in ($0.name, imagesGatewayFactory.make(endpoint: .images($0.name))) }
            .subscribe(onNext: { [weak self] in
                self?.navigateToImages(breedName: $0.0, imagesGateway: $0.1)
            })
            .disposed(by: disposeBag)
    }
}

protocol ImagesGatewayFactory {
    func make(endpoint: URL) -> ImagesGateway
}

class DefaultImagesGatewayFactory: ImagesGatewayFactory {
    func make(endpoint: URL) -> ImagesGateway {
        return SingletonModule.shared.makeImagesGateway(endpoint: endpoint)
    }
}
