//
//  Database.swift
//  FitIOT
//
//  Created by sanou abou on 05/11/2019.
//  Copyright © 2019 sanou abou. All rights reserved.
//

import Foundation
import SQLite3


class Database{
    //var part1DbPath = "db/database.sqlite"
    var db: OpaquePointer?
    var stmt: OpaquePointer?
    
    
    let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        .appendingPathComponent("Database.sqlite")
    func openDatabase() -> Bool {
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
            return false
        }
        return true
        
    }
    
    func createTable(){
        
        if sqlite3_exec(db, "CREATE TABLE runnings ( id INTEGER PRIMARY KEY AUTOINCREMENT,time TEXT,distance TEXT, letemps TEXT )", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
        
        if sqlite3_exec(db, "CREATE TABLE positions ( id INTEGER PRIMARY KEY AUTOINCREMENT, runningsid INTEGER, latitude TEXT, longitude TEXT)", nil , nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
    
 }

    func addRunning(running: Running){
         //let queryString = "INSERT INTO runnings (distance, time) VALUES (?,?)"
        let queryString = "INSERT INTO runnings (distance, time, letemps) VALUES (?,?,datetime('now'))"
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        if sqlite3_bind_text(stmt, 1, running.distance, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
        
        if sqlite3_bind_text(stmt, 2, running.time,-1 ,nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting hero: \(errmsg)")
            return
        }
        
        
        
    }
    
    
    func addPosition(position: Position, idrunning: Int){
         let queryString = "INSERT INTO positions (longitude, latitude, runningsid) VALUES (?,?,?)"
         if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
    
    
        if sqlite3_bind_text(stmt, 1, position.longitude, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
        
        if sqlite3_bind_text(stmt, 2, position.latitude,-1 ,nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
        
        if sqlite3_bind_int(stmt, 3, Int32(idrunning)) != SQLITE_OK
        {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
    
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting hero: \(errmsg)")
            return
        }
    }
    
    
    func getAllRunning() -> [Running] {
        var runList = [Running]()
        runList.removeAll()
        
        //this is our select query
        let queryString = "SELECT * FROM runnings"
        
        //statement pointer
        var stmtRead:OpaquePointer?
        
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmtRead, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return []
        }
        
        //traversing through all the records
        while(sqlite3_step(stmtRead) == SQLITE_ROW){
            let id = sqlite3_column_int(stmtRead, 0)
            let time = String(cString: sqlite3_column_text(stmtRead, 1))
            let distance = String(cString: sqlite3_column_text(stmtRead, 2))
            let dateTime = String(cString: sqlite3_column_text(stmtRead, 3))
            //adding values to list
            runList.append(Running(id: Int(id) ,time: time, distance: distance, dateTime: dateTime))
        }
        
    return runList
    }
    
    
    func getNumberRunning() -> Int {
        var id :Int = 0
        var runList = [Running]()
        runList.removeAll()
        
        //this is our select query
        let queryString = "SELECT COUNT(*) FROM runnings"
        
        //statement pointer
        var stmtRead:OpaquePointer?
        
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmtRead, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return id
        }
        
        //traversing through all the records
        while(sqlite3_step(stmtRead) == SQLITE_ROW){
              id = Int(sqlite3_column_int(stmtRead, 0))
          
        }
        
        return id
    }
    
    func getLastNumberRunning() -> Int {
        var id :Int = 0
        var runList = [Running]()
        runList.removeAll()
        
        //this is our select query
        let queryString = "SELECT MAX(id) FROM runnings"
        
        //statement pointer
        var stmtRead:OpaquePointer?
        
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmtRead, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return id
        }
        
        //traversing through all the records
        while(sqlite3_step(stmtRead) == SQLITE_ROW){
            id = Int(sqlite3_column_int(stmtRead, 0))
            
        }
        
        return id
    }
        

    func getAllPositions(idRunning: Int ) -> [Position] {
        var posList = [Position]()
        posList.removeAll()
        
        //this is our select query
        let queryString = "SELECT * FROM positions where idrunning = ?"
        
        //statement pointer
        var stmtRead:OpaquePointer?
        
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmtRead, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return []
        }
        
        if sqlite3_bind_int(stmt, 3, Int32(idRunning)) != SQLITE_OK
        {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return []
        }
        
        
        
        
        //traversing through all the records
        while(sqlite3_step(stmtRead) == SQLITE_ROW){
            let id = sqlite3_column_int(stmtRead, 0)
            let longitude = String(cString: sqlite3_column_text(stmtRead, 1))
            let latitude = String(cString: sqlite3_column_text(stmtRead, 2))
            
            //adding values to list
            posList.append(Position(id: Int(id) , latitude: latitude, longitude: longitude))
        }
        
        return posList
    }

}

