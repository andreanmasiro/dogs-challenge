import UIKit
import RxSwift

class TableViewCell: UITableViewCell, HeightDefinableView {
    var disposeBag = DisposeBag()
    class var preferredHeight: CGFloat {
        return Metrics.TableRow.default
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
        installConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func initialize() {
        backgroundColor = .clear
    }
    func installConstraints() {}

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}
