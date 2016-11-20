//
//  MapViewController.swift
//  realMenu
//
//  Created by Eugène Peschard on 02/10/2016.
//  Copyright © 2016 Nissan. All rights reserved.
//

import UIKit
import MapKit
import RealmSwift
import CoreLocation

class MapViewController: UIViewController,
    CLLocationManagerDelegate {
    
    typealias Entity = Venue

    // MARK: - Instance Variables
    var objects = try! Realm().objects(Entity) {
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
        
        updateLocations()
//
//        if !objects.isEmpty {
//            showLocations()
//        }
        let userBB = MKUserTrackingBarButtonItem(mapView: self.mapView)
        let locsBB = UIBarButtonItem.init(barButtonSystemItem: .Refresh, target: self, action: #selector(MapViewController.updateLocations))
        self.navigationItem.rightBarButtonItems = [
            userBB,
            locsBB
        ]
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        updateLocations()
        mapView.showsUserLocation = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.mapView.showsUserLocation = false
    }

    
    func updateLocations() {
        mapView.removeAnnotations(mapView.annotations)
        
        for location in objects {
            mapView.addAnnotation(location)
        }
        mapView.showAnnotations(locations, animated: true)
    }

//    func region(for annotations: [MKAnnotation]) -> MKCoordinateRegion {
//        let region: MKCoordinateRegion
//        
//        switch annotations.count {
//        case 0:
//            region = MKCoordinateRegionMakeWithDistance(
//                mapView.userLocation.coordinate, 1000, 1000)
//            
//        case 1:
//            let annotation = annotations[annotations.count - 1]
//            region = MKCoordinateRegionMakeWithDistance(
//                annotation.coordinate, 1000, 1000)
//            
//        default:
//            var topLeftCoord = CLLocationCoordinate2D(latitude: -90,
//                                                      longitude: 180)
//            var bottomRightCoord = CLLocationCoordinate2D(latitude: 90,
//                                                          longitude: -180)
//            
//            for annotation in annotations {
//                topLeftCoord.latitude = max(topLeftCoord.latitude,
//                                            annotation.coordinate.latitude)
//                topLeftCoord.longitude = min(topLeftCoord.longitude,
//                                             annotation.coordinate.longitude)
//                bottomRightCoord.latitude = min(bottomRightCoord.latitude,
//                                                annotation.coordinate.latitude)
//                bottomRightCoord.longitude = max(bottomRightCoord.longitude,
//                                                 annotation.coordinate.longitude)
//            }
//            
//            let center = CLLocationCoordinate2D(
//                latitude: topLeftCoord.latitude -
//                    (topLeftCoord.latitude - bottomRightCoord.latitude) / 2,
//                longitude: topLeftCoord.longitude -
//                    (topLeftCoord.longitude - bottomRightCoord.longitude) / 2)
//            
//            let extraSpace = 1.1
//            let span = MKCoordinateSpan(
//                latitudeDelta: abs(topLeftCoord.latitude -
//                    bottomRightCoord.latitude) * extraSpace,
//                longitudeDelta: abs(topLeftCoord.longitude -
//                    bottomRightCoord.longitude) * extraSpace)
//            
//            region = MKCoordinateRegion(center: center, span: span)
//        }
//        
//        return mapView.regionThatFits(region)
//    }
    
    func showLocationDetails(sender: UIButton) {
        performSegueWithIdentifier("EditLocation", sender: sender)
    }

}

extension MapViewController: MKMapViewDelegate {
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
            
            
//            let leftButtonImage = UIImage(named: "add32")!
//            let leftButton = UIButton(type: .Custom)
//                leftButton.frame = CGRectMake(10.0, 10.0, 32.0, 32.0)
//                leftButton.tag = 0
//                leftButton.setImage(leftButtonImage,
//                                    forState: UIControlState.Normal)
            
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
