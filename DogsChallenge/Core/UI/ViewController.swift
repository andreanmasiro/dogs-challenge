import UIKit
import RxSwift
import RxCocoa

enum ViewControllerState {
    case idle
    case loading
    case error(Error)

    var isLoading: Bool {
        switch self {
        case .loading: return true
        default: return false
        }
    }

    var isError: Bool {
        switch self {
        case .error: return true
        default: return false
        }
    }

    var activityIndicatorAction: (UIActivityIndicatorView) -> () -> Void {
        if isLoading {
            return UIActivityIndicatorView.startAnimating
        } else {
            return UIActivityIndicatorView.stopAnimating
        }
    }

    var error: Error? {
        if case let .error(error) = self {
            return error
        }
        return nil
    }
}

class ViewController: UIViewController {
    let disposeBag = DisposeBag()

    var state = ViewControllerState.idle

    var retryObservable: Observable<Void> {
        return errorView.retryButton.rx.tap.asObservable()
    }

    let loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .gray)
        view.hidesWhenStopped = true
        view.stopAnimating()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let errorView: ErrorView = {
        let view = ErrorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func loadView() {
        super.loadView()
        initialize()
        installConstraints()
    }

    func initialize() {
        view.backgroundColor = .white
        view.addSubview(loadingView)
        view.addSubview(errorView)
        errorView.bounds = view.frame
        errorView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

    func installConstraints() {
        view.activate(
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorView.heightAnchor.constraint(equalTo: view.heightAnchor),
            errorView.widthAnchor.constraint(equalTo: view.widthAnchor)
        )
    }

    func setState(_ state: ViewControllerState) {
        self.state = state
        state.activityIndicatorAction(loadingView)()
        state.error.map(errorView.bind)

        errorView.isHidden = !state.isError
    }
}

extension Reactive where Base: ViewController {
    var state: Binder<ViewControllerState> {
        return Binder<ViewControllerState>(base) { target, value in
            target.setState(value)
        }
    }
}

extension PrimitiveSequence where Trait == SingleTrait {
    func trackError<T>(_ errorHandler: @escaping (Error) -> Void, retryWhen notifier: Observable<T>) -> Single<Element> {
        return retryWhen { observable -> Observable<T> in
            observable.flatMap { error -> Observable<T> in
                errorHandler(error)
                return notifier
            }
        }
    }
}

extension Observable {
    func trackError<T>(_ errorHandler: @escaping (Error) -> Void, retryWhen notifier: Observable<T>) -> Observable<Element> {
        return retryWhen { observable -> Observable<T> in
            observable.flatMap { error -> Observable<T> in
                errorHandler(error)
                return notifier
            }
        }
    }
}
