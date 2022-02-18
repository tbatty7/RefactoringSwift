//
//  PasswordChanger.swift
//  RefactoringSwift
//
//  Created by Timothy D Batty on 2/18/22.
//

import Foundation

final class PasswordChanger {
    private static var pretendToSucceed = false
    private var successOrFailureTimer: SuccessOrFailureTimer?
    
    func change(securityToken: String,
                oldPassword: String,
                newPassword: String,
                onSuccess: @escaping () -> Void,
                onFailure: @escaping (String) -> Void) {
        print("Initiate Change Password:")
        print("Security Token: \(securityToken)")
        print("oldPassword: \(oldPassword)")
        print("newPassword: \(newPassword)")
        
        successOrFailureTimer = SuccessOrFailureTimer(onSuccess: onSuccess, onFailure: onFailure, timer: Timer.scheduledTimer(withTimeInterval: 1, repeats: false) {
            [weak self] _ in self?.callSuccessOrFailure()
        })
    }
    
    func callSuccessOrFailure() {
        if PasswordChanger.pretendToSucceed {
            successOrFailureTimer?.onSuccess()
        } else {
            successOrFailureTimer?.onFailure("Sorry, something went wrong")
        }
        PasswordChanger.pretendToSucceed.toggle()
        successOrFailureTimer?.timer.invalidate()
        successOrFailureTimer = nil
    }
}

private struct SuccessOrFailureTimer {
    let onSuccess: () -> Void
    let onFailure: (String) -> Void
    let timer: Timer
}
