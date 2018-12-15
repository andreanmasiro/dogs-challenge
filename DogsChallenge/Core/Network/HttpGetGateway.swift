import RxSwift

final class HttpGetGateway<Model: Decodable> {
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
