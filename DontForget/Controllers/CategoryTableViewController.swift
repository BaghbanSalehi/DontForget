//
//  CategoryTableViewController.swift
//  DontForget
//
//  Created by Shayan on 2/20/19.
//  Copyright © 2019 Game4Life. All rights reserved.
//

import UIKit
import RealmSwift


class CategoryTableViewController: SwipeViewController {
    
    let realm = try! Realm()
    var categories : Results<Category>?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        tableView.rowHeight = 80

        
    }
    
    //MARK: - TableView
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return categories?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //sakht cell az superclass
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"
        return cell
    }
    //MARK: - Tb Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! MainTableViewController
        // be dast avordan row ke click shode , momkene nil bashe...
        if let indexpath = tableView.indexPathForSelectedRow {
        destinationVC.selectedCategory = categories?[indexpath.row]
        }
    }
    
    
    
    //MARK: - Data Manipulation
    func save(category : Category)
    {
        do{
            try realm.write {
                 realm.add(category)
            }
        }catch{
            print("error saving categories : \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories()
    {
        categories = realm.objects(Category.self)
        
    }
    // Delete Items inja por mishe dakhel superclass emun anjam mishe
    override func updateModel(at indexPath: IndexPath) {
    if let categoryDeletion = self.categories?[indexPath.row]{
    do{
    try self.realm.write {
    self.realm.delete(categoryDeletion)
    }
        
    }catch{
    print("error deleting")
    }
        
        
        
     }
    }
    
    //MARK: - Add new category
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            self.save(category: newCategory)
        }
        alert.addAction(action)
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new category"
        }
        present(alert,animated: true,completion: nil)
        
    }
    
}


