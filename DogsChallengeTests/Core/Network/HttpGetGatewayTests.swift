import Nimble
import RxBlocking
import RxSwift
import XCTest

@testable import DogsChallenge

final class HttpGetGatewayTests: XCTestCase {
    func testWhenRequestIsSuccessfulGatewaySendsTheCorrectEndpointAndReturnsTheCorrectResponse() {
        let endpoint = URL(string: "http://get.breeds.com")!
        let stubResponse = TestModel(value: "value")
        let mockClient = MockHttpClient<TestModel>()

        let gateway = HttpGetGateway<TestModel>(client: mockClient, endpoint: endpoint)

        mockClient.response = Single.just(stubResponse)

        expect(try gateway.get().toBlocking().first()).to(equal(stubResponse))
        expect(mockClient.endpoint).to(equal(endpoint))
    }

    func testWhenRequestFailsGatewayThrowsTheSameError() {
        let endpoint = URL(string: "http://get.breeds.com")!
        let stubError = HttpClientError.invalidStatusCode(400)
        let mockClient = MockHttpClient<TestModel>()

        let gateway = HttpGetGateway<TestModel>(client: mockClient, endpoint: endpoint)

        mockClient.response = Single.error(stubError)

        expect(try gateway.get().toBlocking().first()).to(throwError(stubError))
    }

    func testCacheGatewayDoesNotCallGatewayIfHasCache() throws {
        let endpoint = URL(string: "http://get.breeds.com")!
        let stubResponse = TestModel(value: "value")
        let mockClient = MockHttpClient<TestModel>()

        let gateway = CacheHttpGetGateway<TestModel>(client: mockClient, endpoint: endpoint)

        var callCount = 0
        mockClient.response = Single.deferred {
            callCount += 1
            return .just(stubResponse)
        }

        _ = try gateway.get().toBlocking().first()
        _ = try gateway.get().toBlocking().first()

        expect(callCount) == 1
    }
}
