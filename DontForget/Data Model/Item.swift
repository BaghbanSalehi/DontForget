//
//  Item.swift
//  DontForget
//
//  Created by Shayan on 2/25/19.
//  Copyright © 2019 Game4Life. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object {
    
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items") // sakht rel
    
    
    
    
    
}
