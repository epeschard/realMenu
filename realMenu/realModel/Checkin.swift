//
//  Checkin.swift
//  Menuz
//
//  Created by Eugène Peschard on 18/08/16.
//  Copyright © 2016 Peschapps. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class Checkin: Object {
    
    dynamic var totalCheckins = 0
    dynamic var newCheckins = 0
    dynamic var uniqueVisitors = 0
//    dynamic var sharing = []
//    dynamic var genderBreakdown = []
//    dynamic var ageBreakdown = []
//    dynamic var hourBreakdown = []
//    dynamic var visitCountHistogram = []
//    dynamic var topVisitors = []
//    dynamic var recentVisitors = []
    
    // Specify properties to ignore (Realm won't persist these)
    
    //  override static func ignoredProperties() -> [String] {
    //    return []
    //  }
}