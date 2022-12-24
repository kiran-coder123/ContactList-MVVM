//
//  ContactScreenTableViewController.swift
//  ContactList
//
//  Created by Kiran Sonne on 23/12/22.
//

import UIKit

class ContactScreenTableViewController: UITableViewController {
    private var viewModel = ContactScreenViewModel()

     var arr = [Contact]()
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Contacts"
        
        // connect to database
        viewModel.connectToDatabase()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadData()
        tableView.reloadData()
    }
    
    
    private func loadData() {
        viewModel.loadDataFromSQLiteDatabase()
    }
    

    // MARK: - Table view data source
 

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        viewModel.numberOfRowInSection(section: section)
    }

    @IBAction func deleteContactButton(_ sender: Any) {
        
    
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let object = viewModel.cellForRowAt(indexPath: indexPath)
        
        if let contactCell = cell as? ContactTableViewCell {
            contactCell.setCellWithValues(object)
        }

        // Configure the cell...

        return cell
    }
    
    // delete cell from table
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let contact = viewModel.cellForRowAt(indexPath: indexPath)
          
          // delete contact from database
            SQLiteCommands.deleteRow(contactID: contact.id)
           
            // update the UI after delete row changes
            self.loadData()
            self.tableView.reloadData()
        }
    }
   
 
     
    // MARK: - Navigation
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editContact"{
            guard let  newContactVC = segue.destination as? NewContactViewController else { return }
            guard let selectedContactCell = sender as? ContactTableViewCell else { return }
            if let indexPath = tableView.indexPath(for: selectedContactCell) {
                let selectedContact = viewModel.cellForRowAt(indexPath: indexPath)
                newContactVC.viewModel = NewContactViewModel(contactValues: selectedContact)
            }
        }
        
    }
  

}
