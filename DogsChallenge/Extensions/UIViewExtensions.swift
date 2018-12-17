import UIKit

extension UIView {
    func breadthFirstSearch<T: UIView>(viewOfType type: T.Type) -> T? {
        var queue = subviews

        while !queue.isEmpty {
            let first = queue.removeFirst()
            if let view = first as? T {
                return view
            } else {
                queue.append(contentsOf: first.subviews)
            }
        }

        return nil
    }

    func activate(_ constraints: NSLayoutConstraint...) {
        NSLayoutConstraint.activate(constraints)
    }

    func removeConstraints() {
        removeConstraints(constraints)
    }

    func setCornerRadius(_ cornerRadius: CGFloat) {
        layer.masksToBounds = true
        layer.cornerRadius = cornerRadius
    }
}
