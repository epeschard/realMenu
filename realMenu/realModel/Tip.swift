//
//  Tip.swift
//  Menuz
//
//  Created by Eugène Peschard on 18/08/16.
//  Copyright © 2016 Peschapps. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class Tip: Object {
    
    dynamic var id = ""
    dynamic var text = ""
    dynamic var createdAt = 0
    
    dynamic var url: String? = nil
    dynamic var photo: Photo? = nil
    dynamic var user: User? = nil
    dynamic var venue: Venue? = nil
//    dynamic var todo
//    dynamic var likes
    
    // Specify properties to ignore (Realm won't persist these)
    
    //  override static func ignoredProperties() -> [String] {
    //    return []
    //  }
    
    override class func primaryKey() -> String? { return "id" }
}