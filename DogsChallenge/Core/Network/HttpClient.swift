import Foundation
import RxSwift

protocol HttpClient {
    func get<T: Decodable>(endpoint: URL) -> Single<T>
}

enum HttpClientError: Error {
    case invalidStatusCode(Int)
}
