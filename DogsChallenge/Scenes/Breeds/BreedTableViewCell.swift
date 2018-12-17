import UIKit
import RxSwift

final class BreedTableViewCell: TableViewCell {
    lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.tintColor = .accessoryGray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func initialize() {
        super.initialize()
        contentView.addSubview(favoriteButton)
    }

    override func installConstraints() {
        super.installConstraints()
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

    func bind(_ viewModel: BreedViewModel) {
        textLabel?.text = viewModel.name
        favoriteButton.setImage(viewModel.favoriteIcon, for: .normal)
        favoriteButton.tintColor = viewModel.favoriteIconColor
    }
}
