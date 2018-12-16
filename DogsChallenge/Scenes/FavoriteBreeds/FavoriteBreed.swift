struct FavoriteBreed {
    let name: String
}

extension FavoriteBreed: Codable {}

typealias FavoriteBreeds = [FavoriteBreed]
