//
//  ChangePasswordViewCommands.swift
//  RefactoringSwift
//
//  Created by Timothy D Batty on 3/2/22.
//

import Foundation

protocol ChangePasswordViewCommands: AnyObject {
    func hideActivityIndicator()
    func showActivityIndicator()
    func dismissModal()
    func showAlert(message: String, okAction: @escaping () -> Void)
    func hideBlurView()
    func showBlurView()
    func setCancelButtonEnabled(_ isEnabled: Bool)
    func updateInputFocus(_ inputFocus: InputFocus)
    func clearAllPasswordFields()
    func clearNewPasswordFields()
}

enum InputFocus {
    case noKeyboard
    case oldPassword
    case newPassword
    case confirmPassword
}
