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
        }

    }
}

