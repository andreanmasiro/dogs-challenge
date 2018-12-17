import RxSwift

class HttpGetGateway<Model: Decodable> {
    private let client: HttpClient
    private let endpoint: URL
    private let scheduler: SchedulerType

    init(client: HttpClient = URLSessionHttpClient(),
         endpoint: URL,
         scheduler: SchedulerType = MainScheduler.instance) {
        self.client = client
        self.endpoint = endpoint
        self.scheduler = scheduler
    }

    func get() -> Single<Model> {
        return client.get(endpoint: endpoint).observeOn(scheduler)
    }
}

final class CacheHttpGetGateway<Model: Decodable>: HttpGetGateway<Model> {
    private var cache: Model?

    override func get() -> Single<Model> {
        guard let cache = cache else {
            return super.get().do(onSuccess: { [weak self] in self?.cache = $0 })
        }

        return .just(cache)
    }
}
