import RxSwift

@testable import DogsChallenge

final class MockHttpClient<U: Decodable>: HttpClient {
    var endpoint: URL?
    var response: Single<U>?
    
    func get<T: Decodable>(endpoint: URL) -> Single<T> {
        self.endpoint = endpoint
        return response as! Single<T>
    }
}
