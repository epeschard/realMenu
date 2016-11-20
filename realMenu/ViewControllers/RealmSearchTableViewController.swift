//
//  RealmSearchTableViewController.swift
//  iRiS
//
//  Created by Eugène Peschard on 26/08/16.
//  Copyright © 2016 Nissan. All rights reserved.
//

import UIKit
import RealmSwift

class RealmSearchTableViewController<T: Object>: UITableViewController,
    UISearchResultsUpdating,
    UISearchBarDelegate {
    
    var objects = try! Realm().objects(T)//.sorted("name", ascending: true)
    var searchResults = try! Realm().objects(T)
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var searchController: UISearchController!
    
    func filterResultsWithSearchString(searchString: String) {
        let predicate = NSPredicate(format: "name BEGINSWITH [c]%@", searchString) // 1
//        let scopeIndex = searchController.searchBar.selectedScopeButtonIndex // 2
        let realm = try! Realm()
        
//        switch scopeIndex {
//        case 0:
//            searchResults = realm.objects(T).filter(predicate).sorted("name", ascending: true) // 3
//        case 1:
//            searchResults = realm.objects(T).filter(predicate).sorted("created", ascending: true) // 4
//        default:
            searchResults = realm.objects(T).filter(predicate) // 5
//        }
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchResultsController = UITableViewController(style: .Plain)
        searchResultsController.tableView.delegate = self
        searchResultsController.tableView.dataSource = self
        searchResultsController.tableView.rowHeight = 63
//        searchResultsController.tableView.registerClass(LogCell.self, forCellReuseIdentifier: "LogCell")
        
        searchController = UISearchController(searchResultsController: searchResultsController)
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        searchController.searchBar.tintColor = UIColor.whiteColor()
        searchController.searchBar.delegate = self
        
        tableView.tableHeaderView?.addSubview(searchController.searchBar)
        
        definesPresentationContext = true
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchController.active ? searchResults.count : objects.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let object = searchController.active ? searchResults[indexPath.row] : objects[indexPath.row]
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell Id")
            cell?.textLabel?.text = "override cellForRowAtIndexPath"
        
        return cell!
    }
    
    // MARK: - UISearchResultsUpdating
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchString = searchController.searchBar.text!
        filterResultsWithSearchString(searchString)
        //
        let searchResultsController = searchController.searchResultsController as! UITableViewController
        searchResultsController.tableView.reloadData()
    }
    
//    //MARK: - Segmented Control
//    
//    @IBAction func scopeChanged(sender: AnyObject) {
//        
//        let scopeBar = sender as! UISegmentedControl
//        let realm = try! Realm()
//        
//        switch scopeBar.selectedSegmentIndex {
//        case 0:
//            objects = realm.objects(T).sorted("name", ascending: true)
//        case 1:
//            objects = realm.objects(T).sorted("created", ascending: true)
//        default:
//            objects = realm.objects(T).sorted("name", ascending: true)
//        }
//        tableView.reloadData()
//    }
    
//    //MARK: - Navigation
//    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
//        if (segue.identifier == "Edit") {
//            let controller = segue.destinationViewController as! AddNewEntryController
//            var selectedObject: T!
//            let indexPath = tableView.indexPathForSelectedRow
//            
//            if searchController.active {
//                let searchResultsController = searchController.searchResultsController as! UITableViewController
//                let indexPathSearch = searchResultsController.tableView.indexPathForSelectedRow
//                selectedObject = searchResults[indexPathSearch!.row]
//            } else {
//                selectedObject = objects[indexPath!.row]
//            }
//            controller.specimen = selectedObject
//        }
//    }
    
}