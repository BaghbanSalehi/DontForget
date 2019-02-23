//
//  CategoryTableViewController.swift
//  DontForget
//
//  Created by Shayan on 2/20/19.
//  Copyright © 2019 Game4Life. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
    var categories = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()

        
    }
    
    //-MARK: TableView
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return categories.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        return cell
    }
    //MARK: Tb Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! MainTableViewController
        // be dast avordan row ke click shode , momkene nil bashe...
        if let indexpath = tableView.indexPathForSelectedRow {
        destinationVC.selectedCategory = categories[indexpath.row]
        }
    }
    
    
    
    //-MARK: Data Manipulation
   func saveCategories()
    {
        do{
        try context.save()
        }catch{
            print("error saving categories : \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories()
    {
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        do
        {
           categories = try context.fetch(request)
            
        }catch{
            print("error loading categories : \(error)")
        }
        tableView.reloadData()
        
    }
    
    //-MARK: Add new category
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            self.categories.append(newCategory)
            self.saveCategories()
        }
        alert.addAction(action)
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new category"
        }
        present(alert,animated: true,completion: nil)
        
    }
    
}