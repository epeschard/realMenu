//
//  Menu.swift
//  Menuz
//
//  Created by Eugène Peschard on 18/08/16.
//  Copyright © 2016 Peschapps. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class Menu: Object {
    
    dynamic var menuId = ""
    dynamic var name = ""
    dynamic var desc = ""
    let sections = List<Section>()
    
    dynamic var venue: Venue? = nil
    
    // Specify properties to ignore (Realm won't persist these)
    
    //  override static func ignoredProperties() -> [String] {
    //    return []
    //  }
    
    override class func primaryKey() -> String? { return "menuId" }
}
