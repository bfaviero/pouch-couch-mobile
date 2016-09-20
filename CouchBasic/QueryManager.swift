//
//  QueryManager.swift
//  CouchBasic
//
//  Created by Bruno Faviero on 9/20/16.
//  Copyright © 2016 BF. All rights reserved.
//

import Foundation

class QueryManager: NSObject {
    
    let liveQuery: CBLLiveQuery
    let todoStream = PublishSubject<[RemoteTodo]>()
    
    override init() {
        let database = databaseManager.database // 1. Grab the database we initialized
        let query = database.createAllDocumentsQuery() // 2. Query for all the documents in the database
        liveQuery = query.asLiveQuery() // 3. Create a "live query" - rows automatically update
        super.init()
        liveQuery.addObserver(self, forKeyPath: "rows", options: NSKeyValueObservingOptions.New, context: nil) // 4. Observe for the changed value
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if let rows = liveQuery.rows where keyPath == "rows" {
            let todos = rows.map {RemoteTodo(document: $0.document!)}
            todoStream.onNext(todos) // 4. Stream rows as they are updated
        }
    }
}
