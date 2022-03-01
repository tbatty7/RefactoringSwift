@testable import RefactoringSwift
import XCTest

final class ViewControllerTests: XCTestCase {
    
    func test_memory() throws {
        let viewController = setUpViewController()
        let cpviewController = setUpCPViewController()
    }
    
    private func setUpCPViewController() -> ChangePasswordViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController: ChangePasswordViewController = storyboard.instantiateViewController(identifier: String(describing: ChangePasswordViewController.self))
        viewController.viewModel = ChangePasswordViewModel(okButtonLabel: "OK",
                                                           enterNewPasswordMessage: "Please enter a new password.",
                                                           newPasswordTooShortMessage: "The new password should have at least 6 characters.",
                                                           confirmationPasswordDoesNotMatchMessage: "The new password and the confirmation password " +
                                                           "don't match. Please try again",
                                                           successMessage: "Your password has been successfully changed",
                                                           title: "Change Password",
                                                           oldPasswordPlaceholder: "Current Passwordzz",
                                                           newPasswordPlaceholder: "New Password",
                                                           confirmPasswordPlaceholder: "Confirm New Password",
                                                           submitButtonLabel: "Submit")
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
