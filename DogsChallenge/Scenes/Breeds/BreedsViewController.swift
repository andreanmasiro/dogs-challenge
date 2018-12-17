import UIKit
import RxSwift

final class BreedsViewController: ViewController {
    typealias Builder = (BreedsGateway, FavoriteBreedsInteractor) -> BreedsViewController

    private let gateway: BreedsGateway
    private let favoriteBreedsInteractor: FavoriteBreedsInteractor

    private let tableView = UITableView()
    lazy var dataSource = SingleSectionDataSource(tableView: tableView,
                                                  cellConfigurator: breedCellConfigurator,
                                                  didSelect: didSelect)
    private var didSelectSubject = PublishSubject<Breed>()
    var didSelect: Observable<Breed> {
        return didSelectSubject.asObservable()
    }

    init(gateway: BreedsGateway = HttpGetGateway<Breeds>(endpoint: .breeds),
         favoriteBreedsInteractor: FavoriteBreedsInteractor) {
        self.gateway = gateway
        self.favoriteBreedsInteractor = favoriteBreedsInteractor
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
            .subscribe(onSuccess: dataSource.modelsSetter)
            .disposed(by: disposeBag)
    }

    private func breedCellConfigurator(cell: BreedTableViewCell, breed: Breed) {
        let curriedViewModelBuilder = {
            return BreedViewModel(breed: breed, isFavorite: $0)
        }
        cell.accessoryType = .disclosureIndicator
        favoriteBreedsInteractor.isFavorite(breed)
            .map(curriedViewModelBuilder)
            .subscribe(onSuccess: cell.bind)
            .disposed(by: cell.disposeBag)

        cell.favoriteButton.rx.tap
            .flatMap { [favoriteBreedsInteractor] in favoriteBreedsInteractor.toggle(breed) }
            .map(curriedViewModelBuilder)
            .subscribe(onNext: cell.bind)
            .disposed(by: cell.disposeBag)
    }

    private func didSelect(breed: Breed) {
        didSelectSubject.onNext(breed)
    }
}
