import Nimble
import RxBlocking
import RxSwift
import RxCocoa
import XCTest

@testable import DogsChallenge

final class BreedsViewControllerTests: XCTestCase {
    var gateway: MockBreedsGateway!
    var viewController: BreedsViewController!

    override func setUp() {
        gateway = MockBreedsGateway()
        gateway.getStub = .just([])
        viewController = BreedsViewController(gateway: gateway)
    }

    func testWhenViewIsLoadedItSubscribesToGatewayGet() {
        var subscribed = false
        gateway.getStub = .deferred {
            subscribed = true
            return .just([])
        }

        viewController.beginAppearanceTransition(true, animated: false)

        expect(self.gateway.wasGetCalled).toEventually(beTrue())
        expect(subscribed) == true
    }

    func testWhenLoadingItHidesTableView() {
        gateway.getStub = .never()
        viewController = BreedsViewController(gateway: gateway)
        viewController.setState(.loading)

        expect(self.viewController.view.breadthFirstSearch(viewOfType: UITableView.self)?.isHidden) == true
    }
}
