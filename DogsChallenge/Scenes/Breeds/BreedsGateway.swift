import RxSwift

protocol BreedsGateway {
    func get() -> Single<Breeds>
}

extension HttpGetGateway: BreedsGateway where Model == Breeds {}
