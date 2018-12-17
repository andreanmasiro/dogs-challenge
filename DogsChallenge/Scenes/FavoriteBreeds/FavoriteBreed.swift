struct FavoriteBreed: Equatable {
    let name: String
}

extension FavoriteBreed: Codable {}

typealias FavoriteBreeds = [FavoriteBreed]
