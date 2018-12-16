import Foundation
import RxSwift

final class UserDefaultsRepository<Model: Codable> {
    private let userDefaults: UserDefaults
    private let jsonEncoder: JSONEncoder
    private let jsonDecoder: JSONDecoder
    private let key = String(describing: Model.self)

    init(userDefaults: UserDefaults = .standard,
         jsonEncoder: JSONEncoder = .init(),
         jsonDecoder: JSONDecoder = .init()) {
        self.jsonEncoder = jsonEncoder
        self.jsonDecoder = jsonDecoder
        self.userDefaults = userDefaults
    }

    func getSingle() -> Maybe<Model> {
        return Maybe.deferred { [userDefaults, jsonDecoder, key] in
            guard let data = userDefaults.data(forKey: key) else {
                return .empty()
            }

            return Maybe.just(data).mapDecodable(Model.self, jsonDecoder: jsonDecoder)
        }
    }

    func update(_ value: Model) -> Single<Model> {
        return Single.deferred { [userDefaults, jsonEncoder, key] in
            let data = try jsonEncoder.encode(value)
            userDefaults.setValue(data, forKey: key)
            return .just(value)
        }
    }

    func delete() -> Completable {
        return Completable.deferred { [userDefaults, key] in
            userDefaults.setValue(nil, forKey: key)
            return .empty()
        }
    }
}
