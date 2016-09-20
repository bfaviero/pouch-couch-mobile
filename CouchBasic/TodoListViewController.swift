//
//  TodoViewController.swift
//  CouchBasic
//
//  Created by Bruno Faviero on 9/18/16.
//  Copyright © 2016 BF. All rights reserved.
//

import Foundation
import UIKit

extension CBLDocument {
    func setProperties(props: [String: AnyObject], put: Bool = true) {
        var properties: [String: AnyObject] = self.properties ?? [:]
        for prop in props.keys {
            properties[prop] = props[prop]
        }
        if put {
            try! putProperties(properties) // Set properties to be synced with CouchBase
        }
    }
}

class TodoListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    let textField = UITextField()
    let tableView = UITableView()
    var database: CBLDatabase!
    var liveQuery: CBLLiveQuery!
    let todoManager = TodoManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        self.edgesForExtendedLayout = .None
        
        // textfield
        textField.placeholder = "Add a new todo"
        textField.translatesAutoresizingMaskIntoConstraints = false

        textField.delegate = self
        self.view.addSubview(textField)
        textField.constrainToItem(view, attributes: [.Left, .Right, .Top])
        textField.constrainAttribute(.Height, constant: 60)
        
        // setup tableview
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorColor = .clearColor()
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.constrainToItem(view, attributes: [.Left, .Right, .Bottom])
        view.addConstraint(NSLayoutConstraint(item: tableView, attribute: .Top, toItem: textField, attribute: .Bottom))
        
        // setup database
        self.database = databaseManager.database // 1. Grab the database we initialized
        let query = database.createAllDocumentsQuery() // 2. Query for all the documents in the database
        liveQuery = query.asLiveQuery() // 3. Create a "live query" - rows automatically update
        liveQuery.addObserver(self, forKeyPath: "rows", options: NSKeyValueObservingOptions.New, context: nil) // 4. Observe for the changed value
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if let query = liveQuery, rows = query.rows where keyPath == "rows" {
            let todos = rows.map {Todo(document: $0.document!)}
            self.todoManager.todos = todos
            self.tableView.reloadData()
        }
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoManager.todos.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "cell")
        let todo = todoManager.getTodoAtIndex(indexPath.row)
        cell.textLabel!.text = todo.what
        if todo.done {
            cell.backgroundColor = UIColor.greenColor().colorWithAlphaComponent(0.3)
        }
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        todoManager.toggleTodoDone(indexPath.row)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            todoManager.deleteTodo(indexPath.row)
        }
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if let text = self.textField.text where text.characters.count > 0 {
            todoManager.addTodo(text)
            self.textField.text = nil
        }
        return true
    }
    
}
