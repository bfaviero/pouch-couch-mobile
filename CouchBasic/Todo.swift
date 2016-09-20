//
//  Todo.swift
//  CouchBasic
//
//  Created by Bruno Faviero on 9/19/16.
//  Copyright © 2016 BF. All rights reserved.
//

import Foundation

class Todo {
    
    private let document: CBLDocument
    
    var done: Bool {
        didSet {
            sync()
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
    
    init(doc: CBLDocument) {
        let dict = doc.properties!
        self.done = dict["done"] as! Bool
        self.what = dict["what"] as! String
        self.document = doc
    }
    
    func toDict() -> [String: AnyObject] {
        return ["what": what, "done": done]
    }
    
    // MARK - CouchBase methods
    
    func delete() {
        try! document.deleteDocument()
    }
    
    func sync() {
        document.setProperties(toDict())
    }
}
