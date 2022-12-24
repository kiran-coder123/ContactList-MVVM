//
//  NewContactViewController.swift
//  ContactList
//
//  Created by Kiran Sonne on 23/12/22.
//

import UIKit

class NewContactViewController: UIViewController {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    var viewModel: NewContactViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        createTable()
        setUpViews()
        photoImageView.makeRounded()
        firstNameTextField.becomeFirstResponder()
        phoneNumberTextField.delegate = self
    }
    //  connect to database and create table
    private func createTable() {
        let database = SQLiteDatabase.sharedInstance
        database.creatTable()
    }
    
    private func setUpViews() {
        if let viewModel = viewModel {
            firstNameTextField.text = viewModel.firstName
            lastNameTextField.text = viewModel.lastName
            phoneNumberTextField.text = viewModel.phoneNumber
            photoImageView.image = viewModel.photo
        }
    }
    
    

    @IBAction func saveButton(_ sender: Any) {
        let id: Int = viewModel == nil ? 0 : viewModel.id!
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let phoneNumber = phoneNumberTextField.text ?? ""
        let uiImage = photoImageView.image ?? nil
        guard let photo =  uiImage?.pngData() else { return }
        
        let contactValues = Contact(id: id, firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, photo: photo)
        
        if viewModel == nil {
            // contact created
            createNewContact(contactValues)
        } else {
            // contact updated
            updateContact(contactValues)
        }
        //SQLiteCommands.presentRows()
    }
    
    
    private func createNewContact(_ contactValues: Contact) {
        let contactAddedToTable = SQLiteCommands.insertRow(contactValues)
        
        if contactAddedToTable == true {
            dismiss(animated: true, completion: nil)
        } else {
            showError("Error", message: " this contact cannot be created because this phone number already exist in your contact list")
        }
    }
    
    private func updateContact(_ contactValues: Contact) {
        let contactUpdatedInTable = SQLiteCommands.updateRow(contactValues)
        
        //check phone number is already  exists
        if contactUpdatedInTable == true {
            if let cellClicked = navigationController {
                cellClicked.popViewController(animated: true)
            }
        } else {
            showError("Error", message: "This contatc cannot be updated because this phone number is already exists in your contact list")
        }
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        let addButtonClicked = presentingViewController is UINavigationController
        if addButtonClicked {
            dismiss(animated: true, completion: nil)
          }
        else if let cellCliked = navigationController {
            cellCliked.popViewController(animated: true)
        } else {
            print("this is not inside navigation controller")
        }
        
        }
}

extension NewContactViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBAction func addImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
         dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("we provided following \(info)")
        }
        photoImageView.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
}
extension NewContactViewController: UITextFieldDelegate {
    // phone number validation
    private func format(with mask: String, phone: String) -> String {
        
        let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex

        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                result.append(numbers[index])
                index = numbers.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text  else { return false }
        let newString = (text as NSString).replacingCharacters(in: range, with: string)
        textField.text = format(with: " XXXXXXXXXX", phone: newString)
        return false
    }
}
