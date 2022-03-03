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
    var securityToken = ""
    private lazy var presenter = ChangePasswordPresenter(view: self, viewModel: viewModel, securityToken: securityToken, passwordChanger: passwordChanger)
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
        guard presenter.validateInputs(passwordInputs: viewModel.passwordInputs) else { return }
        presenter.setupWaitingAppearance()
        presenter.attemptToChangePassword()
    }
    
    private func setLabels() {
        navigationBar.topItem?.title = viewModel.title
        oldPasswordTextField.placeholder = viewModel.oldPasswordPlaceholder
        newPasswordTextField.placeholder = viewModel.newPasswordPlaceholder
        confirmPasswordTextField.placeholder = viewModel.confirmPasswordPlaceholder
        submitButton.setTitle(viewModel.submitButtonLabel, for: .normal)
    }
    
    private func updateViewModelToTextFields() {
        viewModel.passwordInputs.oldPassword = oldPasswordTextField.text ?? ""
        viewModel.passwordInputs.newPassword = newPasswordTextField.text ?? ""
        viewModel.passwordInputs.confirmPassword = confirmPasswordTextField.text ?? ""
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
    
    func updateInputFocus(_ inputFocus: InputFocus) {
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
    
    func clearAllPasswordFields() {
        oldPasswordTextField.text = ""
        newPasswordTextField.text = ""
        confirmPasswordTextField.text = ""
    }
    
    func clearNewPasswordFields() {
        newPasswordTextField.text = ""
        confirmPasswordTextField.text = ""
    }
}
