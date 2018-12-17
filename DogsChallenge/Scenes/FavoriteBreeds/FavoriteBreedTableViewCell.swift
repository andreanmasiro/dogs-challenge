import UIKit
import Kingfisher

final class FavoriteBreedTableViewCell: TableViewCell {
    typealias `Self` = FavoriteBreedTableViewCell

    override class var preferredHeight: CGFloat {
        return Metrics.TableRow.big
    }
    private static let imagesCount = 5
    private static let imagesSize = (Metrics.Device.width - ((imagesCount.cgFloat + 2) * Metrics.spacing))/imagesCount.cgFloat

    let titleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let imageViews = (0..<Self.imagesCount).map { _ -> UIImageView in
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.setCornerRadius(Self.imagesSize/2)
        return view
    }

    lazy var imageStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: imageViews)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.spacing = Metrics.spacing
        view.axis = .horizontal
        view.distribution = .equalSpacing
        view.alignment = .center
        return view
    }()

    override func initialize() {
        super.initialize()
        contentView.addSubview(titleLabel)
        contentView.addSubview(imageStack)
    }

    override func installConstraints() {
        super.installConstraints()

        activate(
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Metrics.margin),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Metrics.smallMargin),
            imageStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Metrics.spacing),
            imageStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Metrics.spacing),
            imageStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Metrics.spacing),
            imageStack.heightAnchor.constraint(equalToConstant: Self.imagesSize)
        )

        imageViews.forEach {
            activate(
                $0.widthAnchor.constraint(equalToConstant: Self.imagesSize),
                $0.heightAnchor.constraint(equalTo: $0.widthAnchor)
            )
        }
    }

    func bind(_ viewModel: FavoriteBreedViewModel) {
        titleLabel.text = viewModel.name
        zip(imageViews, viewModel.imageLinks).forEach {
            $0.0.kf.setImage(with: $0.1)
        }
    }
}
