import Foundation
import RxSwift
import RxCocoa

final class URLSessionHttpClient: HttpClient {
    private let urlSession: URLSession

    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }

    func get<T: Decodable>(endpoint: URL) -> Single<T> {
        let request = URLRequest(url: endpoint)
        return urlSession.rx.response(request: request)
            .validate(statusCodes: 200..<300)
            .mapDecodable(T.self)
            .take(1)
            .asSingle()
    }
}
