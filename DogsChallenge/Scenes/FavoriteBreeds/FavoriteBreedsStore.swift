import RxSwift

protocol FavoriteBreedsStore {
    func getObservable() -> Observable<FavoriteBreeds>
    func getSingle() -> Maybe<FavoriteBreeds>
    func update(_ value: FavoriteBreeds) -> Single<FavoriteBreeds>
    func delete() -> Completable
}

extension UserDefaultsStore: FavoriteBreedsStore where Model == FavoriteBreeds {}
