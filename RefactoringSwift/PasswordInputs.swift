//
//  PasswordInputs.swift
//  RefactoringSwift
//
//  Created by Timothy D Batty on 3/3/22.
//

import Foundation

struct PasswordInputs {
    let oldPassword: String
    let newPassword: String
    let confirmPassword: String
    var isOldPasswordEmpty: Bool { oldPassword.isEmpty }
    var isNewPasswordEmpty: Bool { newPassword.isEmpty }
    var isNewPasswordTooShort: Bool { newPassword.count < 6 }
    var isConfirmPasswordMismatched: Bool { newPassword != confirmPassword }
}
