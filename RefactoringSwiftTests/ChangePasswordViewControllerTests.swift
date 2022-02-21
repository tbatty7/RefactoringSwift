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
    
    func test_navigationBar_shouldHaveTitle() {
        let viewController = setUpViewController()
        XCTAssertEqual(viewController.navigationBar.topItem?.title, "Change Password")
    }
    
    func test_cancelBarButton_isSystemItemCancel() {
        let viewController = setUpViewController()
        let barButtonSystemItem = systemItem(for: viewController.cancelBarButton)
        XCTAssertEqual(barButtonSystemItem, .cancel)
    }
    
    func test_oldPasswordTextField_shouldHavePlaceholder() {
        let viewController = setUpViewController()
        
        let placeholder = viewController.oldPasswordTextField.placeholder
        XCTAssertEqual(placeholder, "Current Password")
    }
    
    func test_newPasswordTextField_shouldHavePlaceholder() {
        let viewController = setUpViewController()
        
        let placeholder = viewController.newPasswordTextField.placeholder
        XCTAssertEqual(placeholder, "New Password")
    }
    
    func test_confirmPasswordTextField_shouldHavePlaceholder() {
        let viewController = setUpViewController()
        
        let placeholder = viewController.confirmPasswordTextField.placeholder
        XCTAssertEqual(placeholder, "Confirm New Password")
    }
    
    func test_submitButton_hasCorrectTitle() {
        let viewController = setUpViewController()
        
        let title = viewController.submitButton.titleLabel?.text
        XCTAssertEqual(title, "Submit")
    }
    
    func test_oldPasswordTextField_shouldHaveAttributes() {
        let viewController = setUpViewController()
        
        let oldPasswordField = viewController.oldPasswordTextField
        XCTAssertEqual(oldPasswordField?.textContentType, .password, "textContentType")
        XCTAssertEqual(oldPasswordField?.enablesReturnKeyAutomatically, true, "autoEnableReturnKey")
        XCTAssertEqual(oldPasswordField?.isSecureTextEntry, true, "isSecureTextEntry")
    }

    func test_newPasswordTextField_shouldHaveAttributes() {
        let viewController = setUpViewController()
        
        let textField = viewController.newPasswordTextField
        XCTAssertEqual(textField?.textContentType, .newPassword, "textContentType")
        XCTAssertEqual(textField?.enablesReturnKeyAutomatically, true, "autoEnableReturnKey")
        XCTAssertEqual(textField?.isSecureTextEntry, true, "isSecureTextEntry")
    }
    
    func test_confirmPasswordTextField_shouldHaveAttributes() {
        let viewController = setUpViewController()
        
        let textField = viewController.confirmPasswordTextField
        XCTAssertEqual(textField?.textContentType, .newPassword, "textContentType")
        XCTAssertEqual(textField?.enablesReturnKeyAutomatically, true, "autoEnableReturnKey")
        XCTAssertEqual(textField?.isSecureTextEntry, true, "isSecureTextEntry")
    }
    
    func test_cancelButton_removesFocusFromOldPasswordField() {
            let viewController = setUpViewController()
            putFocusOn(textField: viewController.oldPasswordTextField, viewController)
            XCTAssertTrue(viewController.oldPasswordTextField.isFirstResponder, "precondition")

            tap(viewController.cancelBarButton)

            XCTAssertFalse(viewController.oldPasswordTextField.isFirstResponder)

        }

        func test_cancelButton_removesFocusFromNewPasswordField() {
            let viewController = setUpViewController()
            putFocusOn(textField: viewController.newPasswordTextField, viewController)
            XCTAssertTrue(viewController.newPasswordTextField.isFirstResponder, "precondition")

            tap(viewController.cancelBarButton)

            XCTAssertFalse(viewController.newPasswordTextField.isFirstResponder)

        }

        func test_cancelButton_removesFocusFromConfirmPasswordField() {
            let viewController = setUpViewController()
            putFocusOn(textField: viewController.confirmPasswordTextField, viewController)
            XCTAssertTrue(viewController.confirmPasswordTextField.isFirstResponder, "precondition")

            tap(viewController.cancelBarButton)

            XCTAssertFalse(viewController.confirmPasswordTextField.isFirstResponder)

        }

        func putFocusOn(textField: UITextField, _ viewController: UIViewController) {
            putInViewHeirarchy(viewController)
            textField.becomeFirstResponder()
        }

        func setUpViewController() -> ChangePasswordViewController {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController: ChangePasswordViewController = storyboard.instantiateViewController(identifier: String(describing: ChangePasswordViewController.self))
            viewController.loadViewIfNeeded()

            return viewController
        }
}
