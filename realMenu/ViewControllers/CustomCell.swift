//
//  CustomCell.swift
//  iRiS
//
//  Created by Eugène Peschard on 14/09/16.
//  Copyright © 2016 PeschApps. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
    
    var searchString = ""
    
//    let fontHeadline = UIFont(descriptor: UIFontDescriptor.preferredNissanFontWithDescriptor(UIFontTextStyleHeadline), size: 0)
//    let nissanSubheadline = UIFont(descriptor: UIFontDescriptor.preferredNissanFontWithDescriptor(UIFontTextStyleSubheadline), size: 0)
//    let nissanBody = UIFont(descriptor: UIFontDescriptor.preferredNissanFontWithDescriptor(UIFontTextStyleBody), size: 0)
    let headline =
        UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
    let subheadline = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
    let body =
        UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
    let caption1 =
        UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1)
    
    
    var attributes : [String: AnyObject] {
        get {
//            let shadow = NSShadow()
//                shadow.shadowBlurRadius = 1.0
//                shadow.shadowColor = UIColor.blueColor()
//                shadow.shadowOffset = CGSizeMake(0, 1.0)
            return [NSForegroundColorAttributeName : UIColor.whiteColor()
//                NSUnderlineStyleAttributeName: 1,
//                NSShadowAttributeName: shadow,
//                NSFontAttributeName: headlineFont
            ]
        }
    }
    
    // MARK: - Highlight search
    
    func highlight(subString:String,
                   inString string:String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string)
        if subString != "" {
            
            let searchStrings = subString.componentsSeparatedByString(" ") as [String]
            for searchString in searchStrings {
                
                let swiftRange = string.rangeOfString(searchString,
                                                      options: .CaseInsensitiveSearch,
                                                      range: nil,
                                                      locale: NSLocale.currentLocale())
                if let swiftRange = swiftRange {
                    let nsRange = string.getNSRangeFrom(swiftRange)
                    attributedString.setAttributes(attributes, range: nsRange)
                }
                
            }
        }
        
        return attributedString
    }
}
