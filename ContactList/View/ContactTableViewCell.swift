//
//  ContactTableViewCell.swift
//  ContactList
//
//  Created by Kiran Sonne on 23/12/22.
//

import UIKit

class ContactTableViewCell: UITableViewCell {

    @IBOutlet weak var contactNameLabel: UILabel!
    
    @IBOutlet weak var contactPhotoImageView: UIImageView!
    
    @IBOutlet weak var contactPhoneLabel: UILabel!
    
    func setCellWithValues(_ contatct: Contact) {
        contactNameLabel.text = contatct.firstName + " " + contatct.lastName
        contactPhoneLabel.text = contatct.phoneNumber
        
        let image = UIImage(data: contatct.photo)
        contactPhotoImageView.image = image
        contactPhotoImageView.makeRounded()
    }
}
