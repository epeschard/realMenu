//
//  Location.swift
//  Menuz
//
//  Created by Eugène Peschard on 18/08/16.
//  Copyright © 2016 Peschapps. All rights reserved.
//

import Foundation
import RealmSwift
//import Realm

class Location: Object {
    
    dynamic var address: String? // optional
    dynamic var cc: String? // optional
    dynamic var city: String? // optional
    dynamic var country: String? // optional
    dynamic var crossStreet: String? // optional
    dynamic var postalCode: String? // optional
    dynamic var state: String? // optional
    
    dynamic var lat = 0.0
    dynamic var lng = 0.0
    dynamic var distance = 0
    
    // Specify properties to ignore (Realm won't persist these)
    
    //  override static func ignoredProperties() -> [String] {
    //    return []
    //  }
}