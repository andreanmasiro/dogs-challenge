import UIKit

extension UIView {
    func breadthFirstSearch<T: UIView>(viewOfType type: T.Type) -> T? {
        var queue = [self]

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
}
