//
//  MenuCell.swift
//  realMenu
//
//  Created by Eugène Peschard on 20/11/2016.
//  Copyright © 2016 Nissan. All rights reserved.
//

import UIKit

class MenuCell: CustomCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UITextView!
    @IBOutlet weak var priceLabel: UILabel!
    //    @IBOutlet weak var iconImageView: UIImageView!
    
    var object: Entry? {
        didSet {
            updateUI()
        }
    }
    
    let priceFormatter = NSNumberFormatter()
    
    //
    
//    let queueIcons = DispatchQueue(
//        label: "me.peschard.euge.queueIcons",
//        qos: .userInteractive,
//        attributes: .concurrent,
//        autoreleaseFrequency: .inherit,
//        target: nil
//    )
    
    func updateUI() {
        // reset any existing information
        clearOutlets()
        setFonts()
        
        // load new information (if any)
        if let entry = object {
            if searchString != "" {
                grayoutLabels()
            }
            nameLabel.attributedText = highlight(searchString, inString: entry.name )
            descLabel.attributedText = highlight(searchString, inString: entry.desc )
            
            //            if entry.price.characters.count > 0 {
            if entry.price != 0.0 {
                priceFormatter.numberStyle = .CurrencyStyle
                priceLabel.text = priceFormatter.stringFromNumber(entry.price)
            } else {
                priceLabel.text = "no price"
            }
        }
    }
    
    func setFonts() {
        nameLabel.font = headline
        descLabel.font = body
        priceLabel.font = caption1
        
        nameLabel.textColor = UIColor.whiteColor()
        descLabel.textColor = UIColor.lightGrayColor()
        priceLabel.textColor = UIColor.lightGrayColor()
    }
    
    func clearOutlets() {
        nameLabel.text = nil
        descLabel.text = nil
        priceLabel.text = nil
    }
    
    func grayoutLabels() {
        nameLabel.textColor = UIColor.grayColor()
        descLabel.textColor = UIColor.grayColor()
        priceLabel.textColor = UIColor.grayColor()
    }
    
}
