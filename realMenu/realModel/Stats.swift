//
//  Stats.swift
//  realMenu
//
//  Created by Eugène Peschard on 24/08/16.
//  Copyright © 2016 Peschapps. All rights reserved.
//

import Foundation
import RealmSwift

class Stats: Object {
    
    let checkinsCount = RealmOptional<Int>()
    let tipCount = RealmOptional<Int>()
    let usersCount = RealmOptional<Int>()
    
//    dynamic var checkinsCount = ""
//    dynamic var tipCount = ""
//    dynamic var usersCount = ""

    
    // Specify properties to ignore (Realm won't persist these)
    
    //  override static func ignoredProperties() -> [String] {
    //    return []
    //  }
}