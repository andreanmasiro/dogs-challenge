import Foundation

struct Links {
    let links: [URL]
}

extension Links: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let strings = try container.decode([String].self)
        links = strings.compactMap(URL.init(string:))
    }

    enum CodingKeys: String, CodingKey {
        case links
    }
}
