//
//  VenueTable.swift
//  realMenu
//
//  Created by Eugène Peschard on 19/08/16.
//  Copyright © 2016 Peschapps. All rights reserved.
//

import UIKit
import RealmSwift
import CoreLocation

class VenueSearch: UITableViewController,
    UISearchControllerDelegate,
    UISearchResultsUpdating,
    UISearchBarDelegate,
    CLLocationManagerDelegate {
    
    typealias Entity = Venue
    typealias TableCell = VenueCell
    typealias ResultVC = VenueResult
    typealias DetailVC = VenueDetail
    typealias MapVC = RealmSearchMapViewController
    
    let cellHeight = CGFloat(63.0)
    let searchKeyPaths = ["name"]
    
    // MARK: - Instance Variables
    var objects = try! Realm().objects(Entity) {
        didSet {
            tableView.reloadData()
        }
    }
    var detailViewController: DetailVC? = nil
    var searchController: UISearchController!
    var resultsTableViewController: ResultVC?
    
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
        
        tableView.registerClass(TableCell.self, forCellReuseIdentifier: "\(TableCell.self)")
        tableView.registerNib(UINib(nibName: "\(TableCell.self)", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "\(TableCell.self)")
        
        // Table Variable Row Heights
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = cellHeight
        
        // Set dark theme
        tableView.backgroundView = nil
        tableView.backgroundColor = UIColor.blackColor()
        
        // Set SearchController
        resultsTableViewController = ResultVC()
        setupSearchControllerWith(resultsTableViewController!)
        searchController?.loadViewIfNeeded()
        
        triggerLocationServices()
//        checkLocationAuthorization()
        
        // Print Realm file location
        print(Realm.Configuration.defaultConfiguration.fileURL)
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell =
            tableView.dequeueReusableCellWithIdentifier(
                "\(TableCell.self)", forIndexPath: indexPath) as! TableCell
            cell.backgroundColor = UIColor.blackColor()
            cell.object = objects[indexPath.row]
        
        return cell
    }
    
    override func tableView(tableView: UITableView,
                            didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if tableView == resultsTableViewController?.tableView {
            performSegueWithIdentifier("showDetail", sender: resultsTableViewController!.searchResults[indexPath.row])
        } else {
            performSegueWithIdentifier("showDetail", sender: objects[indexPath.row])
        }
    }
    
    // MARK: - UISearchResultsUpdating
    
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
        
        let resultsController = searchController.searchResultsController as! ResultVC
            resultsController.searchString = searchController.searchBar.text!
            resultsController.searchResults = objects.filter(finalCompoundPredicate)
    }
    
    func setupSearchControllerWith(resultsTableViewController: ResultVC) {
        // Register Cells
        resultsTableViewController.tableView.registerClass(TableCell.self, forCellReuseIdentifier: "\(TableCell.self)")
        resultsTableViewController.tableView.registerNib(UINib(nibName: "\(TableCell.self)", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "\(TableCell.self)")
        
        // Cell Height
        resultsTableViewController.tableView.rowHeight = UITableViewAutomaticDimension
        resultsTableViewController.tableView.estimatedRowHeight = cellHeight
//        resultsTableViewController.textForEmptyLabel = "No restaurants found..."
        
        // We want to be the delegate for our filtered table so didSelectRowAtIndexPath(_:) is called for both tables.
        resultsTableViewController.tableView.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsTableViewController)
        
        // Set Search Bar
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        tableView.tableHeaderView = searchController.searchBar
        
        // Set delegates
        searchController.delegate = self
        searchController.searchBar.delegate = self    // so we can monitor text changes + others
        
        // Configure Interface
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = true
        if #available(iOS 9.1, *) {
            searchController.obscuresBackgroundDuringPresentation = false
        }
        searchController.searchBar.translucent = true
        searchController.searchBar.backgroundImage = UIImage()
        searchController.searchBar.barTintColor = UIColor.blackColor()
        
        // Set Scope Bar Buttons
        searchController.searchBar.scopeButtonTitles = ["Name", "website", "all"]
        
        // Search is now just presenting a view controller. As such, normal view controller
        // presentation semantics apply. Namely that presentation will walk up the view controller
        // hierarchy until it finds the root view controller or one that defines a presentation context.
        definesPresentationContext = true
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func triggerLocationServices() {
        //        locationManager.delegate = self
        if CLLocationManager.locationServicesEnabled() {
            if locationManager.respondsToSelector(#selector(CLLocationManager.requestWhenInUseAuthorization)) {
                locationManager.requestWhenInUseAuthorization()
                //
                print("requestWhenInUseAuthorization")
                getLocation()
                //
            } else {
                getLocation()
            }
//            getLocation()
        }
    }
    
    func getLocation() {
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestLocation()
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .AuthorizedAlways:
            getLocation()
        case .AuthorizedWhenInUse:
            getLocation()
        case .Denied:
            showSettings()
        case .NotDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .Restricted:
            print("Location Denied")
        }
