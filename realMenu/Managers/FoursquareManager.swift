//
//  FoursquareManager.swift
//  Blind Date
//
//  Created by Eugène Peschard on 02/07/16.
//  Copyright © 2016 Peschapps. All rights reserved.
//

import Foundation
import CoreLocation

enum Intent {
    case checkin
    case browse
    case global
    case match
}

struct Foursquare {
    static let client_id = "CHW1G522MJ2ZWGM0XWVSSC4NQGUCWYTNBVMTAZH00ZKAL33Z"
    static let client_secret = "YKFLN0TUEGPRLLD4WSJWHMP05KP4LVBK3D1UPNWITRKMGO4C"
    static let v = "20160703"
}

func buildURL(venuID:String) -> NSURL? {
    let urlComponents = NSURLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = "api.foursquare.com"
    urlComponents.path = "/v2/venues/\(venuID)/menu"
    
    let client_id = NSURLQueryItem(name: "client_id", value: Foursquare.client_id)
    let client_secret = NSURLQueryItem(name: "client_secret", value: Foursquare.client_secret)
    let v = NSURLQueryItem(name: "v", value: Foursquare.v)
    
    // https://developer.foursquare.com/docs/venues/search
    let queryItems = [client_id, client_secret, v]
    urlComponents.queryItems = queryItems
    
    return urlComponents.URL
}

func buildURL(location: CLLocation?, near: String?, query: String?, limit: Int?, intent: Intent) -> NSURL? {
    let urlComponents = NSURLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.foursquare.com"
        urlComponents.path = "/v2/venues/search"
    
    let client_id = NSURLQueryItem(name: "client_id", value: Foursquare.client_id)
    let client_secret = NSURLQueryItem(name: "client_secret", value: Foursquare.client_secret)
    let v = NSURLQueryItem(name: "v", value: Foursquare.v)
    
    // https://developer.foursquare.com/docs/venues/search
    var queryItems = [client_id, client_secret, v]
    
    if let ll = location {
        // reuired unless near is provided
        let lat = ll.coordinate.latitude
        let lon = ll .coordinate.longitude
        let llQuery = NSURLQueryItem(name: "ll", value: "\(lat),\(lon)")
        queryItems.append(llQuery)
        
        let llAcc = ll.horizontalAccuracy
        let llAccQuery = NSURLQueryItem(name: "llAcc", value: "\(llAcc)")
        queryItems.append(llAccQuery)
        
        let alt = ll.altitude
        let altQuery = NSURLQueryItem(name: "alt", value: "\(alt)")
        queryItems.append(altQuery)
        
        let altAcc = ll.verticalAccuracy
        let altAccQuery = NSURLQueryItem(name: "altAcc", value: "\(altAcc)")
        queryItems.append(altAccQuery)
    } else if let geocode = near {
        // required unless ll is provided
        let nearQuery = NSURLQueryItem(name: "near", value: geocode)
        queryItems.append(nearQuery)
    } else {
        //TODO: change for current location's best approximate
        
        let noLocQuery = NSURLQueryItem(name: "near", value: "Chicago, IL")
        queryItems.append(noLocQuery)
    }
//    let llAccQuery = NSURLQueryItem(name: "llAcc", value: "")
//    let altQuery = NSURLQueryItem(name: "alt", value: "")
//    let altAccQuery = NSURLQueryItem(name: "altAcc", value: "")
    if let search = query {
        let searchQuery = NSURLQueryItem(name: "query", value: search)
        queryItems.append(searchQuery)
    }
    if var max = limit {
        if max > 50 {
            max = 50
        }
        let limitQuery = NSURLQueryItem(name: "limit", value: "\(max)")
        queryItems.append(limitQuery)
    }
    switch intent {
    case .checkin:
        let intentQuery = NSURLQueryItem(name: "intent", value: "checkin")
        queryItems.append(intentQuery)
    case .global:
        let intentQuery = NSURLQueryItem(name: "intent", value: "global")
        queryItems.append(intentQuery)
    case .match:
        let intentQuery = NSURLQueryItem(name: "intent", value: "match")
        queryItems.append(intentQuery)
    case .browse:
        let intentQuery = NSURLQueryItem(name: "intent", value: "browse")
        queryItems.append(intentQuery)
//    default:
//        let intentQuery = URLQueryItem(name: "intent", value: "checkin")
//        queryItems.append(intentQuery)
    }
//    let radiusQuery = URLQueryItem(name: "radius", value: "")
//    let swQuery = URLQueryItem(name: "sw", value: "")
//    let neQuery = URLQueryItem(name: "ne", value: "")
//    
//    let categoryIdQuery = URLQueryItem(name: "categoryId", value: "")
//    let urlQuery = URLQueryItem(name: "url", value: "")
//    let providerIdQuery = URLQueryItem(name: "providerId", value: "")
//    let linkedIdQuery = URLQueryItem(name: "linkedId", value: "")
    
    urlComponents.queryItems = queryItems
    return urlComponents.URL
}


