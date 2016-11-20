//
//  Section.swift
//  Menuz
//
//  Created by Eugène Peschard on 18/08/16.
//  Copyright © 2016 Peschapps. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class Section: Object {
    
    dynamic var sectionId = ""
    dynamic var name = ""
    let entries = List<Entry>()
    
    dynamic var menu: Menu? = nil
    
    // Specify properties to ignore (Realm won't persist these)
    
    //  override static func ignoredProperties() -> [String] {
    //    return []
    //  }
    
    override class func primaryKey() -> String? { return "sectionId" }
}
