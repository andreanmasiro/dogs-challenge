import UIKit

class ErrorView: View {
    let titleLabel: UILabel = {
        let view = UILabel()
        view.text = "Error :("
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = view.font.withSize(Metrics.FontSize.title)
        view.textAlignment = .center
        return view
    }()

    let descriptionLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = view.font.withSize(Metrics.FontSize.body)
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()

    let retryButton: UIButton = {
        let view = UIButton()
        view.setTitle("Retry", for: .normal)
        view.setTitleColor(.retryGreen, for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func initialize() {
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(retryButton)
    }

    override func installConstraints() {
        activate(
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -Metrics.large),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Metrics.spacing),
            descriptionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Metrics.margin),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Metrics.margin),
            retryButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: Metrics.spacing),
            retryButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        )
    }

    func bind(error: Error) {
        descriptionLabel.text = error.localizedDescription
    }
}
