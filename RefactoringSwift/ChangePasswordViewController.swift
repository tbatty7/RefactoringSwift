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
    
    lazy var passwordChanger: PasswordChanging = PasswordChanger()
    var securityToken = ""
    var viewModel: ChangePasswordViewModel! {
        didSet {
            guard isViewLoaded else { return }
            
            if oldValue.isCancelButtonEnabled != viewModel.isCancelButtonEnabled {
                cancelBarButton.isEnabled = viewModel.isCancelButtonEnabled
            }
            if oldValue.inputFocus != viewModel.inputFocus {
                updateInputFocus()
            }
            if oldValue.isBlurViewShowing != viewModel.isBlurViewShowing {
                updateBlurView()
            }
            if oldValue.isActivityIndicatorShowing != viewModel.isActivityIndicatorShowing {
                updateActivityIndicator()
            }
        }
    }
    let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    let activityIndicator = UIActivityIndicatorView(style: .large)
    
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
        viewModel.inputFocus = .noKeyboard
        dismiss(animated: true)
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
                               oldPassword: oldPasswordTextField.text ?? "",
                               newPassword: newPasswordTextField.text ?? "",
                               onSuccess: {[weak self] in self?.handleSuccess()},
                               onFailure: {[weak self] message in self?.handleFailure(message)})
    }
    
    private func setupWaitingAppearance() {
        viewModel.inputFocus = .noKeyboard
        viewModel.isCancelButtonEnabled = false
        viewModel.isBlurViewShowing = true
        viewModel.isActivityIndicatorShowing = true
    }
    
    
    private func validateInputs() -> Bool {
        if viewModel.isOldPasswordEmpty {
            viewModel.inputFocus = .oldPassword
            return false
        }
        
        if viewModel.isNewPasswordEmpty {
            showAlert(message: viewModel.enterNewPasswordMessage,
                      okAction: { [weak self] _ in
                self?.viewModel.inputFocus = .newPassword
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
    
    private func showAlert(message: String, okAction: @escaping (UIAlertAction) -> Void) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: viewModel.okButtonLabel, style: .default, handler: okAction)
        alertController.addAction(okButton)
        alertController.preferredAction = okButton
        present(alertController, animated: true)
    }

    private func resetNewPasswords() -> (UIAlertAction) -> Void {
        return { [weak self] _ in
            self?.newPasswordTextField.text = ""
            self?.confirmPasswordTextField.text = ""
            self?.viewModel.inputFocus = .newPassword
        }
    }
    
    private func startOver() {
        oldPasswordTextField.text = ""
        newPasswordTextField.text = ""
        confirmPasswordTextField.text = ""
        viewModel.inputFocus = .oldPassword
        viewModel.isBlurViewShowing = false
        viewModel.isCancelButtonEnabled = true
    }
    
    private func handleSuccess() {
        viewModel.isActivityIndicatorShowing = false
        showAlert(message: viewModel.successMessage,
                  okAction: { [weak self] _ in
            self?.dismiss(animated: true)
        })
    }
    
    private func handleFailure(_ message: String) {
        viewModel.isActivityIndicatorShowing = false
        showAlert(message: message, okAction: { [weak self] _ in
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
    
    private func updateInputFocus() {
        switch viewModel.inputFocus {
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
    
    private func updateBlurView() {
        if viewModel.isBlurViewShowing {
            view.backgroundColor = .clear
            view.addSubview(blurView)
            NSLayoutConstraint.activate([
                blurView.heightAnchor.constraint(equalTo: view.heightAnchor),
                blurView.widthAnchor.constraint(equalTo: view.widthAnchor)
            ])
        } else {
            view.backgroundColor = .white
            blurView.removeFromSuperview()
        }
    }
    
    private func updateActivityIndicator() {
        if viewModel.isActivityIndicatorShowing {
            view.addSubview(activityIndicator)
            NSLayoutConstraint.activate([
                activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
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
            viewModel.inputFocus = .newPassword
        } else if textField === newPasswordTextField {
            viewModel.inputFocus = .confirmPassword
        } else if textField === confirmPasswordTextField {
            changePassword()
        }
        return true
    }
}
