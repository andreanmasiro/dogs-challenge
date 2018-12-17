import UIKit

struct BreedViewModel {
    let name: String
    let favoriteIcon: UIImage?
    let favoriteIconColor: UIColor

    init(breed: Breed, isFavorite: Bool) {
        name = breed.name.capitalized
        favoriteIcon = isFavorite ? Images.heartFill : Images.heartOutline
        favoriteIconColor = isFavorite ? .heartRed : .accessoryGray
    }
}
