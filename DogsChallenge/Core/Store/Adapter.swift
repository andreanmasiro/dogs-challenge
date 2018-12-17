final class BreedAdapter {
    func breedToFavoriteBreed(_ breed: Breed) -> FavoriteBreed {
        return FavoriteBreed(name: breed.name)
    }

    func favoriteBreedToBreed(_ breed: FavoriteBreed) -> Breed {
        return Breed(name: breed.name)
    }
}
