//
//  Venue+MKAnnotation.swift
//  realMenu
//
//  Created by Eugène Peschard on 02/10/2016.
//  Copyright © 2016 Nissan. All rights reserved.
//

import MapKit

extension Venue: MKAnnotation {
    
    var title: String? {
        return name
    }
    
    var subtitle: String? {
        return url
    }
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(latitude, longitude)
    }
    
    var latitude: Double {
        return (location?.lat)!
    }
    
    var longitude: Double {
        return (location?.lng)!
    }
    
    var imageURL: NSURL? {
        if let icon = categories.first?.icon {
            return NSURL(string: "\(icon.prefix)44\(icon.suffix)")
        } else {
            return nil
        }
    }
    
//    var image: UIImage? {
//        // Construct image from icon prefix & suffix
//        if let icon = categories.first?.icon,
//            let imageURL = NSURL(string: "\(icon.prefix)44\(icon.suffix)") {
//            
//            let qualityOfServiceClass = QOS_CLASS_USER_INTERACTIVE
//            let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
//            dispatch_async(backgroundQueue) {
////                [weak weakSelf = self] in
//                // Executing in different thread
//                if let imageData = NSData(contentsOfURL: imageURL) {
//                    dispatch_async(dispatch_get_main_queue()) {
//                        //Back in main thread
//                        return UIImage(data: imageData)
//                    }
//                } else {
//                    print("error getting image for \(imageURL)")
//                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                        //Back in main thread
//                        return UIImage(named: "Foursquare")
//                    })
//                }
//            }
//        } else {
//            return UIImage(named: "Foursquare")
//        }
//    }
    
}
