//
//  ViewController.swift
//  RefactoringSwift
//
//  Created by Timothy D Batty on 2/18/22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "changePassword" {
            let changePasswordVC = segue.destination as? ChangePasswordViewController
            changePasswordVC?.securityToken = "TOKEN"
            changePasswordVC?.viewModel = ChangePasswordViewModel(okButtonLabel: "OK",
                                                                  enterNewPasswordMessage: "Please enter a new password.",
                                                                  newPasswordTooShortMessage: "The new password should have at least 6 characters.",
                                                                  confirmationPasswordDoesNotMatchMessage: "The new password and the confirmation password " +
                                                                  "don't match. Please try again",
                                                                  successMessage: "Your password has been successfully changed",
                                                                  title: "Change Password",
                                                                  oldPasswordPlaceholder: "Current Password",
                                                                  newPasswordPlaceholder: "New Password",
                                                                  confirmPasswordPlaceholder: "Confirm New Password",
                                                                  submitButtonLabel: "Submit")
        }
    }
    
    deinit {
        print(">>>>>>>> Deinit ViewController")
    }

}

