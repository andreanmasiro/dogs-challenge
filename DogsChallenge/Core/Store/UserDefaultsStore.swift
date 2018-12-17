import Foundation
import RxSwift
import RxCocoa

final class UserDefaultsStore<Model: Codable> {
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

    func getObservable() -> Observable<Model> {
        return Observable.deferred { [weak self] in Observable.just(self?.data()) }
            .concat(userDefaults.rx.observe(Data.self, key))
            .unwrap()
            .mapDecodable(Model.self, jsonDecoder: jsonDecoder)
    }

    func getSingle() -> Maybe<Model> {
        return Maybe.deferred { [weak self, jsonDecoder] in
            guard let data = self?.data() else {
                return .empty()
            }

            return Maybe.just(data).mapDecodable(Model.self, jsonDecoder: jsonDecoder)
        }
    }

    func update(_ value: Model) -> Single<Model> {
        return Single.deferred { [weak self, jsonEncoder] in
            let data = try jsonEncoder.encode(value)
            self?.setData(data)
            return .just(value)
        }
    }

    func delete() -> Completable {
        return Completable.deferred { [userDefaults, key] in
            userDefaults.setValue(nil, forKey: key)
            return .empty()
        }
    }

    private func data() -> Data? {
        return userDefaults.data(forKey: key)
    }

    private func setData(_ data: Data?) {
        userDefaults.setValue(data, forKey: key)
    }
}
