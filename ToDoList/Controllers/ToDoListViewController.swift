//
//  ViewController.swift
//  ToDoList
//
//  Created by Kean Chin on 1/9/18.
//  Copyright © 2018 Kean Chin. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {

    var itemArray = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadItems()
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
        
//        // Remove item from list:
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)

        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        saveItemsToDataFile()
    }
    
    // MARK: Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var newItemTextField = UITextField()
        
        let alertController = UIAlertController(title: "Add New To-Do Item", message: "", preferredStyle: .alert)

        let alertAction = UIAlertAction(title: "Add Item", style: .default) { (uiAlertAction) in
            
            let newItem = Item(context: self.context)
            newItem.title = newItemTextField.text ?? ""
            newItem.done = false
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
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }

    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
        // Item.fetchRequest() is default value if one is not provided
        //let request : NSFetchRequest<Item> = Item.fetchRequest()
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }

        tableView.reloadData()
    }
}

// MARK: - Search bar methods
extension ToDoListViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        // [cd] == case and diacritic insensitive
        // reference https://academy.realm.io/posts/nspredicate-cheatsheet/
        // reference http://nshipster.com/nspredicate/
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)

        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request)
    }

    // When user cancels search
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async { // Engage the main thread (UI)
                searchBar.resignFirstResponder() // Dismiss keyboard
            }
        }
    }
}
