//
//  ViewController.swift
//  ToDoList
//
//  Created by Kean Chin on 1/9/18.
//  Copyright © 2018 Kean Chin. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var itemArray = [Item]()
    let itemListArrayKey = "ToDoItemListArray"
    var userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Note: Either userDefaults.object() or userDefaults.array()
        if let savedItems = userDefaults.array(forKey: itemListArrayKey) as? [Item] {
            itemArray = savedItems
        }
        
        for i in 1...30 {
            let newItem = Item()
            newItem.title = String(i)
            newItem.done = false
            itemArray.append(newItem)
        }
    }

    // MARK: - TableView Datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }
    
    // MARK: - TableView Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var newItemTextField = UITextField()
        
        let alertController = UIAlertController(title: "Add New To-Do Item", message: "", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Add Item", style: .default) { (uiAlertAction) in
            
            // Must use the "self" keyword in a closure
            let newItem = Item()
            newItem.title = newItemTextField.text ?? ""
            self.itemArray.append(newItem)
            self.userDefaults.set(self.itemArray, forKey: self.itemListArrayKey)
            self.tableView.reloadData()
        }
        
        alertController.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter new item"
            newItemTextField = alertTextField
        }
        
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    
}

