//
//  ChangePasswordViewController.swift
//  RefactoringSwift
//
//  Created by Timothy D Batty on 2/18/22.
//

import UIKit

class ChangePasswordViewController: UIViewController {

    @IBOutlet private(set) var cancelBarButton: UIBarButtonItem!
    @IBOutlet private(set) var oldPasswordTextField: UITextField!
    @IBOutlet private(set) var newPasswordTextField: UITextField!
    @IBOutlet private(set) var confirmPasswordTextField: UITextField!
    @IBOutlet private(set) var submitButton: UIButton!
    @IBOutlet private(set) var navigationBar: UINavigationBar!
    
    let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    let activityIndicator = UIActivityIndicatorView(style: .large)
    lazy var passwordChanger: PasswordChanging = PasswordChanger()
    private lazy var presenter = ChangePasswordPresenter(view: self, viewModel: viewModel)
    var securityToken = ""
    var viewModel: ChangePasswordViewModel! 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submitButton.layer.borderWidth = 1
        submitButton.layer.borderColor = UIColor(red: 55/255, green: 147/255, blue: 251/255, alpha: 1).cgColor
        submitButton.layer.cornerRadius = 8
        blurView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .white
        setLabels()
    }

    
    @IBAction private func cancel() {
        updateInputFocus(.noKeyboard)
        dismissModal()
    }
    
    deinit {
        print(">>>>>>>>>> Deinit ChangePasswordViewController")
    }
    
    @IBAction private func changePassword() {
        updateViewModelToTextFields()
        guard validateInputs() else { return }
        setupWaitingAppearance()
        attemptToChangePassword()
    }

    
    private func attemptToChangePassword() {
        passwordChanger.change(securityToken: securityToken,
                               oldPassword: viewModel.oldPassword,
                               newPassword: viewModel.newPassword,
                               onSuccess: {[weak self] in self?.presenter.handleSuccess()},
                               onFailure: {[weak self] message in self?.handleFailure(message)})
    }
    
    private func setupWaitingAppearance() {
        updateInputFocus(.noKeyboard)
        setCancelButtonEnabled(false)
        showBlurView()
        showActivityIndicator()
    }
    
    
    private func validateInputs() -> Bool {
        if viewModel.isOldPasswordEmpty {
            updateInputFocus(.oldPassword)
            return false
        }

        if viewModel.isNewPasswordEmpty {
            showAlert(message: viewModel.enterNewPasswordMessage,
                      okAction: { [weak self] in
                self?.updateInputFocus(.newPassword)
            })
            return false
        }
        
        if viewModel.isNewPasswordTooShort {
            showAlert(message: viewModel.newPasswordTooShortMessage,
                      okAction: resetNewPasswords())
            
            return false
        }
        
        if viewModel.isConfirmPasswordMismatched {
            showAlert(message: viewModel.confirmationPasswordDoesNotMatchMessage, okAction: resetNewPasswords())
            return false
        }
        return true
    }
    

    private func resetNewPasswords() -> () -> Void {
        return { [weak self] in
            self?.newPasswordTextField.text = ""
            self?.confirmPasswordTextField.text = ""
            self?.updateInputFocus(.newPassword)
        }
    }
    
    private func startOver() {
        oldPasswordTextField.text = ""
        newPasswordTextField.text = ""
        confirmPasswordTextField.text = ""
        updateInputFocus(.oldPassword)
        hideBlurView()
        setCancelButtonEnabled(true)
    }
    
    private func handleFailure(_ message: String) {
        hideActivityIndicator()
        showAlert(message: message, okAction: { [weak self] in
            self?.startOver()
        })
    }
    
    private func setLabels() {
        navigationBar.topItem?.title = viewModel.title
        oldPasswordTextField.placeholder = viewModel.oldPasswordPlaceholder
        newPasswordTextField.placeholder = viewModel.newPasswordPlaceholder
        confirmPasswordTextField.placeholder = viewModel.confirmPasswordPlaceholder
        submitButton.setTitle(viewModel.submitButtonLabel, for: .normal)
    }
    
    private func updateViewModelToTextFields() {
        viewModel.oldPassword = oldPasswordTextField.text ?? ""
        viewModel.newPassword = newPasswordTextField.text ?? ""
        viewModel.confirmPassword = confirmPasswordTextField.text ?? ""
    }
}

extension ChangePasswordViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === oldPasswordTextField {
            updateInputFocus(.newPassword)
        } else if textField === newPasswordTextField {
            updateInputFocus(.confirmPassword)
        } else if textField === confirmPasswordTextField {
            changePassword()
        }
        return true
    }
}

extension ChangePasswordViewController : ChangePasswordViewCommands {
    
    func hideActivityIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
    
    func showActivityIndicator() {
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        activityIndicator.startAnimating()
    }
    
    func dismissModal() {
        self.dismiss(animated: true)
    }
    
    private func showAlert(message: String, okAction: @escaping (UIAlertAction) -> Void) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: viewModel.okButtonLabel, style: .default, handler: okAction)
        alertController.addAction(okButton)
        alertController.preferredAction = okButton
        present(alertController, animated: true)
    }
    
    func showAlert(message: String, okAction: @escaping () -> Void) {
        let wrappedAction: (UIAlertAction) -> Void = { _ in okAction() }
        showAlert(message: message, okAction: { wrappedAction($0) })
    }
    
    func hideBlurView() {
        view.backgroundColor = .white
        blurView.removeFromSuperview()
    }
    
    func showBlurView() {
        view.backgroundColor = .clear
        view.addSubview(blurView)
        NSLayoutConstraint.activate([
            blurView.heightAnchor.constraint(equalTo: view.heightAnchor),
            blurView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }
    
    func setCancelButtonEnabled(_ isEnabled: Bool) {
        cancelBarButton.isEnabled = isEnabled
    }
    
    func updateInputFocus(_ inputFocus: ChangePasswordViewModel.InputFocus) {
        switch inputFocus {
        case .noKeyboard:
            view.endEditing(true)
        case .oldPassword:
            oldPasswordTextField.becomeFirstResponder()
        case .newPassword:
            newPasswordTextField.becomeFirstResponder()
        case .confirmPassword:
            confirmPasswordTextField.becomeFirstResponder()
        }
    }
}
