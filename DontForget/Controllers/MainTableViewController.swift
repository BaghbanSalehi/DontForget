//
//  ViewController.swift
//  DontForget
//
//  Created by Shayan on 2/12/19.
//  Copyright © 2019 Game4Life. All rights reserved.
//

import UIKit
import CoreData

class MainTableViewController: UITableViewController {
    var selectedCategory : Category? {
        didSet{
            loadData()
        }
    }
    var itemArray = [Item]()
    // zakhire kardan data dar device mahal e documents ro midim va plist o misazim
   // let dataFilePth = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    // sakhtan ye context be surate object az appdelegate 
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
     
        
    
    }
    
    
    //MARK: - Tableview DataSource Methods
    
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
    
    //MARK: - TableView Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveData()
        
    
    
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    //MARK: - add new items
    
    @IBAction func addItemPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction (title: "Add Item", style: .default) { (action) in
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory // taen relation ship itemjadid ba category ke umade
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
    
    //MARK: - Model Manupulation Methods
    
    func saveData()
    {
        do{
            try context.save()

        }catch{
            print("error saving context : \(error) ")
        }
        tableView.reloadData()
    }
    
    func loadData(with request : NSFetchRequest<Item> = Item.fetchRequest(),predicate : NSPredicate? = nil)
    {
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        // bara inke predicate ha ro ham neveshte nashe az compundpredicate use kardim ta predicate category az search joda she
//        let compundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,predicate])
//        request.predicate = compundPredicate
        // vase inke loadData() bedune vorody predicate farakhani she predicate ro optional nil kardim bara safe sazi :
        if let additionalPredicate = predicate {
            
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,additionalPredicate])
        }else{
            request.predicate = categoryPredicate
        }// age predicate az searchbar umade bud compund predicate ba category o search bar age na faghat categorypredicate
        
        
        do
        {
            itemArray = try context.fetch(request) // zakhire javabe darkhast fetch tavasote context dakhel arayamun
        }catch
        {
            print("fetch faild : \(error)")
        }
        tableView.reloadData()
        
    }
    
}

//MARK: - Search Bar Methedos
extension MainTableViewController : UISearchBarDelegate
{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS [cd] %@", searchBar.text!)//moghayese dade ke az db umade ba chizi ke user zade
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]//sort kardan natije dastan,araye pazire faghat in
        loadData(with : request,predicate: predicate)
        
        
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

