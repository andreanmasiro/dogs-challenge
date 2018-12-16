final class BreedAdapter {
    func breedToFavoriteBreed(_ breed: Breed) -> FavoriteBreed {
        return FavoriteBreed(name: breed.name)
    }
}
