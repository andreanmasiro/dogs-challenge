import Nimble
import RxBlocking
import RxSwift
import XCTest

@testable import DogsChallenge

final class SingleSectionDataSourceTests: XCTestCase {
    private var mockTableView: MockTableView!
    private var dataSource: SingleSectionDataSource<Int, UITableViewCell>!
    override func setUp() {
        mockTableView = MockTableView()
        dataSource = SingleSectionDataSource(tableView: mockTableView) { _, _ in }
    }

    func testWhenInitializedSetsUpTableView() {
        let className = String(describing: UITableViewCell.self)

        expect(self.mockTableView.registeredCellClass.map(String.init(describing:))) == className
        expect(self.mockTableView.registeredCellIdentifier) == className
    }

    func testWhenModelsAreSetItReloadsTableViewData() {
        dataSource.models = []

        expect(self.mockTableView.wasReloadDataCalled) == true
    }

    func testNumberOfRowsInSectionEqualsModelsCount() {
        let modelsCount = 10
        dataSource.models = Array(repeating: 0, count: modelsCount)

        expect(self.dataSource.tableView(self.mockTableView, numberOfRowsInSection: 0)) == modelsCount
    }

    func testCellForRowAtIndexPathConfiguresEachCellWithTheCorrectModel() {
        var configModels = [Int]()
        let tableView = UITableView()
        dataSource = SingleSectionDataSource(tableView: tableView) { _, model in
            configModels.append(model)
        }
        let models = Array(0..<3)
        dataSource.models = models

        let indices = 0..<3
        indices.forEach { i in
            _ = dataSource.tableView(tableView, cellForRowAt: IndexPath(row: i, section: 0))
        }

        expect(configModels) == models
    }
}

private class MockTableView: UITableView {
    var registeredCellClass: AnyClass?
    var registeredCellIdentifier: String?
    override func register(_ cellClass: AnyClass?, forCellReuseIdentifier identifier: String) {
        registeredCellClass = cellClass
        registeredCellIdentifier = identifier
    }

    var wasReloadDataCalled = false
    override func reloadData() {
        wasReloadDataCalled = true
    }
}
