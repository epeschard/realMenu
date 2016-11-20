//
//  Photo.swift
//  Menuz
//
//  Created by Eugène Peschard on 18/08/16.
//  Copyright © 2016 Peschapps. All rights reserved.
//

import Foundation
import RealmSwift

class Photo: Object {
    
    dynamic var id = ""
    dynamic var createdAt = 0
    dynamic var prefix = ""
    dynamic var suffix = ""
    dynamic var visibility = "" //public, friends or private
    dynamic var source = "" // String or Array?
    dynamic var user: User? = nil
    dynamic var venue: Venue? = nil
    dynamic var tip: Tip? = nil
    dynamic var checkin: Checkin? = nil
    
    
    // Specify properties to ignore (Realm won't persist these)
    
    //  override static func ignoredProperties() -> [String] {
    //    return []
    //  }
    
    override class func primaryKey() -> String? { return "id" }
}
