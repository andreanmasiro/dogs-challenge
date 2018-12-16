import RxSwift

@testable import DogsChallenge

final class MockBreedsGateway: BreedsGateway {
    var wasGetCalled = false
    var getStub: Single<Breeds>?
    
    func get() -> Single<Breeds> {
        wasGetCalled = true
        return getStub!
    }
}
