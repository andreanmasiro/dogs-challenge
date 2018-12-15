import Nimble
import RxBlocking
import RxSwift
import RxCocoa
import XCTest

@testable import DogsChallenge

final class ObservableHTTPTests: XCTestCase {
    func testValidateThrowsErrorWhenStatusCodeIsNotInRange() {
        let statusCode = 400
        let response = HTTPURLResponse(url: URL(string: "http://google.com")!, statusCode: statusCode, httpVersion: nil, headerFields: nil)!

        let observable = Observable<(response: HTTPURLResponse, data: Data)>.deferred {
             .just((response, Data()))
        }

        expect(try observable.validate(statusCodes: 200..<300).toBlocking().first())
            .to(throwError(HttpClientError.invalidStatusCode(statusCode)))
    }

    func testValidateReturnsDataWhenStatusCodeIsInRange() {
        let data = Data()
        let response = HTTPURLResponse(url: URL(string: "http://google.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!

        let observable = Observable<(response: HTTPURLResponse, data: Data)>.deferred {
            .just((response, data))
        }
        expect(try observable.validate(statusCodes: 200..<300).toBlocking().first())
            .to(equal(data))
    }

    func testMapDecodable() {
        let value = "somestring"
        let data = """
        {"value":"\(value)"}
        """.data(using: .utf8)!
        let observable = Observable<Data>.deferred { .just(data) }

        expect(try observable.mapDecodable(TestModel.self).toBlocking().first())
            .to(equal(TestModel(value: value)))
    }

    func testTrackLoading() {
        struct Error: Swift.Error {}
        class Loader {
            var loading: Bool = false
        }
        let loader = Loader()
        let binder = Binder<Bool>(loader) {
            $0.loading = $1
        }

        let subject = PublishSubject<Void>()

        _ = subject.take(1).asSingle().trackLoading(binder: binder).subscribe()
        expect(loader.loading).toEventually(beTrue())
        subject.onNext(())
        expect(loader.loading).toEventually(beFalse())

        _ = subject.take(1).asSingle().trackLoading(binder: binder).subscribe()
        expect(loader.loading).toEventually(beTrue())
        subject.onError(Error())
        expect(loader.loading).toEventually(beFalse())
    }
}
