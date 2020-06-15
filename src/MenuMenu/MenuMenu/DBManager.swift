//
//  DBManager.swift
//  MenuMenu
//
//  Created by jinkyuhan on 2020/06/10.
//  Copyright © 2020 COMP420. All rights reserved.
//

import Foundation
import SQLite3
class DBManager {
    static let shared = DBManager()
    private let dbURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("menumenu.sqlite")
    private var db:OpaquePointer?
    private init(){
        // Copy database from Bundle to Document
        let url = Bundle.main.resourceURL?.appendingPathComponent("menumenu.sqlite")
        if !FileManager.default.fileExists(atPath: dbURL.path) {
            do {
                try FileManager.default.copyItem(atPath: (url?.path)!, toPath: dbURL.path)
            } catch let error as NSError {
                print("!!! ERROR copy db from bundle to filesystem fail:\n\(error)")
            }
        }
    }
    
    func openDatabase() {
        if sqlite3_open(self.dbURL.path, &(self.db)) != SQLITE_OK {
            print("!!! Error Opening Database")
        } else {
            print("File path: \(self.dbURL.path)") // DEBUG
        }
    }
    
    func execSQL(sql: String) {
        if sqlite3_exec(self.db, sql, nil, nil, nil) != SQLITE_OK {
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("!!! Error Executing sql: \(errMsg)")
        }
    }
    func execQuery(queryString: String) -> [Dictionary<String, String>]? {
        var stmt : OpaquePointer?
        var resultRecords = [Dictionary<String,String>]()
        defer {
            sqlite3_finalize(stmt)
        }
        if sqlite3_prepare(self.db, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errMsg = String(cString: sqlite3_errmsg(self.db)!)
            print("!!! Error Preparing Query: \(errMsg)")
            return nil
        }
        while(sqlite3_step(stmt) == SQLITE_ROW) {
            var record : Dictionary<String, String> = [:]
            
            for i in 0...sqlite3_column_count(stmt)-1 {
                let column: String = String(cString: sqlite3_column_name(stmt, i))
                let value: String = String(cString: sqlite3_column_text(stmt, i))
                record[column] = value
            }
            
            resultRecords.append(record)
        }
        
        return resultRecords
    }
    
    func closeDatabase(){
        if sqlite3_close(self.db) != SQLITE_OK {
            print("!!! Error Closing Database")
        }
    }
    
}
