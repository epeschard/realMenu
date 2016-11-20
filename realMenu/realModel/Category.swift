//
//  Category.swift
//  Menuz
//
//  Created by Eugène Peschard on 18/08/16.
//  Copyright © 2016 Peschapps. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class Category: Object {
    
    dynamic var id = ""
    dynamic var name = ""
    dynamic var pluralName = ""
    dynamic var shortName = ""
    dynamic var icon: Icon? = nil
    let primary = RealmOptional<Bool>() //TODO: Check type
    let categories = List<Category>()
    
    // Specify properties to ignore (Realm won't persist these)
    
    //  override static func ignoredProperties() -> [String] {
    //    return []
    //  }
    
    override class func primaryKey() -> String? { return "id" }
}