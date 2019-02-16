//
//  ViewController.swift
//  DontForget
//
//  Created by Shayan on 2/12/19.
//  Copyright © 2019 Game4Life. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {
    
    var itemArray = [Item]()
    // zakhire kardan data dar device mahal e documents ro midim va plist o misazim
    let dataFilePth = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
     
        
    
    }
    
    
    //MARK - Tableview DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:  "ToDoItemCell" , for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none // value = condition ? valueIfTrue : valueIfFlase
        
        return cell
    }
    
    //MARK - TableView Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveData()
        
    
    
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    //MARK - add new items
    
    @IBAction func addItemPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction (title: "Add Item", style: .default) { (action) in
            
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            self.saveData()

        }
        alert.addTextField { (alertText) in
            alertText.placeholder = "Create New Item"
            textField = alertText
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        
    }
    
    //MARK - Model Manupulation Methods
    
    func saveData()
    {
        let encoder = PropertyListEncoder()
        do{
        let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePth!)
        }catch{
            print("error saving data : \(error) ")
        }
        tableView.reloadData()
    }
    func loadData()
    {
        if let data = try? Data(contentsOf: dataFilePth!){
            
            let decoder = PropertyListDecoder()
            do{
            itemArray = try decoder.decode([Item].self, from: data)
            }catch{
                print("loading data failed : \(error)")
            }
            
        }
    }
    
}

