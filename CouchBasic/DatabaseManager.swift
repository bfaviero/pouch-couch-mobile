//
//  DatabaseManager.swift
//  CouchBasic
//
//  Created by Bruno Faviero on 9/20/16.
//  Copyright © 2016 BF. All rights reserved.
//

import Foundation

struct DatabaseManager {
    
    let databaseName = "c1"
    let databaseUrl = NSURL(string: "https://pouch-couch.gleb-demos.com/db/c1/")!
    var database: CBLDatabase!
    var pusher: CBLReplication!
    var puller: CBLReplication!
    
    init() {
        try! database = CBLManager.sharedInstance().databaseNamed("c1")
        puller = database.createPullReplication(databaseUrl)
        pusher = database.createPushReplication(databaseUrl)
        pusher.continuous = true
        puller.continuous = true
        pusher.start()
        puller.start()
    }
}
let databaseManager = DatabaseManager()