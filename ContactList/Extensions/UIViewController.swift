//
//  UIViewController.swift
//  ContactList
//
//  Created by Kiran Sonne on 23/12/22.
//

import UIKit
extension UIViewController {
    // alert message
    func showError(_ title: String?, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
