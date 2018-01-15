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
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("ToDoItems.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        // Note: Either userDefaults.object() or userDefaults.array()
//        if let savedItems = userDefaults.array(forKey: itemListArrayKey) as? [Item] {
//            itemArray = savedItems
//        }
        
        print(dataFilePath ?? "Data File Path not found!")
        
//        // Test Code
//        for i in 1...5 {
//            let newItem = Item()
//            newItem.title = String(i)
//            newItem.done = false
//            itemArray.append(newItem)
//        }
        
        loadItemsFromDataFile()
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
        saveItemsToDataFile()
    }
    
    // MARK: Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var newItemTextField = UITextField()
        
        let alertController = UIAlertController(title: "Add New To-Do Item", message: "", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Add Item", style: .default) { (uiAlertAction) in
            
            let newItem = Item()
            newItem.title = newItemTextField.text ?? ""
            // Must use the "self" keyword in a closure
            self.itemArray.append(newItem)
            self.tableView.reloadData()
            self.saveItemsToDataFile()
        }
        
        alertController.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter new item"
            newItemTextField = alertTextField
        }
        
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: Model manipulation methods
    func saveItemsToDataFile() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding item array, \(error)")
        }
    }

    func loadItemsFromDataFile() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding item array, \(error)")
            }
        }
    }
}

