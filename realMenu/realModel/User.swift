//
//  User.swift
//  Menuz
//
//  Created by Eugène Peschard on 18/08/16.
//  Copyright © 2016 Peschapps. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class User: Object {
    
    dynamic var id = ""
    dynamic var firstName = ""
    dynamic var lastName = ""
    dynamic var photo: Photo? = nil
    dynamic var relationship: String? = nil // self, friend, pendingMe, pendingThem, FollowingThem
//    dynamic var friends
    dynamic var type: String? = nil //page, chain, celebrity, or venuePage
    dynamic var venue = "" // venueId
    dynamic var homeCity = ""
    dynamic var gender = "" //male, female, or none
    dynamic var contact: Contact? = nil
    dynamic var bio: String? = nil
//    dynamic var tips
//    dynamic var lists
//    dynamic var followers
//    dynamic var following
//    dynamic var mayorships
//    dynamic var photos
//    dynamic var scores
//    dynamic var checkins
//    dynamic var pageInfo
//    dynamic var pings
//    dynamic var requests
    
    // Specify properties to ignore (Realm won't persist these)
    
    //  override static func ignoredProperties() -> [String] {
    //    return []
    //  }
    
    override class func primaryKey() -> String? { return "id" }
}