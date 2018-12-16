import UIKit

extension UITableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

protocol HeightDefinableView: class {
    static var preferredHeight: CGFloat { get }
}
