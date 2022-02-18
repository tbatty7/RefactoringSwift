@testable import RefactoringSwift
import XCTest

final class ChangePasswordViewControllerTests: XCTestCase {

    func test_zero() throws {
        let viewController = setUpViewController()
        
        XCTAssertNotNil(viewController.cancelBarButton, "cancelBarButton")
        XCTAssertNotNil(viewController.confirmPasswordTextField, "confirmPasswordTextField")
        XCTAssertNotNil(viewController.newPasswordTextField, "newPasswordTextField")
        XCTAssertNotNil(viewController.oldPasswordTextField, "oldPasswordTextField")
        XCTAssertNotNil(viewController.submitButton, "submitButton")
        XCTAssertNotNil(viewController.navigationBar, "navigationBar")
    }
    
    func test_one() {
        
    }
    
    private func setUpViewController() -> ChangePasswordViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController: ChangePasswordViewController = storyboard.instantiateViewController(identifier: String(describing: ChangePasswordViewController.self))
        viewController.loadViewIfNeeded()
        
        return viewController
    }
}
