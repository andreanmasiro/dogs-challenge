import UIKit
import RxSwift

final class BreedsViewController: ViewController {
    private let disposeBag = DisposeBag()
    private let tableView = UITableView()
    lazy var dataSource = SingleSectionDataSource(tableView: tableView, cellConfigurator: breedCellConfigurator)

    private let gateway: BreedsGateway

    init(gateway: BreedsGateway = HttpGetGateway<Breeds>(endpoint: .breeds),
         favoriteBreedsRepository: FavoriteBreedsRepository = UserDefaultsRepository<FavoriteBreeds>()) {
        self.gateway = gateway
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchBreeds()
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

    private func breedCellConfigurator(cell: BreedTableViewCell, breed: Breed) {
        cell.textLabel?.text = breed.name
    }
}
