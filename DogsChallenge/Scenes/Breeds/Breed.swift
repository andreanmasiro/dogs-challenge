struct Breed {
    let name: String
}

extension Breed: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        name = try container.decode(String.self)
    }

    enum CodingKeys: String, CodingKey {
        case name
    }
}

typealias Breeds = [Breed]
