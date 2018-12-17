import Foundation
import RxSwift
import RxCocoa

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

extension PrimitiveSequence where Trait == MaybeTrait, E == Data {
    func mapDecodable<T: Decodable>(_: T.Type, jsonDecoder: JSONDecoder = .init()) -> Maybe<T> {
        return map {
            return try jsonDecoder.decode(T.self, from: $0)
        }
    }
}

extension PrimitiveSequence where Trait == SingleTrait {
    func trackLoading(binder: Binder<Bool>) -> Single<Element> {
        return self.do(onSuccess: { _ in binder.onNext(false) },
                       onError: { _ in binder.onNext(false) },
                       onSubscribed: { binder.onNext(true) })
    }
}

extension ObservableType {
    func unwrap<T>() -> Observable<T> where E == T? {
        return self.filter { $0 != nil }.map { $0! }
    }
}
