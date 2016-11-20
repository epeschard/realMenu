//
//  VenueResult.swift
//  realMenu
//
//  Created by Eugène Peschard on 17/09/16.
//  Copyright © 2016 Nissan. All rights reserved.
//

import RealmSwift
import UIKit

class VenueResult: UITableViewController {
    
    typealias Entity = Venue
    typealias TableCell = VenueCell
    
    // MARK: - Instance Variables
    var searchString = ""
    var searchResults = try! Realm().objects(Entity) {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    override func tableView(tableView: UITableView,
                            cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell {
            
            let cell: TableCell =
                tableView.dequeueReusableCellWithIdentifier("\(TableCell.self)", forIndexPath: indexPath) as! TableCell
            
            cell.searchString = searchString
            cell.object = searchResults[indexPath.row]
            
            return cell
    }
    
}
