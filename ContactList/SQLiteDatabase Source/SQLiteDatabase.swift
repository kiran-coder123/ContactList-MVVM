//
//  SQLiteDatabase.swift
//  ContactList
//
//  Created by Kiran Sonne on 23/12/22.
//

import Foundation
import SQLite
import UIKit

class SQLiteDatabase {
    static let sharedInstance = SQLiteDatabase()
    var database: Connection?
    
    private init() {
        // create connection to database
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            
            let fileUrl = documentDirectory
                .appendingPathComponent("contactList")
                .appendingPathExtension("sqlite3")
            database = try Connection(fileUrl.path)

        } catch  {
            print("creating connection to database error \(error.localizedDescription)")
        }
    }
    // creating table
    
    func creatTable(){
        SQLiteCommands.createTable()
    }
}
