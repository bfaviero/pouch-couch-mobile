//
//  Todo.swift
//  CouchBasic
//
//  Created by Bruno Faviero on 9/19/16.
//  Copyright © 2016 BF. All rights reserved.
//

import Foundation

class SimpleTodo {
    
    var done: Bool
    var what: String
    
    // Initialize and create a document
    init(what: String, done: Bool = false) {
        self.done = done
        self.what = what
    }
    
    // Generate a dictionary of values
    func toDict() -> [String: AnyObject] {
        return ["what": what, "done": done]
    }
}

class RemoteTodo: SimpleTodo {
    
    private let document: CBLDocument // JSON that is stored in the remote database
    
    init(what: String, done: Bool = false, document: CBLDocument? = nil) {
        if let doc = document {
            self.document = doc
        } else {
            self.document = databaseManager.database.createDocument()
            self.document.setProperties(["what": what, "done": done])
        }
        super.init(what: what, done: done)
    }
    
    // Initialize from an existing doc
    convenience init(document: CBLDocument) {
        let properties = document.properties!
        let what = properties["what"] as! String
        let done = properties["done"] as! Bool
        self.init(what: what, done: done, document: document)
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
    var todos = [RemoteTodo]()
    
    func deleteTodo(index: Int) {
        let todo = todos[index]
        todo.removeFromServer()
        todos.removeAtIndex(index)
    }
    
    func getTodoAtIndex(index: Int) -> RemoteTodo {
        return todos[index]
    }
    
    func addTodo(what: String) {
        todos.append(RemoteTodo(what: what))
    }
    
    func toggleTodoDone(index: Int) {
        let todo = todos[index]
        todo.done = !todo.done
        todo.sync()
    }
}
