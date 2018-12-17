import RxSwift

protocol FavoriteBreedsInteractor {
    func add(_ breed: Breed) -> Completable
    func remove(_ breed: Breed) -> Completable
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
}
