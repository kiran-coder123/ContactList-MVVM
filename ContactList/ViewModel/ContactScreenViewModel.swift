//
//  ContactScreenViewModel.swift
//  ContactList
//
//  Created by Kiran Sonne on 23/12/22.
//

import Foundation
class ContactScreenViewModel {
    private var contactArray = [Contact]()
    
    func connectToDatabase(){
        _ = SQLiteDatabase.sharedInstance
    }
    
    func loadDataFromSQLiteDatabase(){
        contactArray = SQLiteCommands.presentRows() ?? []
    }
    
    
    func numberOfRowInSection (section: Int) -> Int {
        if contactArray.count != 0 {
            return contactArray.count
        }
        return 0
    }
    func cellForRowAt (indexPath: IndexPath) -> Contact {
        return contactArray[indexPath.row]
        
    }
}
