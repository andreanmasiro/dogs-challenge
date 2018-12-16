import RxSwift

protocol FavoriteBreedsRepository {
    func getSingle() -> Maybe<FavoriteBreeds>
    func update(_ value: FavoriteBreeds) -> Single<FavoriteBreeds>
    func delete() -> Completable
}

extension UserDefaultsRepository: FavoriteBreedsRepository where Model == FavoriteBreeds {}
