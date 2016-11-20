//
//  Icon.swift
//  realMenu
//
//  Created by Eugène Peschard on 24/08/16.
//  Copyright © 2016 Peschapps. All rights reserved.
//

import Foundation
import RealmSwift

class Icon: Object {
    
    dynamic var prefix = ""
    dynamic var suffix = ""
    
    // Specify properties to ignore (Realm won't persist these)
    
    //  override static func ignoredProperties() -> [String] {
    //    return []
    //  }
    
    override class func primaryKey() -> String? { return "prefix" }
}