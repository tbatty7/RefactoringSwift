@testable import RefactoringSwift
import XCTest

final class ViewControllerTests: XCTestCase {

    func test_zero() throws {

    }
    
    func test_memory() throws {
        let viewController = setUpViewController()
        let cpviewController = setUpCPViewController()
    }
    
    private func setUpCPViewController() -> ChangePasswordViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController: ChangePasswordViewController = storyboard.instantiateViewController(identifier: String(describing: ChangePasswordViewController.self))
        viewController.loadViewIfNeeded()
        
        return viewController
    }
    
    private func setUpViewController() -> ViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController: ViewController = storyboard.instantiateViewController(identifier: String(describing: ViewController.self))
        viewController.loadViewIfNeeded()
        
        return viewController
    }
}
