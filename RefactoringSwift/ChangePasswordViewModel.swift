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
}
