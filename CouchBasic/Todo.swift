//
//  Todo.swift
//  CouchBasic
//
//  Created by Bruno Faviero on 9/19/16.
//  Copyright © 2016 BF. All rights reserved.
//

import Foundation

class Todo {
    
    private let document: CBLDocument // JSON that is stored in the remote database
    
    var done: Bool {
        didSet {
            sync() // When this value changes, set it in the underlying document
        }
    }
    var what: String {
        didSet {
            sync()
        }
    }
    
    // Initialize from an existing doc
    init(document: CBLDocument) {
        let properties = document.properties!
        self.what = properties["what"] as! String
        self.done = properties["done"] as! Bool
        self.document = document
    }
    
    // Initialize and create a document
    init(what: String, done: Bool = false) {
        self.done = done
        self.what = what
        self.document = databaseManager.database.createDocument()
        self.document.setProperties(["what": what, "done": done])
    }
    
    // Generate a dictionary of values
    func toDict() -> [String: AnyObject] {
        return ["what": what, "done": done]
    }
    
    // MARK: CouchBase methods
    
    func removeFromServer() {
        try! document.deleteDocument()
    }
    
    // Set the values of the underlying document
    func sync() {
        document.setProperties(toDict())
    }
}

class TodoManager {
    var todos = [Todo]()
    
    func deleteTodo(index: Int) {
        let todo = todos[index]
        todo.removeFromServer()
        todos.removeAtIndex(index)
    }
    
    func getTodoAtIndex(index: Int) -> Todo {
        return todos[index]
    }
    
    func addTodo(what: String) {
        todos.append(Todo(what: what))
    }
    
    func toggleTodoDone(index: Int) {
        todos[index].done = !todos[index].done
    }
}

//class QueryManager: NSObject {
//    
//    let liveQuery: CBLLiveQuery
//    
//    override init() {
//        let database = databaseManager.database // 1. Grab the database we initialized
//        let query = database.createAllDocumentsQuery() // 2. Query for all the documents in the database
//        liveQuery = query.asLiveQuery() // 3. Create a "live query" - rows automatically update
//        super.init()
//        liveQuery.addObserver(self, forKeyPath: "rows", options: NSKeyValueObservingOptions.New, context: nil) // 4. Observe for the changed value
//    }
//    
//    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
//        if let rows = liveQuery.rows where keyPath == "rows" {
//            let todos = rows.map {Todo(document: $0.document!)}
////            self.todoManager.todos = todos
////            self.tableView.reloadData()
//        }
//    }
//}
