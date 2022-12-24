//
//  UIImageView.swift
//  ContactList
//
//  Created by Kiran Sonne on 23/12/22.
//

import UIKit
extension UIImageView {
    // round shape image
    func makeRounded() {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}
