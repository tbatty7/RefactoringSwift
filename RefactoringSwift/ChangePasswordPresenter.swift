//
//  ChangePasswordPresenter.swift
//  RefactoringSwift
//
//  Created by Timothy D Batty on 3/2/22.
//

import Foundation

class ChangePasswordPresenter {
    private unowned var view: ChangePasswordViewCommands!
    private let labels: ChangePasswordLabels
    private var securityToken: String
    private var passwordChanger: PasswordChanging
    
    init(view: ChangePasswordViewCommands, labels: ChangePasswordLabels, securityToken: String, passwordChanger: PasswordChanging) {
        self.view = view
        self.labels = labels
        self.securityToken = securityToken
        self.passwordChanger = passwordChanger
    }
    
    private func startOver() {
        view.clearAllPasswordFields()
        view.updateInputFocus(.oldPassword)
        view.hideBlurView()
        view.setCancelButtonEnabled(true)
    }
    
    private func handleSuccess() {
        view.hideActivityIndicator()
        view.showAlert(message: labels.successMessage,
                       okAction: { [weak self] in
            self?.view.dismissModal()
        })
    }
    
    private func handleFailure(_ message: String) {
        view.hideActivityIndicator()
        view.showAlert(message: message, okAction: { [weak self] in
            self?.startOver()
        })
    }
    
    private func attemptToChangePassword(_ passwordInputs: PasswordInputs) {
        passwordChanger.change(securityToken: securityToken,
                               oldPassword: passwordInputs.oldPassword,
                               newPassword: passwordInputs.newPassword,
                               onSuccess: {[weak self] in self?.handleSuccess()},
                               onFailure: {[weak self] message in self?.handleFailure(message)})
    }
    
    private func setupWaitingAppearance() {
        view.updateInputFocus(.noKeyboard)
        view.setCancelButtonEnabled(false)
        view.showBlurView()
        view.showActivityIndicator()
    }
    
    private func resetNewPasswords() -> () -> Void {
        return { [weak self] in
            self?.view.clearNewPasswordFields()
            self?.view.updateInputFocus(.newPassword)
        }
    }
    
    private func validateInputs(passwordInputs: PasswordInputs) -> Bool {
        if passwordInputs.isOldPasswordEmpty {
            view.updateInputFocus(.oldPassword)
            return false
        }

        if passwordInputs.isNewPasswordEmpty {
            view.showAlert(message: labels.enterNewPasswordMessage,
                      okAction: { [weak self] in
                self?.view.updateInputFocus(.newPassword)
            })
            return false
        }
        
        if passwordInputs.isNewPasswordTooShort {
            view.showAlert(message: labels.newPasswordTooShortMessage,
                      okAction: resetNewPasswords())
            
            return false
        }
        
        if passwordInputs.isConfirmPasswordMismatched {
            view.showAlert(message: labels.confirmationPasswordDoesNotMatchMessage, okAction: resetNewPasswords())
            return false
        }
        return true
    }
    
    func cancel() {
        view.updateInputFocus(.noKeyboard)
        view.dismissModal()
    }
    
    func changePassword(_ passwordInputs: PasswordInputs) {
        guard validateInputs(passwordInputs: passwordInputs) else { return }
        setupWaitingAppearance()
        attemptToChangePassword(passwordInputs)
    }
}
