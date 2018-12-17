import Foundation
import RxSwift

protocol ImagesInteractor {
    func images(forBreed breed: Breed) -> Single<Links>
    func images(forBreed favoriteBreed: FavoriteBreed) -> Single<Links>
}

final class DefaultImagesInteractor: ImagesInteractor {
    private let imagesGatewayFactory: ImagesGatewayFactory

    init(imagesGatewayFactory: ImagesGatewayFactory = DefaultImagesGatewayFactory()) {
        self.imagesGatewayFactory = imagesGatewayFactory
    }

    func images(forBreed breed: Breed) -> Single<Links> {
        return images(for: breed.name)
    }

    func images(forBreed favoriteBreed: FavoriteBreed) -> Single<Links> {
        return images(for: favoriteBreed.name)
    }

    private func images(for breedName: String) -> Single<Links> {
        return imagesGatewayFactory
            .make(endpoint: .images(breedName))
            .get()
    }
}
