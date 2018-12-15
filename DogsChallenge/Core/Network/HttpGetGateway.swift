import RxSwift

class HttpGetGateway<Model: Decodable>: GetGateway {
    private let client: HttpClient
    private let endpoint: URL

    init(client: HttpClient, endpoint: URL) {
        self.client = client
        self.endpoint = endpoint
    }

    func get() -> Single<Model> {
        return client.get(endpoint: endpoint)
    }
}
