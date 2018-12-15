import Foundation
import RxSwift

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
    func mapDecodable<T: Decodable>(_: T.Type, jsonDecoder: JSONDecoder = .init()) -> Observable<T> {
        return map {
            return try jsonDecoder.decode(T.self, from: $0)
        }
    }
}