//
//  MenuResult.swift
//  realMenu
//
//  Created by Eugène Peschard on 20/11/2016.
//  Copyright © 2016 Nissan. All rights reserved.
//

import RealmSwift
import UIKit

class MenuResult: UITableViewController {
    
    typealias Entity = Entry
    typealias TableCell = MenuCell
    
    // MARK: - Instance Variables
    var searchString = ""
    var searchResults = try! Realm().objects(Entity.self) {
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
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            
            let cell: TableCell = tableView.dequeueReusableCellWithIdentifier("\(TableCell.self)", forIndexPath: indexPath) as! TableCell
            cell.backgroundColor = UIColor.blackColor()
            cell.searchString = searchString
            cell.object = searchResults[indexPath.row]
            
            return cell
    }
    
}
