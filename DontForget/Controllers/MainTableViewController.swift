//
//  ViewController.swift
//  DontForget
//
//  Created by Shayan on 2/12/19.
//  Copyright © 2019 Game4Life. All rights reserved.
//

import UIKit
import RealmSwift

class MainTableViewController: SwipeViewController {
    let realm = try! Realm()
    var selectedCategory : Category? {
        didSet{
            loadData()
        }
    }
    var todoItems : Results<Item>?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80
     
        
    
    }
    
    
    //MARK: - Tableview DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        // age todoItems nil nabud va kole dastan nil nabud
        if let item = todoItems?[indexPath.row] {
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none // value = condition ? valueIfTrue : valueIfFlase
        }
        else
        {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    //MARK: - TableView Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            
            do{
                try realm.write {
                    item.done = !item.done
                }
                
            }catch{
                print("error updating data \(error)")
            }
        }
        tableView.reloadData()
        

    
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    //MARK: - add new items
    
    @IBAction func addItemPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction (title: "Add Item", style: .default) { (action) in
        
            if let currentCategory = self.selectedCategory
            {
                do{
                    try self.realm.write {
                        
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem) // taen relation ship itemjadid ba category ke umade
                    }
            
                }catch{
                    print("error saving items \(error)")
                }
                self.tableView.reloadData()
            }
            
          
            

        }
        alert.addTextField { (alertText) in
            alertText.placeholder = "Create New Item"
            textField = alertText
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        
    }
    
    //MARK: - Model Manupulation Methods
    
    
    
    func loadData()
    {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
        
    }
    
    // Delete Items inja por mishe dakhel superclass emun anjam mishe
    override func updateModel(at indexPath: IndexPath) {
        if let categoryDeletion = self.todoItems?[indexPath.row]{
            do{
                try self.realm.write {
                    self.realm.delete(categoryDeletion)
                }
                
            }catch{
                print("error deleting")
            }
            
            
            
        }
    }
}

//MARK: - Search Bar Methedos
extension MainTableViewController : UISearchBarDelegate
{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // peyda kardan va sort kardan item zade shode
        todoItems = todoItems?.filter("title CONTAINS[cd] %@",searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
        
    }
    // in tabe vaghty ke dakhel searchbar yek kalame ezafe ya kam she
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0
        {
            loadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder() // az olaviat bardashte mishe searchbar 
            }
        }
        
    }
    
    
}




