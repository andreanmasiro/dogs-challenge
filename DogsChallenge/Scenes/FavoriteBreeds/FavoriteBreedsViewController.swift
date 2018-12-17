import UIKit
import RxSwift
import RxCocoa
import Kingfisher

final class FavoriteBreedsViewController: ViewController {
    typealias Builder = (FavoriteBreedsInteractor, FavoriteBreedsStore, ImagesInteractor) -> FavoriteBreedsViewController

    private let tableView: UITableView = {
        let view = UITableView()
        view.allowsSelection = false
        return view
    }()
    lazy var dataSource = SingleSectionDataSource(tableView: tableView, cellConfigurator: imageCellConfigurator)

    private let favoriteBreedsStore: FavoriteBreedsStore
    private let imagesInteractor: ImagesInteractor

    init(favoriteBreedsInteractor: FavoriteBreedsInteractor,
         favoriteBreedsStore: FavoriteBreedsStore,
         imagesInteractor: ImagesInteractor) {
        self.favoriteBreedsStore = favoriteBreedsStore
        self.imagesInteractor = imagesInteractor
        super.init()
        title = "Favorites"
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindBreeds()
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

    private func bindBreeds() {
        favoriteBreedsStore.getObservable()
            .do(onNext: { [weak self] _ in self?.setState(.idle) })
            .trackError({ self.setState(.error($0)) }, retryWhen: self.retryObservable)
            .subscribe(onNext: { [dataSource] breeds in
                dataSource.modelsSetter(breeds)
            })
            .disposed(by: disposeBag)
    }

    private func imageCellConfigurator(cell: FavoriteBreedTableViewCell, favoriteBreed: FavoriteBreed) {
        let curriedViewModelBuilder = {
            FavoriteBreedViewModel(favoriteBreed: favoriteBreed, links: $0)
        }

        imagesInteractor.images(forBreed: favoriteBreed).asObservable()
            .startWith(Links(links: []))
            .map(curriedViewModelBuilder)
            .subscribe(onNext: cell.bind)
            .disposed(by: cell.disposeBag)
    }
}
