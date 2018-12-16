import UIKit

extension UITableView {
    func register<T: UITableViewCell>(_: T.Type) {
        register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
    }

    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Failed to dequeue cell of type: \(String(describing: T.self))")
        }

        return cell
    }

    func deselect(animated: Bool) {
        indexPathForSelectedRow.map { deselectRow(at: $0, animated: animated) }
    }
}
