import UIKit

class TableViewCell: UITableViewCell, HeightDefinableView {
    class var preferredHeight: CGFloat {
        return 44
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
        installConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func initialize() {}
    func installConstraints() {}
}
