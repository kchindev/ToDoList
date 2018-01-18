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
    
    // Access the singleton, which is the shared property of the application to presist data using the
    // "persistentContainer"
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // Use "didSet" to specify what should happen when the variable "selectedCategory" gets set with a new value
    var selectedCategory : Category? {
        didSet {
            loadItemsFromDatabase()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        //Moved to selectedCategory -> didSet above //loadItemsFromDatabase()
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
        saveItemsToDatabase()
    }
    
    // MARK: Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var newItemTextField = UITextField()
        
        let alertController = UIAlertController(title: "Add New To-Do Item", message: "", preferredStyle: .alert)

        let alertAction = UIAlertAction(title: "Add Item", style: .default) { (uiAlertAction) in
            
            let newItem = Item(context: self.context)
            newItem.title = newItemTextField.text ?? ""
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            // Must use the "self" keyword in a closure
            self.itemArray.append(newItem)
            self.tableView.reloadData()
            self.saveItemsToDatabase()
        }
        
        alertController.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter new item"
            newItemTextField = alertTextField
        }
        
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: Model manipulation methods
    func saveItemsToDatabase() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }

    func loadItemsFromDatabase(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        // Item.fetchRequest() is default value if one is not provided
        //let request : NSFetchRequest<Item> = Item.fetchRequest()
    
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        // Using optional binding to handle 2 cases: (1) "predicate" == "not nil", (2) "predicate" == "nil"
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching items from context \(error)")
        }

        tableView.reloadData()
    }
}

// MARK: - Search bar methods
// Use "extension" to separate out bits of functionality inside the ViewController
extension ToDoListViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        // [cd] == case and diacritic insensitive
        // reference https://academy.realm.io/posts/nspredicate-cheatsheet/
        // reference http://nshipster.com/nspredicate/
        let itemsPredicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)

        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItemsFromDatabase(with: request, predicate: itemsPredicate)
    }

    // When user cancels search
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItemsFromDatabase()
            
            DispatchQueue.main.async { // Engage the main thread (UI)
                searchBar.resignFirstResponder() // Dismiss keyboard
            }
        }
    }
}
