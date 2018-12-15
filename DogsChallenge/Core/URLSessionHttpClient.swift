import Foundation
import RxSwift
import RxCocoa

final class URLSessionHttpClient: HttpClient {
    private let urlSession: URLSession

    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }

    func get<T: Decodable>(endpoint: URL) -> Single<T> {
        let request = URLRequest(url: endpoint)
        return urlSession.rx.response(request: request)
            .validate(statusCodes: 200..<300)
            .map(T.self)
            .take(1)
            .asSingle()
    }
}

extension Observable where E == (response: HTTPURLResponse, data: Data) {
    func validate(statusCodes: Range<Int>) -> Observable<Data> {
        return self.map {
            let statusCode = $0.response.statusCode
            guard statusCodes ~= statusCode else {
                throw HttpClientError.invalidStatusCode(statusCode)
            }

            return $0.data
        }
    }
}

extension Observable where E == Data {
    func map<T: Decodable>(_: T.Type, jsonDecoder: JSONDecoder = .init()) -> Observable<T> {
        return map {
            return try jsonDecoder.decode(T.self, from: $0)
        }
    }
}
