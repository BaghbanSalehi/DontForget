//
//  Category.swift
//  DontForget
//
//  Created by Shayan on 2/25/19.
//  Copyright © 2019 Game4Life. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    
    @objc dynamic var name : String = ""
    let items = List<Item>() // sakht relationship 1:n
    
    
    
    
    
}
