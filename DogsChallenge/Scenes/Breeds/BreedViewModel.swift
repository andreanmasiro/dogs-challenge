import UIKit

struct BreedViewModel {
    let name: String
    let favoriteIcon: UIImage?
    let favoriteIconColor: UIColor

    init(breed: Breed) {
        name = breed.name
        favoriteIcon = Images.heartOutline
        favoriteIconColor = .accessoryGray
    }
}
