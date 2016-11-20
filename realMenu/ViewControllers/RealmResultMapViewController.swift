//
//  RealmResultMapViewController.swift
//  realMenu
//
//  Created by Eugène Peschard on 20/11/2016.
//  Copyright © 2016 Nissan. All rights reserved.
//

import UIKit
import MapKit
import RealmSwift
import CoreLocation


class RealmResultMapViewController: UIViewController,
CLLocationManagerDelegate {
    
    typealias Entity = Venue
    
    // MARK: - Instance Variables
    var searchString = ""
    var searchResults = try! Realm().objects(Entity) {
        willSet {
            locations = Array(newValue)
        }
    }
    var locations = [Entity]() {
        willSet {
            updateLocations()
        }
    }
    
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    
    // MARK: Initialization
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        commonInit()
    }
    
    private func commonInit() {
        locationManager.delegate = self
    }
    
    // MARK: - Run Loop
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
//        mapView.showsUserLocation = true
    }
    
//    @IBAction func showUser() {
//        let region = MKCoordinateRegionMakeWithDistance(
//            mapView.userLocation.coordinate, 1000, 1000)
//        mapView.setRegion(mapView.regionThatFits(region), animated: true)
//    }
//    
//    @IBAction func showLocations() {
//        let theRegion = region(for: locations)
//        mapView.setRegion(theRegion, animated: true)
//    }
    
    func updateLocations() {
        mapView.removeAnnotations(mapView.annotations)
        
        for location in searchResults {
            mapView.addAnnotation(location)
        }
        mapView.showAnnotations(locations, animated: true)
    }
    
    func showLocationDetails(sender: UIButton) {
        performSegueWithIdentifier("EditLocation", sender: sender)
    }
    
}

extension RealmResultMapViewController: MKMapViewDelegate {
    func mapView(mapView: MKMapView,
                 viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard annotation is Location else {
            return nil
        }
        
        let identifier = "Location"
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
        if annotationView == nil {
            let pinView = MKPinAnnotationView(annotation: annotation,
                                              reuseIdentifier: identifier)
                pinView.enabled = true
                pinView.canShowCallout = true
                pinView.animatesDrop = false
                pinView.pinTintColor = UIColor(red: 0.32, green: 0.82,
                                               blue: 0.4, alpha: 1)
                pinView.tintColor = UIColor(white: 0.0, alpha: 0.5)
            
            let rightButton = UIButton(type: .DetailDisclosure)
                rightButton.addTarget(self,
                                      action: #selector(showLocationDetails),
                                      forControlEvents: .TouchUpInside)
            pinView.rightCalloutAccessoryView = rightButton
            
            annotationView = pinView
        }
        
        if let annotationView = annotationView {
            annotationView.annotation = annotation
            
            let button = annotationView.rightCalloutAccessoryView as! UIButton
            if let index = locations.indexOf(annotation as! Entity) {
                button.tag = index
            }
        }
        
        return annotationView
    }
}
