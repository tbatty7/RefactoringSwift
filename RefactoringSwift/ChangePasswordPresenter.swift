//
//  ChangePasswordPresenter.swift
//  RefactoringSwift
//
//  Created by Timothy D Batty on 3/2/22.
//

import Foundation

class ChangePasswordPresenter {
    private unowned var view: ChangePasswordViewCommands!
    private var viewModel: ChangePasswordViewModel
    private var securityToken: String
    private var passwordChanger: PasswordChanging
    
    init(view: ChangePasswordViewCommands, viewModel: ChangePasswordViewModel, securityToken: String, passwordChanger: PasswordChanging) {
        self.view = view
        self.viewModel = viewModel
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
        view.showAlert(message: viewModel.successMessage,
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
    
    func attemptToChangePassword() {
        passwordChanger.change(securityToken: securityToken,
                               oldPassword: viewModel.oldPassword,
                               newPassword: viewModel.newPassword,
                               onSuccess: {[weak self] in self?.handleSuccess()},
                               onFailure: {[weak self] message in self?.handleFailure(message)})
    }
}
