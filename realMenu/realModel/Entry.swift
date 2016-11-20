//
//  Entry.swift
//  Menuz
//
//  Created by Eugène Peschard on 18/08/16.
//  Copyright © 2016 Peschapps. All rights reserved.
//

import Foundation
import RealmSwift
//import Realm

class Entry: Object {
    
    dynamic var entryId = ""
    dynamic var name = ""
    dynamic var desc = ""
//    dynamic var prices = []
    dynamic var price = 0.0
//    dynamic var options = []
//    dynamic var additions = []
    
    dynamic var section: Section? = nil
    
    // Specify properties to ignore (Realm won't persist these)
    
    //  override static func ignoredProperties() -> [String] {
    //    return []
    //  }
    
    override class func primaryKey() -> String? { return "entryId" }
}
