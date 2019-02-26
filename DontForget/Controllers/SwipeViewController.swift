//
//  SwipeViewController.swift
//  DontForget
//
//  Created by Shayan on 2/26/19.
//  Copyright © 2019 Game4Life. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeViewController: UITableViewController,SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()


    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        return cell
    }


   // in coda nemune bardari shode az swipecellkit hast bekhuni malome che khabare
func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
            guard orientation == .right else { return nil } // swipe az rast anjam she
            
            let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
//vaghty delete zade shod chi beshe
                self.updateModel(at: indexPath)
                
                
            }
            
            // customize the action appearance
            deleteAction.image = UIImage(named: "delete")
            
            return [deleteAction]
        }
//bara ine ke swipe tolani keshidi ham amaliat anjam she inja pak kardane vase .destructive demo hash toye site hast
        func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
            var options = SwipeOptions()
            options.expansionStyle = .destructive
            return options
        }
    
    //gereftan data az subclass , dakhel subclass meghdar override sh mikonim
    func updateModel (at indexPath : IndexPath)
    {
        //data update
        
    }
    

}
