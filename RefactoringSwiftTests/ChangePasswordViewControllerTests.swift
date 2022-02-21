@testable import RefactoringSwift
import XCTest
import ViewControllerPresentationSpy

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
    
    func test_tappingCancel_shouldDismissModal() {
        let viewController = setUpViewController()
        let dismissalVerifier = DismissalVerifier()
        
        tap(viewController.cancelBarButton)
        
        dismissalVerifier.verify(animated: true, dismissedViewController: viewController)
    }
    
    func test_tappingSubmit_withOldPasswordEmpty_shouldNotChangePassword() {
        let viewController = setUpViewController()
        let mockPasswordChanger = MockPasswordChanger()
        viewController.passwordChanger = mockPasswordChanger
        viewController.loadViewIfNeeded()
        
        setupValidPasswordEntries(viewController)
        viewController.oldPasswordTextField.text = ""
        tap(viewController.submitButton)
        
        mockPasswordChanger.verifyChangeNeverCalled()
    }
    
    func test_tappingSubmit_withOldPasswordEmpty_shouldPutFocusOnOldPassword() {
        let viewController = setUpViewController()
        
        setupValidPasswordEntries(viewController)
        viewController.oldPasswordTextField.text = ""
        putInViewHeirarchy(viewController)
        tap(viewController.submitButton)

        XCTAssertTrue(viewController.oldPasswordTextField.isFirstResponder)
    }
    
    func test_tappingSubmit_withNewPasswordEmpty_shouldNotChangePassword() {
        let viewController = setUpViewController()
        let mockPasswordChanger = MockPasswordChanger()
        viewController.passwordChanger = mockPasswordChanger
        viewController.loadViewIfNeeded()
        
        setupValidPasswordEntries(viewController)
        viewController.oldPasswordTextField.text = ""
        tap(viewController.submitButton)
        
        mockPasswordChanger.verifyChangeNeverCalled()
    }
    
    func test_tappingSubmit_withNewPasswordEmpty_shouldShowPasswordBlankAlert() {
        let viewController = setUpViewController()
        let alertVerifier = AlertVerifier()
        setupValidPasswordEntries(viewController)
        viewController.newPasswordTextField.text = ""
        
        tap(viewController.submitButton)
        
        verifyAlertPresented(viewController, alertVerifier: alertVerifier, message: "Please enter a new password.")
    }

    private func putFocusOn(textField: UITextField, _ viewController: UIViewController) {
        putInViewHeirarchy(viewController)
        textField.becomeFirstResponder()
    }
    
    private func setUpViewController() -> ChangePasswordViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController: ChangePasswordViewController = storyboard.instantiateViewController(identifier: String(describing: ChangePasswordViewController.self))
        viewController.loadViewIfNeeded()
        
        return viewController
    }
    
    private func setupValidPasswordEntries(_ viewController: ChangePasswordViewController) {
        viewController.oldPasswordTextField.text = "NON-EMPTY"
        viewController.newPasswordTextField.text = "123456"
        viewController.confirmPasswordTextField.text = viewController.newPasswordTextField.text
    }
    
    private func verifyAlertPresented(_ viewController: ChangePasswordViewController,
                                      alertVerifier: AlertVerifier,
                                      message: String, file: StaticString = #file, line: UInt = #line ) {
        alertVerifier.verify(title: nil,
                             message: message,
                             animated: true,
                             actions: [.default("OK"),],
                             presentingViewController: viewController,
                             file: file, line: line)
        XCTAssertEqual(alertVerifier.preferredAction?.title, "OK", "preferredAction", file: file, line: line)
    }
}
