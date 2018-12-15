import Nimble
import RxBlocking
import RxSwift
import XCTest

@testable import DogsChallenge

final class ObservableHTTPTests: XCTestCase {
    func testValidateThrowsErrorWhenStatusCodeIsNotInRange() {
        let statusCode = 400
        let response = HTTPURLResponse(url: URL(string: "http://google.com")!, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
        let value = (response, Data())
        let subject = BehaviorSubject<(response: HTTPURLResponse, data: Data)>(value: value)

        expect(try subject.asObservable().validate(statusCodes: 200..<300).toBlocking().first())
            .to(throwError(HttpClientError.invalidStatusCode(statusCode)))
    }

    func testValidateReturnsDataWhenStatusCodeIsInRange() {
        let data = Data()
        let response = HTTPURLResponse(url: URL(string: "http://google.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        let value = (response, data)
        let subject = BehaviorSubject<(response: HTTPURLResponse, data: Data)>(value: value)

        expect(try subject.asObservable().validate(statusCodes: 200..<300).toBlocking().first())
            .to(equal(data))
    }

    func testMapDecodable() {
        let value = "somestring"
        let data = """
        {"value":"\(value)"}
        """.data(using: .utf8)!
        let subject = BehaviorSubject(value: data)

        expect(try subject.mapDecodable(Model.self).toBlocking().first())
            .to(equal(Model(value: value)))
    }
}

private struct Model: Decodable, Equatable {
    let value: String
}
