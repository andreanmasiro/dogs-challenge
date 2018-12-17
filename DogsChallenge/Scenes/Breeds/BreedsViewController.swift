import UIKit
import RxSwift

final class BreedsViewController: ViewController {
    typealias Builder = (BreedsGateway, FavoriteBreedsStore) -> BreedsViewController

    private let tableView = UITableView()
    private let gateway: BreedsGateway

    lazy var dataSource = SingleSectionDataSource(tableView: tableView,
                                                  cellConfigurator: breedCellConfigurator,
                                                  didSelect: didSelect)

    private var didSelectSubject = PublishSubject<BreedViewModel>()
    var didSelect: Observable<BreedViewModel> {
        return didSelectSubject.asObservable()
    }

    init(gateway: BreedsGateway = HttpGetGateway<Breeds>(endpoint: .breeds),
         favoriteBreedsRepository: FavoriteBreedsStore = UserDefaultsStore<FavoriteBreeds>()) {
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.deselect(animated: animated)
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

    override func setState(_ state: ViewControllerState) {
        super.setState(state)
        switch state {
        case .idle: tableView.isHidden = false
        default: tableView.isHidden = true
        }
    }

    private func fetchBreeds() {
        gateway.get()
            .do(onSuccess: { _ in self.setState(.idle)},
                onSubscribed: { self.setState(.loading) },
                onDispose: { self.setState(.idle) })
            .trackError({ self.setState(.error($0)) }, retryWhen: self.retryObservable)
            .map { $0.map(BreedViewModel.init) }
            .subscribe(onSuccess: dataSource.modelsSetter)
            .disposed(by: disposeBag)
    }

    private func breedCellConfigurator(cell: BreedTableViewCell, breedViewModel: BreedViewModel) {
        cell.textLabel?.text = breedViewModel.name
        cell.accessoryType = .disclosureIndicator
        cell.favoriteButton.setImage(breedViewModel.favoriteIcon, for: .normal)
        cell.favoriteButton.tintColor = breedViewModel.favoriteIconColor
    }

    private func didSelect(breed: BreedViewModel) {
        didSelectSubject.onNext(breed)
    }
}
