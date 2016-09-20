//
//  TodoViewController.swift
//  CouchBasic
//
//  Created by Bruno Faviero on 9/18/16.
//  Copyright © 2016 BF. All rights reserved.
//

import Foundation
import UIKit

class TodoListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    let textField = UITextField()
    let tableView = UITableView()
    var database: CBLDatabase!
    let todoManager = TodoManager()
    let queryManager = QueryManager()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        self.edgesForExtendedLayout = .None
        
        // textfield
        textField.placeholder = "Add a new todo"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        
        // setup tableview
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorColor = .clearColor()
        tableView.dataSource = self
        tableView.delegate = self
        
        // layout
        self.view.addSubview(textField)
        textField.constrainToItem(view, attributes: [.Left, .Right, .Top])
        textField.constrainAttribute(.Height, constant: 60)

        view.addSubview(tableView)
        tableView.constrainToItem(view, attributes: [.Left, .Right, .Bottom])
        view.addConstraint(NSLayoutConstraint(item: tableView, attribute: .Top, toItem: textField, attribute: .Bottom))
        
        queryManager.todoStream.asObservable()
            .subscribeNext { todos in
                self.todoManager.todos = todos
                self.tableView.reloadData()
            }.addDisposableTo(disposeBag)
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoManager.todos.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "cell")
        cell.selectionStyle = .None
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
