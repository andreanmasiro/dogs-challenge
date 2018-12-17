import Foundation

struct FavoriteBreedViewModel {
    let name: String
    let imageLinks: [URL]

    init(favoriteBreed: FavoriteBreed, links: Links) {
        self.name = favoriteBreed.name.capitalized
        self.imageLinks = links.links
    }
}
