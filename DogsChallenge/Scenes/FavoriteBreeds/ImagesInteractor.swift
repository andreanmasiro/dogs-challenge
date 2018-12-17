import Foundation
import RxSwift

protocol ImagesInteractor {
    func images(forBreed breed: Breed) -> Single<Links>
}

final class DefaultImagesInteractor: ImagesInteractor {
    private let imagesGatewayFactory: ImagesGatewayFactory

    init(imagesGatewayFactory: ImagesGatewayFactory = DefaultImagesGatewayFactory()) {
        self.imagesGatewayFactory = imagesGatewayFactory
    }

    func images(forBreed breed: Breed) -> Single<Links> {
        return imagesGatewayFactory
            .make(endpoint: .images(breed.name))
            .get()
    }
}
