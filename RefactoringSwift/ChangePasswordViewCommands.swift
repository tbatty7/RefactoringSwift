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
}
