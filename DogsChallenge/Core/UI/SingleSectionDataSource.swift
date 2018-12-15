import UIKit

final class SingleSectionDataSource<Model, Cell: UITableViewCell>: NSObject, UITableViewDataSource, UITableViewDelegate {
    typealias CellConfigurator = (Cell, Model) -> Void

    private let tableView: UITableView
    private let cellConfigurator: CellConfigurator
    var models: [Model] = [] {
        didSet { reload() }
    }

    init(tableView: UITableView, cellConfigurator: @escaping CellConfigurator) {
        self.tableView = tableView
        self.cellConfigurator = cellConfigurator

        super.init()

        registerCell(in: tableView)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(from: tableView, for: indexPath)
        cellConfigurator(cell, models[indexPath.row])
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
}
