@testable import DogsChallenge
import RxSwift

final class MockFavoriteBreedsInteractor: FavoriteBreedsInteractor {
    func toggle(_ breed: Breed) -> Single<Bool> {
        Single.just(true)
    }

    func add(_ breed: Breed) -> Completable {
        Completable.empty()
    }

    func add(_ breed: FavoriteBreed) -> Completable {
        Completable.empty()
    }

    func remove(_ breed: Breed) -> Completable {
        Completable.empty()
    }

    func remove(_ breed: FavoriteBreed) -> Completable {
        Completable.empty()
    }

    func isFavorite(_ breed: Breed) -> Single<Bool> {
        Single.just(true)
    }
}
