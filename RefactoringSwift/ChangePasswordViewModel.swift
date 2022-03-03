//
//  ChangePasswordViewModel.swift
//  RefactoringSwift
//
//  Created by Timothy D Batty on 3/1/22.
//

import Foundation

struct ChangePasswordViewModel {
    let okButtonLabel: String
    let enterNewPasswordMessage: String
    let newPasswordTooShortMessage: String
    let confirmationPasswordDoesNotMatchMessage: String
    let successMessage: String
    let title: String
    let oldPasswordPlaceholder: String
    let newPasswordPlaceholder: String
    let confirmPasswordPlaceholder: String
    let submitButtonLabel: String
    var oldPassword: String {
        get { passwordInputs.oldPassword }
        set { passwordInputs.oldPassword = newValue }
    }
    var newPassword: String {
        get { passwordInputs.newPassword }
        set { passwordInputs.newPassword = newValue }
    }
    var confirmPassword: String {
        get { passwordInputs.confirmPassword }
        set { passwordInputs.confirmPassword = newValue }
    }
    var isOldPasswordEmpty: Bool { passwordInputs.oldPassword.isEmpty }
    var isNewPasswordEmpty: Bool { passwordInputs.newPassword.isEmpty }
    var isNewPasswordTooShort: Bool { passwordInputs.newPassword.count < 6 }
    var isConfirmPasswordMismatched: Bool { passwordInputs.newPassword != passwordInputs.confirmPassword }
    var passwordInputs = PasswordInputs()
}
