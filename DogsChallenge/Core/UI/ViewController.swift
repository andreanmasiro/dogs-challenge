import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    let loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
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
        view.addSubview(loadingView)
    }

    func installConstraints() {
        loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}

extension Reactive where Base: ViewController {
    var loading: Binder<Bool> {
        return base.loadingView.rx.isAnimating
    }
}
