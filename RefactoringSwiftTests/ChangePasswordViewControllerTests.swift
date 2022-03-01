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
        
        let title = viewController.submitButton.currentTitle
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
            executeRunLoop()
        }

    func test_cancelButton_removesFocusFromNewPasswordField() {
        let viewController = setUpViewController()
        putFocusOn(textField: viewController.newPasswordTextField, viewController)
        XCTAssertTrue(viewController.newPasswordTextField.isFirstResponder, "precondition")
        
        tap(viewController.cancelBarButton)
        
        XCTAssertFalse(viewController.newPasswordTextField.isFirstResponder)
        executeRunLoop()
    }
    
    func test_cancelButton_removesFocusFromConfirmPasswordField() {
        let viewController = setUpViewController()
        putFocusOn(textField: viewController.confirmPasswordTextField, viewController)
        XCTAssertTrue(viewController.confirmPasswordTextField.isFirstResponder, "precondition")
        
        tap(viewController.cancelBarButton)
        
        XCTAssertFalse(viewController.confirmPasswordTextField.isFirstResponder)
        executeRunLoop()
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
        executeRunLoop()
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

    func test_tappingOkPasswordBlankAlert_shouldPutFocusOnNewPassword() throws {
        let viewController = setUpViewController()
        let alertVerifier = AlertVerifier()
        setupValidPasswordEntries(viewController)
        viewController.newPasswordTextField.text = ""
        
        tap(viewController.submitButton)
        putInViewHeirarchy(viewController)
            
        try alertVerifier.executeAction(forButton: "OK")
        XCTAssertEqual(viewController.newPasswordTextField.isFirstResponder, true)
    }
    
    func test_tappingSubmit_whenNewPasswordTooShort_shouldNotChangePassword() {
        let viewController = setUpViewController()
        let mockPasswordChanger = MockPasswordChanger()
        viewController.passwordChanger = mockPasswordChanger
        viewController.loadViewIfNeeded()
        
        setupPasswordEntriesNewPasswordTooShort(viewController)
        tap(viewController.submitButton)
        
        mockPasswordChanger.verifyChangeNeverCalled()
    }
    
    func test_tappingSubmit_whenNewPasswordTooShort_shouldShowTooShortAlert() {
        let viewController = setUpViewController()
        let alertVerifier = AlertVerifier()
        
        setupPasswordEntriesNewPasswordTooShort(viewController)
        tap(viewController.submitButton)
        
        verifyAlertPresented(viewController, alertVerifier: alertVerifier, message: "The new password should have at least 6 characters.")
    }
    
    func test_tappingOkInTooShortAlert_shouldClearNewAndConfirmationPasswords() throws {
        let viewController = setUpViewController()
        let alertVerifier = AlertVerifier()
        setupPasswordEntriesNewPasswordTooShort(viewController)
        
        tap(viewController.submitButton)
        
        try alertVerifier.executeAction(forButton: "OK")
        
        XCTAssertEqual(viewController.newPasswordTextField.text?.isEmpty, true, "new")
        XCTAssertEqual(viewController.confirmPasswordTextField.text?.isEmpty, true, "confirmation")
    }
    
    func test_tappingOkInTooShortAlert_shouldNotClearOldPassword() throws {
        let viewController = setUpViewController()
        let alertVerifier = AlertVerifier()
        setupPasswordEntriesNewPasswordTooShort(viewController)
        
        tap(viewController.submitButton)
        
        try alertVerifier.executeAction(forButton: "OK")
        
        XCTAssertEqual(viewController.oldPasswordTextField.text?.isEmpty, false)
    }
    
    func test_tappingOkInTooShortAlert_shouldPutFocusInNewPassword() throws {
        let viewController = setUpViewController()
        let alertVerifier = AlertVerifier()
        setupPasswordEntriesNewPasswordTooShort(viewController)
        
        tap(viewController.submitButton)
        putInViewHeirarchy(viewController)
        
        try alertVerifier.executeAction(forButton: "OK")
        
        XCTAssertEqual(viewController.newPasswordTextField.isFirstResponder, true)
    }
    
    func test_tappingSubmit_withConfirmationMismatch_shouldNotChangePassword() {
        let viewController = setUpViewController()
        let passwordChanger = MockPasswordChanger()
        viewController.passwordChanger = passwordChanger
        
        setupPasswordEntriesPasswordConfirmationMismatch(viewController)
        tap(viewController.submitButton)
        
        passwordChanger.verifyChangeNeverCalled()
    }
    
    func test_tappingSubmit_withConfirmationMismatch_shouldShowMismatchAlert() {
        let viewController = setUpViewController()
        let alertVerifier = AlertVerifier()
        viewController.loadViewIfNeeded()
        
        setupPasswordEntriesPasswordConfirmationMismatch(viewController)
        tap(viewController.submitButton)
        
        verifyAlertPresented(viewController, alertVerifier: alertVerifier, message: "The new password and the confirmation password don't match. Please try again")
    }
    
    func test_tappingOkInMismatchAlert_shouldClearNewAndConfirmationPasswords() throws {
        let viewController = setUpViewController()
        let alertVerifier = AlertVerifier()
        setupPasswordEntriesPasswordConfirmationMismatch(viewController)
        
        tap(viewController.submitButton)
        
        try alertVerifier.executeAction(forButton: "OK")
        
        XCTAssertEqual(viewController.newPasswordTextField.text?.isEmpty, true, "new")
        XCTAssertEqual(viewController.confirmPasswordTextField.text?.isEmpty, true, "confirmation")
    }
    
    func test_tappingOkInMismatchAlert_shouldNotClearOldPassword() throws {
        let viewController = setUpViewController()
        let alertVerifier = AlertVerifier()
        setupPasswordEntriesPasswordConfirmationMismatch(viewController)
        
        tap(viewController.submitButton)
        
        try alertVerifier.executeAction(forButton: "OK")
        
        XCTAssertEqual(viewController.oldPasswordTextField.text?.isEmpty, false)
    }
    
    func test_tappingOkInMismatchAlert_shouldPutFocusInNewPassword() throws {
        let viewController = setUpViewController()
        let alertVerifier = AlertVerifier()
        setupPasswordEntriesPasswordConfirmationMismatch(viewController)
        
        tap(viewController.submitButton)
        putInViewHeirarchy(viewController)
        
        try alertVerifier.executeAction(forButton: "OK")
        
        XCTAssertEqual(viewController.newPasswordTextField.isFirstResponder, true)
    }
    
    func test_tappingSubmit_withValidFieldsFocusedOnOldPassword_resignsFocus() {
        let viewController = setUpViewController()
        setupValidPasswordEntries(viewController)
        putFocusOn(textField: viewController.oldPasswordTextField, viewController)
        XCTAssertEqual(viewController.oldPasswordTextField.isFirstResponder, true, "precondition")
        
        tap(viewController.submitButton)
        
        XCTAssertEqual(viewController.oldPasswordTextField.isFirstResponder, false)
        executeRunLoop()
    }
    
    func test_tappingSubmit_withValidFieldsFocusedOnNewPassword_resignsFocus() {
        let viewController = setUpViewController()
        setupValidPasswordEntries(viewController)
        putFocusOn(textField: viewController.newPasswordTextField, viewController)
        XCTAssertEqual(viewController.newPasswordTextField.isFirstResponder, true, "precondition")
        
        tap(viewController.submitButton)
        
        XCTAssertEqual(viewController.newPasswordTextField.isFirstResponder, false)
        executeRunLoop()
    }
    
    func test_tappingSubmit_withValidFieldsFocusedOnConfirmPassword_resignsFocus() {
        let viewController = setUpViewController()
        setupValidPasswordEntries(viewController)
        putFocusOn(textField: viewController.confirmPasswordTextField, viewController)
        XCTAssertEqual(viewController.confirmPasswordTextField.isFirstResponder, true, "precondition")
        
        tap(viewController.submitButton)
        
        XCTAssertEqual(viewController.confirmPasswordTextField.isFirstResponder, false)
        executeRunLoop()
    }
    
    func test_tappingSubmit_withValidFields_shouldDisableCancelBarButton() {
        let viewController = setUpViewController()
        setupValidPasswordEntries(viewController)
        
        XCTAssertEqual(viewController.cancelBarButton.isEnabled, true, "precondition")
        
        tap(viewController.submitButton)
        
        XCTAssertEqual(viewController.cancelBarButton.isEnabled, false)
    }
    
    func test_tappingSubmit_withValidFields_shouldShowBlurredView() {
        let viewController = setUpViewController()
        setupValidPasswordEntries(viewController)
        XCTAssertNil(viewController.blurView.superview, "precondition")
        
        tap(viewController.submitButton)
        
        XCTAssertNotNil(viewController.blurView.superview)
    }
    
    func test_tappingSubmit_withValidFields_shouldShowActivityIndicator() {
        let viewController = setUpViewController()
        setupValidPasswordEntries(viewController)
        XCTAssertNil(viewController.activityIndicator.superview, "precondition")
        
        tap(viewController.submitButton)
        
        XCTAssertNotNil(viewController.activityIndicator.superview)
    }
    
    func test_tappingSubmit_withValidFields_shouldStartActivityAnimation() {
        let viewController = setUpViewController()
        setupValidPasswordEntries(viewController)
        XCTAssertEqual(viewController.activityIndicator.isAnimating, false, "precondition")
        
        tap(viewController.submitButton)
        
        XCTAssertEqual(viewController.activityIndicator.isAnimating, true)
    }
    
    func test_tappingSubmit_withValidFields_shouldClearBackgroundColorForBlur() {
        let viewController = setUpViewController()
        setupValidPasswordEntries(viewController)
        XCTAssertNotEqual(viewController.view.backgroundColor, .clear, "precondition")
        
        tap(viewController.submitButton)
        
        XCTAssertEqual(viewController.view.backgroundColor, .clear)
    }
    
    func test_tappingSubmit_withValidFields_shouldRequestChangePassword() {
        let viewController = setUpViewController()
        let passwordChanger = setupMockPasswordChanger(viewController)
        
        viewController.oldPasswordTextField.text = "Not-Empty"
        viewController.securityToken = "SecurityToken"
        viewController.newPasswordTextField.text = "123456"
        viewController.confirmPasswordTextField.text = viewController.newPasswordTextField.text
        
        tap(viewController.submitButton)
        
        passwordChanger.verifyChange(securityToken: "SecurityToken", oldPassword: "Not-Empty", newPassword: "123456")
    }
    
    func test_changePasswordSuccess_shouldStopActivityIndicatorAnimation() {
        let viewController = setUpViewController()
        let passwordChanger = setupMockPasswordChanger(viewController)
        
        setupValidPasswordEntries(viewController)
        tap(viewController.submitButton)
        
        XCTAssertEqual(viewController.activityIndicator.isAnimating, true, "precondition")
        
        passwordChanger.changeCallSuccess()
        
        XCTAssertEqual(viewController.activityIndicator.isAnimating, false)
    }
    
    func test_changePasswordSuccess_shouldHideActivityIndicator() {
        let viewController = setUpViewController()
        let passwordChanger = setupMockPasswordChanger(viewController)
        
        setupValidPasswordEntries(viewController)
        tap(viewController.submitButton)
        
        XCTAssertNotNil(viewController.activityIndicator.superview, "precondition")
        
        passwordChanger.changeCallSuccess()
        
        XCTAssertNil(viewController.activityIndicator.superview)
    }
    
    
    
    func test_changePasswordFailure_shouldStopActivityIndicatorAnimation() {
        let viewController = setUpViewController()
        let passwordChanger = setupMockPasswordChanger(viewController)
        
        setupValidPasswordEntries(viewController)
        tap(viewController.submitButton)
        
        XCTAssertEqual(viewController.activityIndicator.isAnimating, true, "precondition")
        
        passwordChanger.changeCallFailure(message: "Oh noes!")
        
        XCTAssertEqual(viewController.activityIndicator.isAnimating, false)
    }
    
    func test_changePasswordFailure_shouldHideActivityIndicator() {
        let viewController = setUpViewController()
        let passwordChanger = setupMockPasswordChanger(viewController)

        setupValidPasswordEntries(viewController)
        tap(viewController.submitButton)

        XCTAssertNotNil(viewController.activityIndicator.superview, "precondition")

        passwordChanger.changeCallFailure(message: "Oh Noes!")

        XCTAssertNil(viewController.activityIndicator.superview)
    }
    
    func test_changePasswordSuccess_shouldShowSuccessAlert() {
        let viewController = setUpViewController()
        let passwordChanger = setupMockPasswordChanger(viewController)
        let alertVerifier = AlertVerifier()
        
        setupValidPasswordEntries(viewController)
        tap(viewController.submitButton)
        
        passwordChanger.changeCallSuccess()
        
        verifyAlertPresented(viewController, alertVerifier: alertVerifier, message: "Your password has been successfully changed")
    }
    
    func test_tappingOkInSuccessModal_shouldDismissModal() throws {
        let viewController = setUpViewController()
        let passwordChanger = setupMockPasswordChanger(viewController)
        let alertVerifier = AlertVerifier()
        
        setupValidPasswordEntries(viewController)
        tap(viewController.submitButton)
        passwordChanger.changeCallSuccess()
        
        let dismissalVerifier = DismissalVerifier()
        try alertVerifier.executeAction(forButton: "OK")
        
        dismissalVerifier.verify(animated: true, dismissedViewController: viewController)
    }
    
    func test_changePasswordFailure_shouldShowFailureAlertWithGivenMessage() {
        let viewController = setUpViewController()
        let passwordChanger = setupMockPasswordChanger(viewController)
        let alertVerifier = AlertVerifier()

        showPasswordChangeFailureAlert(viewController, passwordChanger)
        
        verifyAlertPresented(viewController, alertVerifier: alertVerifier, message: "Useful Message")
    }
    
    func test_tappingOkInFailureAlert_shouldClearAllFieldsToStartOver() throws {
        let viewController = setUpViewController()
        let passwordChanger = setupMockPasswordChanger(viewController)
        let alertVerifier = AlertVerifier()
        showPasswordChangeFailureAlert(viewController, passwordChanger)
        
        try alertVerifier.executeAction(forButton: "OK")
        
        XCTAssertEqual(viewController.oldPasswordTextField.text?.isEmpty, true, "oldPassword")
        XCTAssertEqual(viewController.newPasswordTextField.text?.isEmpty, true, "newPassword")
        XCTAssertEqual(viewController.confirmPasswordTextField.text?.isEmpty, true, "confirmPassword")
    }
    
    func test_tappingOkInFailureAlert_shouldPutFocusOnOldPassword() throws {
        let viewController = setUpViewController()
        let passwordChanger = setupMockPasswordChanger(viewController)
        let alertVerifier = AlertVerifier()
        showPasswordChangeFailureAlert(viewController, passwordChanger)
        putInViewHeirarchy(viewController)
        
        try alertVerifier.executeAction(forButton: "OK")
        
        XCTAssertEqual(viewController.oldPasswordTextField.isFirstResponder, true)
        executeRunLoop()
    }
    
    func test_tappingOkInFailureAlert_shouldSetBackgroundBackToWhite() throws {
        let viewController = setUpViewController()
        let passwordChanger = setupMockPasswordChanger(viewController)
        let alertVerifier = AlertVerifier()
        showPasswordChangeFailureAlert(viewController, passwordChanger)
        XCTAssertNotEqual(viewController.view.backgroundColor, .white, "precondition")
        
        try alertVerifier.executeAction(forButton: "OK")
        
        XCTAssertEqual(viewController.view.backgroundColor, .white)
    }
    
    func test_tappingOkInFailureAlert_shouldHideBlur() throws {
        let viewController = setUpViewController()
        let passwordChanger = setupMockPasswordChanger(viewController)
        let alertVerifier = AlertVerifier()
        showPasswordChangeFailureAlert(viewController, passwordChanger)
        
        XCTAssertNotNil(viewController.blurView.superview, "precondition")
        
        try alertVerifier.executeAction(forButton: "OK")
        
        XCTAssertNil(viewController.blurView.superview)
    }
    
    func test_tappingOkInFailureAlert_shouldEnableCancelBarButton() throws {
        let viewController = setUpViewController()
        let passwordChanger = setupMockPasswordChanger(viewController)
        let alertVerifier = AlertVerifier()
        showPasswordChangeFailureAlert(viewController, passwordChanger)
        
        XCTAssertEqual(viewController.cancelBarButton.isEnabled, false, "precondition")
        
        try alertVerifier.executeAction(forButton: "OK")
        
        XCTAssertEqual(viewController.cancelBarButton.isEnabled, true)
    }
    
    func test_tappingOkInFailureAlert_shouldNotDismissModal() throws {
        let viewController = setUpViewController()
        let passwordChanger = setupMockPasswordChanger(viewController)
        let alertVerifier = AlertVerifier()
        showPasswordChangeFailureAlert(viewController, passwordChanger)
        let dismissalVerifier = DismissalVerifier()
        
        try alertVerifier.executeAction(forButton: "OK")
        
        XCTAssertEqual(dismissalVerifier.dismissedCount, 0)
    }
    
    func test_textFieldDelegates_shouldBeConnected() {
        let viewController = setUpViewController()
        XCTAssertNotNil(viewController.oldPasswordTextField.delegate, "oldPassword")
        XCTAssertNotNil(viewController.newPasswordTextField.delegate, "newPassword")
        XCTAssertNotNil(viewController.confirmPasswordTextField.delegate, "confirmPassword")
    }
    
    func test_hittingReturnFromOldPassword_shouldPutFocusOnNewPassword() {
        let viewController = setUpViewController()
        putInViewHeirarchy(viewController)
        
        shouldReturn(in: viewController.oldPasswordTextField)
        
        XCTAssertEqual(viewController.newPasswordTextField.isFirstResponder, true)
        executeRunLoop()
    }
    
    func test_hittingReturnFromNewPassword_shouldPutFocusOnConfirmPassword() {
        let viewController = setUpViewController()
        putInViewHeirarchy(viewController)
        
        shouldReturn(in: viewController.newPasswordTextField)
        
        XCTAssertEqual(viewController.confirmPasswordTextField.isFirstResponder, true)
        executeRunLoop()
    }
    
    func test_hittingReturnFromConfirmPassword_shouldFireOffChangePasswordRequest() {
        let viewController = setUpViewController()
        let passwordChanger = setupMockPasswordChanger(viewController)
        viewController.securityToken = "securityToken"
        viewController.oldPasswordTextField.text = "notEmpty"
        viewController.newPasswordTextField.text = "123456"
        viewController.confirmPasswordTextField.text = viewController.newPasswordTextField.text
                
        shouldReturn(in: viewController.confirmPasswordTextField)
        
        passwordChanger.verifyChange(securityToken: "securityToken", oldPassword: "notEmpty", newPassword: "123456")
    }
    
    func test_hittingReturnFromOldPassword_shouldNotRequestPasswordChange() {
        let viewController = setUpViewController()
        let passwordChanger = setupMockPasswordChanger(viewController)
        setupValidPasswordEntries(viewController)
        
        shouldReturn(in: viewController.oldPasswordTextField)
        
        passwordChanger.verifyChangeNeverCalled()
    }
    
    func test_hittingReturnFromNewPassword_shouldNotRequestPasswordChange() {
        let viewController = setUpViewController()
        let passwordChanger = setupMockPasswordChanger(viewController)
        setupValidPasswordEntries(viewController)
        
        shouldReturn(in: viewController.newPasswordTextField)
        
        passwordChanger.verifyChangeNeverCalled()
    }
    
    private func showPasswordChangeFailureAlert(_ viewController: ChangePasswordViewController, _ passwordChanger: MockPasswordChanger) {
        setupValidPasswordEntries(viewController)
        tap(viewController.submitButton)
        passwordChanger.changeCallFailure(message: "Useful Message")
    }
    
    private func putFocusOn(textField: UITextField, _ viewController: UIViewController) {
        putInViewHeirarchy(viewController)
        textField.becomeFirstResponder()
    }
    
    private func setUpViewController() -> ChangePasswordViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController: ChangePasswordViewController = storyboard.instantiateViewController(identifier: String(describing: ChangePasswordViewController.self))
        viewController.viewModel = ChangePasswordViewModel(okButtonLabel: "OK",
                                                           enterNewPasswordMessage: "Please enter a new password.",
                                                           newPasswordTooShortMessage: "The new password should have at least 6 characters.",
                                                           confirmationPasswordDoesNotMatchMessage: "The new password and the confirmation password " +
                                                           "don't match. Please try again",
                                                           successMessage: "Your password has been successfully changed",
                                                           title: "Change Password",
                                                           oldPasswordPlaceholder: "Current Password",
                                                           newPasswordPlaceholder: "New Password",
                                                           confirmPasswordPlaceholder: "Confirm New Password",
                                                           submitButtonLabel: "Submit")
        viewController.loadViewIfNeeded()
        
        return viewController
    }
    
    private func setupValidPasswordEntries(_ viewController: ChangePasswordViewController) {
        viewController.oldPasswordTextField.text = "NON-EMPTY"
        viewController.newPasswordTextField.text = "123456"
        viewController.confirmPasswordTextField.text = viewController.newPasswordTextField.text
    }
    
    private func setupPasswordEntriesNewPasswordTooShort(_ viewController: ChangePasswordViewController) {
        viewController.oldPasswordTextField.text = "NON-EMPTY"
        viewController.newPasswordTextField.text = "12345"
        viewController.confirmPasswordTextField.text = viewController.newPasswordTextField.text
    }
    
    private func setupPasswordEntriesPasswordConfirmationMismatch(_ viewController: ChangePasswordViewController) {
        viewController.oldPasswordTextField.text = "NON-EMPTY"
        viewController.newPasswordTextField.text = "123456"
        viewController.confirmPasswordTextField.text = "Not-123456"
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
    
    private func setupMockPasswordChanger(_ viewController: ChangePasswordViewController) -> MockPasswordChanger {
        let passwordChanger = MockPasswordChanger()
        viewController.passwordChanger = passwordChanger
        viewController.loadViewIfNeeded()
        return passwordChanger
    }
}
