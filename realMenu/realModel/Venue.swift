//
//  Venue.swift
//  Menuz
//
//  Created by Eugène Peschard on 20/07/16.
//  Copyright © 2016 Peschapps. All rights reserved.
//

import Foundation
import RealmSwift
//import Realm

class Venue: Object {
    
    dynamic var id = ""
    dynamic var name = ""
    dynamic var verified = false
    
    dynamic var url: String? // optional
    dynamic var referralId: String? // optional
    
    let allowMenuUrlEdit = RealmOptional<Bool>()
    let hasPerk = RealmOptional<Bool>()
    let hasMenu = RealmOptional<Bool>()
    let rating = RealmOptional<Int>()
    
    dynamic var contact: Contact? = nil
    dynamic var location: Location? = nil
    let categories = List<Category>()
    dynamic var stats: Stats? = nil
//    dynamic var hours: Hours? = nil
//    dynamic var popular: Popopular? = nil
//    dynamic var tags: Array<String> = [""]
//    let beenHere = RealmOptional<Int>()
//    dynamic var beenHere: Int? = nil
//    dynamic var shortUrl = ""
//    dynamic var canonicalUrl = ""    
//    dynamic var menu
//    dynamic var price
//    dynamic var specials
//    dynamic var hereNow
//    dynamic var storeId
//    dynamic var description
//    dynamic var createdAt
//    dynamic var mayor
//    dynamic var tips
//    dynamic var listed

//    dynamic var specialsNearby
//    dynamic var photos
//    dynamic var likes
//    dynamic var like
//    dynamic var dislike
//    dynamic var phrases
//    dynamic var attributes
//    dynamic var roles
//    dynamic var flags
//    dynamic var page
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
    
    override class func primaryKey() -> String? { return "id" }
}
