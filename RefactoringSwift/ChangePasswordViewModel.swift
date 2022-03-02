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
    var oldPassword = ""
    var newPassword = ""
    var confirmPassword = ""
    var isOldPasswordEmpty: Bool { oldPassword.isEmpty }
    var isNewPasswordEmpty: Bool { newPassword.isEmpty }
    var isNewPasswordTooShort: Bool { newPassword.count < 6 }
    var isConfirmPasswordMismatched: Bool { newPassword != confirmPassword }
    typealias InputFocus = RefactoringSwift.InputFocus
//    enum InputFocus {
//        case noKeyboard
//        case oldPassword
//        case newPassword
//        case confirmPassword
//    }
}
