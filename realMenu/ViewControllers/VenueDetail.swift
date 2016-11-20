//
//  VenueDetail.swift
//  realMenu
//
//  Created by Eugène Peschard on 17/09/16.
//  Copyright © 2016 Nissan. All rights reserved.
//

import UIKit
import RealmSwift

class VenueDetail: UIViewController {
    
    typealias Entity = Venue
    var object: Entity?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var definitionLabel: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }
    
    func updateView() {
        navigationItem.title = object?.name
        nameLabel.text = object?.name
    }
}
