//
//  RealmSearchMapViewController.swift
//  realMenu
//
//  Created by Eugène Peschard on 20/11/2016.
//  Copyright © 2016 Nissan. All rights reserved.
//

import UIKit
import MapKit
import RealmSwift
import CoreLocation


class RealmSearchMapViewController: UIViewController,
    UISearchControllerDelegate,
    UISearchBarDelegate,
    CLLocationManagerDelegate {
    
    typealias Entity = Venue
    typealias ResultMap = RealmResultMapViewController
    
    
    // MARK: - Instance Variables
    let searchKeyPaths = ["name"]
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
    var searchController: UISearchController!
    var resultsMapViewController: ResultMap?
    
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
        mapView.showsUserLocation = true
        let userBB = MKUserTrackingBarButtonItem(mapView: self.mapView)
        let locsBB = UIBarButtonItem.init(barButtonSystemItem: .Refresh, target: self, action: #selector(MapViewController.updateLocations))
        self.navigationItem.rightBarButtonItems = [
            userBB,
            locsBB
        ]
        
        // Set SearchController
        resultsMapViewController = ResultMap()
        setupSearchControllerWith(resultsMapViewController!)
        searchController?.loadViewIfNeeded()
    }
    
    func updateLocations() {
        mapView.removeAnnotations(mapView.annotations)
        
        for location in objects {
            mapView.addAnnotation(location)
        }
//        mapView.showAnnotations(locations, animated: true)
        mapView.region = region(for: locations)
    }
    
    func region(for annotations: [MKAnnotation]) -> MKCoordinateRegion {
        let region: MKCoordinateRegion
        
        switch annotations.count {
        case 0:
            region = MKCoordinateRegionMakeWithDistance(
                mapView.userLocation.coordinate, 1000, 1000)
            
        case 1:
            let annotation = annotations[annotations.count - 1]
            region = MKCoordinateRegionMakeWithDistance(
                annotation.coordinate, 1000, 1000)
            
        default:
            var topLeftCoord = CLLocationCoordinate2D(latitude: -90,
                                                      longitude: 180)
            var bottomRightCoord = CLLocationCoordinate2D(latitude: 90,
                                                          longitude: -180)
            
            for annotation in annotations {
                topLeftCoord.latitude = max(topLeftCoord.latitude,
                                            annotation.coordinate.latitude)
                topLeftCoord.longitude = min(topLeftCoord.longitude,
                                             annotation.coordinate.longitude)
                bottomRightCoord.latitude = min(bottomRightCoord.latitude,
                                                annotation.coordinate.latitude)
                bottomRightCoord.longitude = max(bottomRightCoord.longitude,
                                                 annotation.coordinate.longitude)
            }
            
            let center = CLLocationCoordinate2D(
                latitude: topLeftCoord.latitude -
                    (topLeftCoord.latitude - bottomRightCoord.latitude) / 2,
                longitude: topLeftCoord.longitude -
                    (topLeftCoord.longitude - bottomRightCoord.longitude) / 2)
            
            let extraSpace = 1.1
            let span = MKCoordinateSpan(
                latitudeDelta: abs(topLeftCoord.latitude -
                    bottomRightCoord.latitude) * extraSpace,
                longitudeDelta: abs(topLeftCoord.longitude -
                    bottomRightCoord.longitude) * extraSpace)
            
            region = MKCoordinateRegion(center: center, span: span)
        }
        
        return mapView.regionThatFits(region)
    }
    
    func showLocationDetails(sender: UIButton) {
        performSegueWithIdentifier("EditLocation", sender: sender)
    }
    
    func setupSearchControllerWith(resultsMapViewController: ResultMap) {
        // We want to be the delegate for our filtered table so didSelectRowAtIndexPath(_:) is called for both tables.
        resultsMapViewController.mapView = mapView
        
        searchController = UISearchController(searchResultsController: resultsMapViewController)
        
        // Set Search Bar
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        navigationItem.titleView = searchController.searchBar
        
        // Set delegates
        searchController.delegate = self
        searchController.searchBar.delegate = self    // so we can monitor text changes + others
        
        // Configure Interface
        searchController.dimsBackgroundDuringPresentation = false
        
        // Search is now just presenting a view controller. As such, normal view controller
        // presentation semantics apply. Namely that presentation will walk up the view controller
        // hierarchy until it finds the root view controller or one that defines a presentation context.
        definesPresentationContext = true
    }
    
}

extension RealmSearchMapViewController: MKMapViewDelegate {
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

// MARK: - Search Results Updating Delegate
extension RealmSearchMapViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        // Strip out all the leading and trailing spaces.
        let whitespaceCharacterSet = NSCharacterSet.whitespaceCharacterSet()
        let strippedString = searchController.searchBar.text!.stringByTrimmingCharactersInSet(whitespaceCharacterSet)
        let searchItems = strippedString.componentsSeparatedByString(" ") as [String]
        
        // Build all the "OR" expressions for each value in the searchString.
        var orMatchPredicates = [NSPredicate]()
        
        for searchString in searchItems {
            var searchItemsPredicate = [NSPredicate]()
            if searchString != "" {
                // Name field matching
                for searchKeyPath in searchKeyPaths {
                    let lhs = NSExpression(forKeyPath: searchKeyPath)
                    let rhs = NSExpression(forConstantValue: searchString)
                    let finalPredicate = NSComparisonPredicate(
                        leftExpression: lhs,
                        rightExpression: rhs,
                        modifier: .DirectPredicateModifier,
                        type: .ContainsPredicateOperatorType,
                        options: .CaseInsensitivePredicateOption)
                    searchItemsPredicate.append(finalPredicate)
                }
            }
            // Add this OR predicate to our master predicate.
            let orSearchItemsPredicates = NSCompoundPredicate(orPredicateWithSubpredicates: searchItemsPredicate)
            orMatchPredicates.append(orSearchItemsPredicates)
        }
        
        // Match up the fields of the Product object.
        let finalCompoundPredicate = NSCompoundPredicate(orPredicateWithSubpredicates:orMatchPredicates)
        
        let resultsController = searchController.searchResultsController as! ResultMap
            resultsController.searchString = searchController.searchBar.text!
            resultsController.searchResults = objects.filter(finalCompoundPredicate)
    }
}

// MARK: SearchController
