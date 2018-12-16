import Foundation

struct Links: Decodable {
    let links: [URL]

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let strings = try container.decode([String].self)
        links = strings.compactMap(URL.init(string:))
    }

    enum CodingKeys: String, CodingKey {
        case links
    }
}
