import RxSwift

protocol ImagesGateway {
    func get() -> Single<Links>
}

typealias Links = [Link]

extension HttpGetGateway: ImagesGateway where Model == Links {}
