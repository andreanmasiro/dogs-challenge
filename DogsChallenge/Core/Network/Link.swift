import Foundation

struct Link: Decodable {
    let href: URL

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        href = try container.decode(URL.self)
    }

    enum CodingKeys: String, CodingKey {
        case href
    }
}
