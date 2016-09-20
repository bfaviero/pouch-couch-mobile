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
            try! putProperties(properties)
        }
    }
}

class TodoListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    var database: CBLDatabase!
    var dataSource: CBLUITableSource!
    var liveQuery: CBLLiveQuery!
    var todos = [Todo]()
    let textField = UITextField()
    
    let tableView = UITableView()
    
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
        self.database = AppDelegate.delegate.database
        let query = database.createAllDocumentsQuery()
        liveQuery = query.asLiveQuery()
        liveQuery.addObserver(self, forKeyPath: "rows", options: NSKeyValueObservingOptions.New, context: nil)
        liveQuery.start()
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if let query = liveQuery, rows = query.rows where keyPath == "rows" {
            let todos = rows.map {Todo(doc: $0.document!)}
            self.todos = todos
            self.tableView.reloadData()
        }
    }
    
    // MARK - UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "cell")
        let todo = todos[indexPath.row]
        cell.textLabel!.text = todo.what
        if todo.done {
            cell.backgroundColor = UIColor.greenColor().colorWithAlphaComponent(0.3)
        }
        return cell
    }
    
    // MARK - UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let todo = todos[indexPath.row]
        todo.done = !todo.done
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let done = UITableViewRowAction(style: .Default, title: "Done") { action, index in
            self.todos[index.row].done = true
        }
        done.backgroundColor = UIColor.blueColor()
        let delete = UITableViewRowAction(style: .Destructive, title: "Delete") { action, index in
            self.todos[index.row].delete()
        }
        delete.backgroundColor = UIColor.redColor()
        
        return [done, delete]
    }
    
    // MARK - UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if let text = self.textField.text where text.characters.count > 0 {
            Todo.newRemoteTodo(database, text: text)
            self.textField.text = nil
        }
        return true
    }
    
}
