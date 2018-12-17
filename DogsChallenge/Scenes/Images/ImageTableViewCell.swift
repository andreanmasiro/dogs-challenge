import UIKit

final class ImageTableViewCell: TableViewCell {
    override class var preferredHeight: CGFloat {
        return Metrics.Device.width * 0.8
    }

    let imageImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(imageImageView)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func draw(_ rect: CGRect) {
        imageImageView.setCornerRadius(imageImageView.frame.height/2)
        super.draw(rect)
    }

    override func layoutSubviews() {
        layoutImageView()
        super.layoutSubviews()
    }

    private func layoutImageView() {
        activate(
            imageImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, constant: -(Metrics.margin * 2)),
            imageImageView.widthAnchor.constraint(equalTo: imageImageView.heightAnchor),
            imageImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        )
    }
}
