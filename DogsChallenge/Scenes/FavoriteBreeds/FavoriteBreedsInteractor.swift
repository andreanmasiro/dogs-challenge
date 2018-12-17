import RxSwift

protocol FavoriteBreedsInteractor {
    func toggle(_ breed: Breed) -> Single<Bool>
    func add(_ breed: Breed) -> Completable
    func add(_ breed: FavoriteBreed) -> Completable
    func remove(_ breed: Breed) -> Completable
    func remove(_ breed: FavoriteBreed) -> Completable
    func isFavorite(_ breed: Breed) -> Single<Bool>
}

final class DefaultFavoriteBreedsInteractor: FavoriteBreedsInteractor {
    private let favoriteBreedsStore: FavoriteBreedsStore
    private let adapter: BreedAdapter

    init(favoriteBreedsStore: FavoriteBreedsStore, adapter: BreedAdapter) {
        self.favoriteBreedsStore = favoriteBreedsStore
        self.adapter = adapter
    }

    func add(_ breed: Breed) -> Completable {
        let newBreed = adapter.breedToFavoriteBreed(breed)
        return add(newBreed)
    }

    func add(_ breed: FavoriteBreed) -> Completable {
        return favoriteBreedsStore.getSingle()
            .map { $0 + [breed] }
            .flatMap { [favoriteBreedsStore] in favoriteBreedsStore.update($0).asMaybe() }
            .ifEmpty(switchTo: Maybe.deferred { [favoriteBreedsStore] in
                favoriteBreedsStore.update([breed]).asMaybe()
            })
            .asObservable()
            .ignoreElements()
    }

    func remove(_ breed: Breed) -> Completable {
        let breedToRemove = adapter.breedToFavoriteBreed(breed)
        return remove(breedToRemove)
    }

    func remove(_ breed: FavoriteBreed) -> Completable {
        return favoriteBreedsStore.getSingle()
            .map { breeds in
                guard let index = breeds.firstIndex(of: breed) else { return breeds }
                var breeds = breeds
                breeds.remove(at: index)
                return breeds
            }
            .flatMap { [favoriteBreedsStore] in favoriteBreedsStore.update($0).asMaybe() }
            .asObservable()
            .ignoreElements()
    }

    func isFavorite(_ breed: Breed) -> Single<Bool> {
        let favoriteBreed = adapter.breedToFavoriteBreed(breed)
        return favoriteBreedsStore.getSingle()
            .map { favorites in
                favorites.contains(favoriteBreed)
            }
            .ifEmpty(switchTo: Single.just(false))
    }

    func toggle(_ breed: Breed) -> Single<Bool> {
        return isFavorite(breed)
            .flatMap {
                let result: Completable
                if $0 { result = self.remove(breed) }
                else { result = self.add(breed) }
                return result.andThen(Single.just(!$0))
            }
    }
}
