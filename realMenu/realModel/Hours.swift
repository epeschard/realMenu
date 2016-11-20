//
//  Hours.swift
//  Menuz
//
//  Created by Eugène Peschard on 18/08/16.
//  Copyright © 2016 Peschapps. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class Hours: Object {
    
    dynamic var status = ""
    dynamic var isOpen = false
    
    
    // Specify properties to ignore (Realm won't persist these)
    
    //  override static func ignoredProperties() -> [String] {
    //    return []
    //  }
}