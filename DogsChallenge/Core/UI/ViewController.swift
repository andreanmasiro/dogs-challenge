import UIKit

class ViewController: UIViewController {
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

    func initialize() {}
    func installConstraints() {}
}
