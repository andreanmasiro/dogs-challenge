import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    let loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .gray)
        view.hidesWhenStopped = true
        view.stopAnimating()
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
    }

    func installConstraints() {
        loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    func onLoading(_ isLoading: Bool) {}
}

extension Reactive where Base: ViewController {
    var loading: Binder<Bool> {
        return Binder<Bool>(base) { target, value in
            target.loadingView.rx.isAnimating.onNext(value)
            target.onLoading(value)
        }
    }
}
