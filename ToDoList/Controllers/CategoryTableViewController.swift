//
//  CategoryTableViewController.swift
//  ToDoList
//
//  Created by Kean Chin on 1/16/18.
//  Copyright © 2018 Kean Chin. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {

    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        loadCategoriesFromDatabase()
    }

    // MARK: - TableView Datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationViewController.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    // MARK: - Data manipulation methods

    func saveItemsToDatabase() {
        do {
            try context.save()
        } catch {
            print("Error saving Category context \(error)")
        }
    }
    
    func loadCategoriesFromDatabase(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        // Item.fetchRequest() is default value if one is not provided
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error fetching categories from context \(error)")
        }
        
        tableView.reloadData()
    }

    // MARK: - Add New Category
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var newCategoryTextField = UITextField()
        
        let alertController = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Add Category", style: .default) { (uiAlertAction) in
            
            let newCategory = Category(context: self.context)
            newCategory.name = newCategoryTextField.text ?? ""
            // Must use the "self" keyword in a closure
            self.categoryArray.append(newCategory)
            self.tableView.reloadData()
            self.saveItemsToDatabase()
        }
        
        alertController.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter new category"
            newCategoryTextField = alertTextField
        }
        
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - TableView Delegate methods
    
}
