import Nimble
import RxBlocking
import RxSwift
import XCTest

@testable import DogsChallenge

final class URLSessionHttpClientTests: XCTestCase {
    let value = "somestring"
    lazy var correctData = """
        {"value":"\(value)"}
        """.data(using: .utf8)
    let endpoint = URL(string: "http://google.com")!
    
    func testGetWhenResponseIsSuccessReturnsMappedModel() {
        let mockUrlSession = givenURLSession(data: correctData, statusCode: 200)
        let client = URLSessionHttpClient(urlSession: mockUrlSession)

        let get = client.get(endpoint: endpoint) as Single<TestModel>

        expect(try get.toBlocking().first()).to(equal(TestModel(value: value)))
    }

    func testGetWhenStatusCodeErrorThrowsInvalidStatusCodeError() {
        let statusCode = 400
        let mockUrlSession = givenURLSession(data: correctData, statusCode: statusCode)
        let client = URLSessionHttpClient(urlSession: mockUrlSession)

        let get = client.get(endpoint: endpoint) as Single<TestModel>

        expect(try get.toBlocking().first()).to(throwError(HttpClientError.invalidStatusCode(statusCode)))
    }

    private func givenURLSession(data: Data?, statusCode: Int, error: NSError? = nil) -> MockURLSession {
        let mockUrlSession = MockURLSession()
        let response = HTTPURLResponse(url: endpoint, statusCode: statusCode, httpVersion: nil, headerFields: nil)
        mockUrlSession.completionHandlerArguments = (data, response, error)

        return mockUrlSession
    }
}

final class MockURLSession: URLSession {
    var request: URLRequest?
    var completionHandlerArguments: (Data?, URLResponse?, Error?) = (nil, nil, nil)

    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        self.request = request

        let args = completionHandlerArguments
        completionHandler(args.0, args.1, args.2)

        return MockURLSessionDataTask()
    }
}

final class MockURLSessionDataTask: URLSessionDataTask {
    override func resume() {
    }

    override func cancel() {
    }
}
