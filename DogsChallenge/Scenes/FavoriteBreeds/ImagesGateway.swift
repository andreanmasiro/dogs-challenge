import RxSwift

protocol ImagesGateway {
    func get() -> Single<Links>
}

extension HttpGetGateway: ImagesGateway where Model == Links {}
