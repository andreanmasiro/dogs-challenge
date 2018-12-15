import RxSwift

protocol GetGateway {
    associatedtype Model
    func get() -> Single<Model>
}
