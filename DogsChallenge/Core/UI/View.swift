import UIKit

class View: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
        installConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func initialize() {}
    func installConstraints() {}
}
