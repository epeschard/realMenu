//
//  Contact.swift
//  Menuz
//
//  Created by Eugène Peschard on 18/08/16.
//  Copyright © 2016 Peschapps. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class Contact: Object {
    
    dynamic var twitter: String? // optional
    dynamic var facebook: String? // optional
    dynamic var phone: String? // optional
    dynamic var formattedPhone: String? // optional
    dynamic var email: String? // optional
    
    // Specify properties to ignore (Realm won't persist these)
    
    //  override static func ignoredProperties() -> [String] {
    //    return []
    //  }
}