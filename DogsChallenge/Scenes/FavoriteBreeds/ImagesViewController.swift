import UIKit
import RxSwift
import Kingfisher

final class ImagesViewController: ViewController {
    typealias Builder = (String, ImagesGateway) -> ImagesViewController

    private let disposeBag = DisposeBag()
    private let tableView = UITableView()
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
            .trackLoading(binder: rx.loading)
            .subscribe(onSuccess: dataSource.modelsSetter)
            .disposed(by: disposeBag)
    }

    private func imageCellConfigurator(cell: UITableViewCell, link: Link) {
        cell.imageView?.kf.setImage(with: link.href)
    }
}
