import UIKit
import RxSwift
import RxCocoa

final class SingleSectionDataSource<Model, Cell: UITableViewCell>: NSObject, UITableViewDataSource, UITableViewDelegate {
    typealias CellConfigurator = (Cell, Model) -> Void
    typealias SelectionCallback = (Model) -> Void

    private let tableView: UITableView
    private let cellConfigurator: CellConfigurator?
    private let didSelect: SelectionCallback?
    var models: [Model] = [] {
        didSet { reload() }
    }

    init(tableView: UITableView,
         cellConfigurator: CellConfigurator? = nil,
         didSelect: SelectionCallback? = nil) {
        self.tableView = tableView
        self.cellConfigurator = cellConfigurator
        self.didSelect = didSelect

        super.init()

        tableView.dataSource = self
        tableView.delegate = self
        registerCell(in: tableView)
    }

    // MARK: Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(from: tableView, for: indexPath)
        cellConfigurator?(cell, models[indexPath.row])
        return cell
    }

    func registerCell(in tableView: UITableView) {
        tableView.register(Cell.self)
    }

    func dequeueReusableCell(from tableView: UITableView, for indexPath: IndexPath) -> Cell {
        return tableView.dequeueReusableCell(for: indexPath)
    }

    func reload() {
        tableView.reloadData()
    }

    var modelsSetter: ([Model]) -> Void {
        return { [weak self] in
            self?.models = $0
        }
    }

    // MARK: TableView delegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelect?(models[indexPath.row])
    }
}
