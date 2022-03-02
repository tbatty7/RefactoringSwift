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
    
    init(view: ChangePasswordViewCommands, viewModel: ChangePasswordViewModel) {
        self.view = view
        self.viewModel = viewModel
    }
    
    func handleSuccess() {
        view.hideActivityIndicator()
        view.showAlert(message: viewModel.successMessage,
                  okAction: { [weak self] in
            self?.view.dismissModal()
        })
    }
    
    func startOver() {
        view.clearAllPasswordFields()
        view.updateInputFocus(.oldPassword)
        view.hideBlurView()
        view.setCancelButtonEnabled(true)
    }
    
    func handleFailure(_ message: String) {
        view.hideActivityIndicator()
        view.showAlert(message: message, okAction: { [weak self] in
            self?.startOver()
        })
    }
}
