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
    
    static func newRemoteTodo(database: CBLDatabase, text: String) -> Todo {
        let document = database.createDocument()
        document.setProperties(["what": text, "done": false])
        return Todo(doc: document)
    }
    
    // Initialize a Todo and corresponding remote document
    init(doc: CBLDocument) {
        let dict = doc.properties!
        self.done = dict["done"] as! Bool
        self.what = dict["what"] as! String
        self.document = doc
    }
    
    // Generate a dictionary of values
    func toDict() -> [String: AnyObject] {
        return ["what": what, "done": done]
    }
    
    // MARK: CouchBase methods
    
    func delete() {
        try! document.deleteDocument()
    }
    
    // Set the values of the underlying document
    func sync() {
        document.setProperties(toDict())
    }
}
