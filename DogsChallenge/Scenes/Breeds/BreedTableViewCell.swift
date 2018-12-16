import UIKit

final class BreedTableViewCell: UITableViewCell {
    lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: ""), for: .normal)
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
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Metrics.margin),
            favoriteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            favoriteButton.widthAnchor.constraint(equalToConstant: Metrics.normal),
            favoriteButton.heightAnchor.constraint(equalToConstant: Metrics.normal)
        )
    }
}
