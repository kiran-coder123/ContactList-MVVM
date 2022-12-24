//
//  SQLiteCommands.swift
//  ContactList
//
//  Created by Kiran Sonne on 23/12/22.
//

import Foundation
import SQLite
import SQLite3
class SQLiteCommands {
    static var table = Table("contact")
    
    // Expressions
    static let id = Expression<Int>("id")
    static let firstName = Expression<String>("firstName")
    static let lastName = Expression<String>("lastName")
    static let phoneNumber = Expression<String>("phoneNumber")
    static let photo = Expression<Data>("photo")
    
    // creating table
    static func createTable() {
        guard let database = SQLiteDatabase.sharedInstance.database else {
            print("DataStore Connection Error")
            return
        }
        do {
        try database.run(table.create(ifNotExists: true){ table in
                table.column(id, primaryKey: true)
                table.column(firstName)
                table.column(lastName)
                table.column(phoneNumber, unique: true)
                table.column(photo)
            })
        } catch  {
            print("Table already exist : \(error)")
        }
    }
    // inserting row
    static func insertRow(_ contactValues: Contact) -> Bool? {
        guard let database = SQLiteDatabase.sharedInstance.database else {
            print("DataStore Connection Error")
            return nil}
        do {
            try database.run(table.insert(firstName <-
                                          contactValues.firstName, lastName <- contactValues.lastName, phoneNumber <- contactValues.phoneNumber, photo <- contactValues.photo))
            return true
        } catch  let Result.error(message,code,statment) where code == SQLITE_CONSTRAINT{
             print("Insert row failed :\(message), in \(String(describing: statment))")
            return false
        } catch let error  {
            print("Insertion failed : \(error)")
            return false
        }
    }
    
    // updating row
    
    static func updateRow(_ contactValue: Contact) -> Bool? {
        guard let database = SQLiteDatabase.sharedInstance.database else {
           print("Datastore connection error")
            return nil
        }
                
        let contact = table.filter(id == contactValue.id).limit(1)
        do {
            if try database.run(contact.update(firstName <-
                                                contactValue.firstName, lastName <- contactValue.lastName, phoneNumber <- contactValue.phoneNumber, photo <- contactValue.photo)) > 0 {
                print("Updated COntact")
                return true
            } else {
                 print("Could not updated contact")
                return false
            }
        } catch let Result.error(message, code, statement) where code == SQLITE_CONSTRAINT {
            print("update row failed \(message) , in: \(String(describing: statement)))")
            return false
            
        } catch let error {
            print("Updation failed \(error.localizedDescription)")
            return false
        }
    }
    
    
 
    // present rows
    static func presentRows() -> [Contact]? {
        guard let database = SQLiteDatabase.sharedInstance.database else {
            print("database connection failed error")
            return nil
        }
        // contact array
        var contactsArray = [Contact]()
        
        // sorting data in descending order by ID
        table = table.order(id.desc)
        
        do {
            for contact in try database.prepare(table){
                let idValue = contact[id]
                let firstNameValue = contact[firstName]
                let lastNameValue = contact[lastName]
                let phoneNumberValue = contact[phoneNumber]
                let photoValue = contact[photo]
                
                // create object
                let contactObject = Contact(id: idValue, firstName: firstNameValue, lastName: lastNameValue, phoneNumber: phoneNumberValue, photo: photoValue)
               // add object to an array
                contactsArray.append(contactObject)
                print("id \(contact[id]), firstName \(contact[firstName]), lastName \(contact[lastName]), phoneNumber \(contact[phoneNumber]), photo \(contact[photo])")

            }
        } catch {
             print("Present row error \(error)")
        }
         return contactsArray
        
    }
    
    // delete row
    static func deleteRow(contactID: Int) {
        guard let  database = SQLiteDatabase.sharedInstance.database else {
            print("Datastore connection error")
            return
            
        }
        do {
            let contact = table.filter(id == contactID).limit(1)
            try database.run(contact.delete())
        } catch   {
            print("Delete row error \(error)")
        }
    }
}
