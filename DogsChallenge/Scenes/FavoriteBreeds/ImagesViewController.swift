import UIKit
import RxSwift
import RxCocoa
import Kingfisher

final class ImagesViewController: ViewController {
    typealias Builder = (String, ImagesGateway) -> ImagesViewController

    private let disposeBag = DisposeBag()
    private let tableView: UITableView = {
        let view = UITableView()
        view.separatorStyle = .none
        view.allowsSelection = false
        return view
    }()
    lazy var dataSource = SingleSectionDataSource(tableView: tableView, cellConfigurator: imageCellConfigurator)

    private let gateway: ImagesGateway
    private let breedName: String

    init(breedName: String, gateway: ImagesGateway) {
        self.gateway = gateway
        self.breedName = breedName
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchBreeds()
        title = breedName
    }

    override func initialize() {
        super.initialize()
        view.addSubview(tableView)
    }

    override func installConstraints() {
        super.installConstraints()
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.frame = view.bounds
    }

    override func onLoading(_ isLoading: Bool) {
        tableView.isHidden = isLoading
    }

    private func fetchBreeds() {
        gateway.get()
            .do(onSuccess: { _ in self.setState(.idle)},
                onSubscribed: { self.setState(.loading) },
                onDispose: { self.setState(.idle) })
            .trackError({ self.setState(.error($0)) }, retryWhen: self.retryObservable)
            .subscribe(onSuccess: { [dataSource] in
                dataSource.modelsSetter($0.links)
            })
            .disposed(by: disposeBag)
    }

    private func imageCellConfigurator(cell: ImageTableViewCell, link: URL) {
        cell.imageImageView.kf.setImage(with: link)
    }
}
