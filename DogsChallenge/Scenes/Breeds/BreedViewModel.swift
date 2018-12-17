import UIKit

struct BreedViewModel {
    let name: String
    let favoriteIcon: UIImage?
    let favoriteIconColor: UIColor

    init(breed: Breed) {
        name = breed.name.capitalized
        favoriteIcon = Images.heartOutline
        favoriteIconColor = .accessoryGray
    }
}
