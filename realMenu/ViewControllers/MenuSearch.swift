//
//  MenuSearch.swift
//  realMenu
//
//  Created by Eugène Peschard on 20/11/2016.
//  Copyright © 2016 Nissan. All rights reserved.
//

import UIKit
import RealmSwift

class MenuSearch: UITableViewController,
    UISearchControllerDelegate,
    UISearchResultsUpdating,
    UISearchBarDelegate {

    typealias Entity = Entry
    typealias TableCell = MenuCell
    typealias ResultVC = MenuResult
    
    let cellHeight = CGFloat(63.0)
    let searchKeyPaths = ["name"]
    
    // MARK: - Instance Variables
    var objects = try! Realm().objects(Entity.self) {
        didSet {
            tableView.reloadData()
        }
    }
    var sectionNames: [String]! {
//        return Set(objects.value(forKeyPath: "section.name") as! [String]).sorted()
        return Set(objects.valueForKeyPath("section.name") as! [String]).sort()
    }
    var menuIds: [String]! {
        return Set(objects.valueForKeyPath("section.menu.menuId") as! [String]).sort()
    }
    
    //    var detailViewController: DetailVC? = nil
    var searchController: UISearchController!
    var resultsTableViewController: ResultVC?
    var venue: Venue! {
        didSet {
            if oldValue != nil {
                objects = objects.filter("section?.menu?.venue == %@", oldValue)
            } else {
                getMenu(for: oldValue.id)
            }
        }
    }
    
    // MARK: - Run Loop
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerClass(TableCell.self, forCellReuseIdentifier: "\(TableCell.self)")
        tableView.registerNib(UINib(nibName: "\(TableCell.self)", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "\(TableCell.self)")
        
        // Table Variable Row Heights
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = cellHeight
        
        tableView.backgroundColor = UIColor.blackColor()
        
        resultsTableViewController = ResultVC()
        setupSearchControllerWith(resultsTableViewController!)
        searchController?.loadViewIfNeeded()
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionNames.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionNames[section]
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.filter("section.name == %@", sectionNames[section]).count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell =
            tableView.dequeueReusableCellWithIdentifier("\(TableCell.self)", forIndexPath: indexPath) as! TableCell
        cell.backgroundColor = UIColor.blackColor()
        cell.object = objects.filter("section.name == %@", sectionNames[indexPath.section])[indexPath.row]
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if tableView == resultsTableViewController?.tableView {
            performSegueWithIdentifier("showDetail", sender: resultsTableViewController!.searchResults[indexPath.row])
        } else {
            let selectedObject = objects.filter("section.name == %@", sectionNames[indexPath.section])[indexPath.row]
            performSegueWithIdentifier("showDetail", sender: selectedObject)
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
        //        resultsTableViewController.textForEmptyLabel = textForEmptyLabel
        
        // We want to be the delegate for our filtered table so didSelectRowAtIndexPath(_:) is called for both tables.
        resultsTableViewController.tableView.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsTableViewController)
        
        // Set Scope Bar Buttons
//        searchController.searchBar.scopeButtonTitles = ["European", "All"]
        
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
        searchController.searchBar.barTintColor = UIColor.blackColor()
        // Hide hairline
        //        searchController.searchBar.isTranslucent = false
        //        searchController.searchBar.backgroundImage = UIImage()
        
        // Search is now just presenting a view controller. As such, normal view controller
        // presentation semantics apply. Namely that presentation will walk up the view controller
        // hierarchy until it finds the root view controller or one that defines a presentation context.
        definesPresentationContext = true
    }
    
    // MARK: - Private Functions
    
    func writeMenu(with json:[String: AnyObject]) {
        do {
            let realm = try Realm()
            try realm.write {
                if let json1 = json["response"] as? [String: AnyObject],
                    let json2 = json1["menu"] as? [String: AnyObject],
                    let json3 = json2["menus"] as? [String: AnyObject],
                    let json4 = json3["items"] as? [[String: AnyObject]] {

                    for jsonMenu in json4 {
                        let menu = realm.create(Menu.self, value: jsonMenu, update: true)
                        menu.desc = jsonMenu["description"] as! String
                        menu.venue = venue
                        if let json6 = jsonMenu["entries"] as? [String: AnyObject],
                            let json7 = json6["items"] as? [[String: AnyObject]]{
                            for jsonSection in json7 {
                                //                                print("section: \(jsonSection)")
                                let section = realm.create(Section.self, value: jsonSection, update: true)
                                section.menu = menu
                                if let json9 = jsonSection["entries"] as? [String: AnyObject],
                                    let json10 = json9["items"] as? [[String: AnyObject]]{
                                    //                                    print("items: \(json10)")
                                    for jsonEntry in json10 {
                                        //                                        print("entry: \(jsonEntry)")
                                        let entry = realm.create(Entry.self, value: jsonEntry, update: true)
                                        entry.section = section
                                        entry.desc = jsonEntry["description"] as! String
                                    }
                                }
                            }
                        }
                    }
                }
            }
        } catch {
            print("ERROR writting Menu: \(error)")
        }
    }
    
    private func getMenu(for venueId: String) {
        if let queryURL = buildURL(venueId) {
            let qualityOfServiceClass = QOS_CLASS_USER_INTERACTIVE
            let menuQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
            print("queryURL: \(queryURL)")
            dispatch_async(menuQueue) {
                [weak weakSelf = self] in
                // Fetch menu from Frousquare in different thread
                if let jsonData = NSData(contentsOfURL: queryURL) {
                    // Process json data
                    do {
                        let jsonMenu = try NSJSONSerialization.JSONObjectWithData(jsonData, options: []) as! [String : AnyObject]
                        dispatch_async(dispatch_get_main_queue()) {
                            weakSelf?.writeMenu(with: jsonMenu)
                            weakSelf?.tableView.reloadData()
                        }
                    } catch {
                        print("ERROR serializing JSON menu")
                    }
                }
            }
        }
    }
}
