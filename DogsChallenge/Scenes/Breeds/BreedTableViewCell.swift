import UIKit

final class BreedTableViewCell: TableViewCell {
    lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.tintColor = .accessoryGray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(favoriteButton)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        remakeFavoriteButtonConstraints()
    }

    private func remakeFavoriteButtonConstraints() {
        favoriteButton.removeConstraints()
        activate(
            favoriteButton.trailingAnchor
                .constraint(equalTo: accessoryView?.leadingAnchor ?? contentView.trailingAnchor,
                            constant: -Metrics.margin),
            favoriteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            favoriteButton.widthAnchor.constraint(equalToConstant: Metrics.normal),
            favoriteButton.heightAnchor.constraint(equalToConstant: Metrics.normal)
        )
    }
}