//        if status == .AuthorizedAlways || status == .AuthorizedWhenInUse {
//            print("1-locationManager:didChangeAuthorization: \(status.rawValue)")
//            getLocation()
//        }
//        print("2-locationManager:didChangeAuthorization: \(status.rawValue)")
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("Current location: \(location)")
            // 1
            if let jsonURL = buildURL(location, near: nil, query: "restaurant", limit: nil, intent: .checkin) {
//                print("jsonURL-> \(jsonURL)")
                getVenues(fromURL: jsonURL)
//////            // 2
//////            let sessionConfig = URLSessionConfiguration.default()
//////            // 3
//////            let session = URLSession(configuration: sessionConfig, delegate: self, delegateQueue: nil)
//////
////            }
//        } else {
// ...
            } else {
                print("couldn't build query url")
            }
        } else {
            print("couldn't get locations")
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error finding location: \(error.localizedDescription)")
    }
    
    // MARK: - Private Functions
    
    private func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .NotDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .AuthorizedWhenInUse:
            getLocation()
        case .AuthorizedAlways:
            getLocation()
        case .Restricted:
            print("restricted")
        case .Denied:
            showSettings()
        }
    }
    
    private func showSettings() {
        let grantAccess = UIAlertAction(
            title: "Grant Access",
            style: .Default) {
                (UIAlertAction) in
                let settingsURL = NSURL(string: UIApplicationOpenSettingsURLString)!
                UIApplication.sharedApplication().openURL(settingsURL)
        }
        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: .Cancel,
            handler: nil)
        let actions = [grantAccess, cancelAction]
        presentAlert("We don't have access to your location", withActions: actions)
    }
    
    private func presentAlert(message: String, withActions actions:[UIAlertAction]?) {
//        let appName = Bundle.main.infoDictionary!["CFBundleName"] as! String
        let appName = NSBundle.mainBundle().infoDictionary!["CFBundleName"] as! String
        let alert = UIAlertController(title: appName,
                                      message: message,
                                      preferredStyle: .Alert)
        if let actions = actions {
            for action in actions {
                alert.addAction(action)
            }
        }
        presentViewController(alert, animated: true, completion: nil)
    }
    
    private func getVenues(fromURL url:NSURL) {
        if let jsonData = NSData(contentsOfURL: url) {
            do {
                let realm = try! Realm()
                try realm.write {
                    let json = try! NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions()) as! [String : AnyObject]
                    //                print("json: \(json)")
                    if let jsonResponse = json["response"] as? [String: AnyObject],
                        let venues = jsonResponse["venues"] as? [[String: AnyObject]] {
                        for venue in venues {
                            realm.create(Venue.self, value: venue, update: true)
                        }
                    }
                }
                tableView.reloadData()
            } catch {
                print("ERROR parsing JSON: \(error)")
            }
        } else {
            print("Couldn't get menu for venue")
        }
    }
    
    //MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if (segue.identifier == "showDetail") {
            
            var nextViewController = DetailVC()
            if let navViewController = segue.destinationViewController as? UINavigationController {
                nextViewController = navViewController.viewControllers[0] as! DetailVC
            } else
                if let nextVC = segue.destinationViewController as? DetailVC {
                    nextViewController = nextVC
            }
            
            if let selectedObject = sender as? Entity {
                nextViewController.object = selectedObject
                nextViewController.navigationItem.title = selectedObject.name
            }
        } else if (segue.identifier == "showMap") {
//            navigationItem.title = "Table"
        }
    }
    
}

//extension VenueSearch: UISplitViewControllerDelegate {
//
//    // MARK: - UISplitView Controller
//
//    func splitViewController(splitViewController: UISplitViewController,
//                             collapseSecondaryViewController secondaryViewController: UIViewController,
//                                                             ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {
//        return true
//    }
//
//}

