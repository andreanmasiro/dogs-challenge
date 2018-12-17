import Foundation

extension URL {
    private static let baseURL = URL(string: "https://hidden-crag-71735.herokuapp.com/api")!

    static let breeds = baseURL.appendingPathComponent("breeds")
    static func images(_ breedName: String) -> URL {
        return baseURL.appendingPathComponent("\(breedName.lowercased())/images")
    }
}
