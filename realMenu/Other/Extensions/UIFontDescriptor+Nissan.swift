//
//  UIFontDescriptor+Nissan.swift
//  Purchasing
//
//  Created by Eugène Peschard on 29/09/15.
//  Copyright © 2016 Nissan. All rights reserved.
//

import UIKit

// http://stackoverflow.com/questions/21737788/custom-fonts-in-ios-7
/*

*/

extension UIFontDescriptor {
//    private struct SubStruct {
////        static var preferredFontName: String = "NissanAG-Medium"
////        static var preferredFontName: String = "NissanAG-ExtdMedium"
//        static var preferredFontName: String = "NissanAG-ExtdLight"
////        static var preferredFontName: String = "NissanAG-Light"
//    }
    
    class func preferredNissanFontWithDescriptor(textStyle: String) -> UIFontDescriptor {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var fontSizeTable : NSDictionary = NSDictionary()
            static var fontNameTable : NSDictionary = NSDictionary()
        }
        
        dispatch_once(&Static.onceToken) {
            Static.fontSizeTable = [
                UIFontTextStyleHeadline: [
                    UIContentSizeCategoryAccessibilityExtraExtraExtraLarge: 26,
                    UIContentSizeCategoryAccessibilityExtraExtraLarge: 25,
                    UIContentSizeCategoryAccessibilityExtraLarge: 24,
                    UIContentSizeCategoryAccessibilityLarge: 24,
                    UIContentSizeCategoryAccessibilityMedium: 23,
                    UIContentSizeCategoryExtraExtraExtraLarge: 23,
                    UIContentSizeCategoryExtraExtraLarge: 22,
                    UIContentSizeCategoryExtraLarge: 21,
                    UIContentSizeCategoryLarge: 20,
                    UIContentSizeCategoryMedium: 19,
                    UIContentSizeCategorySmall: 18,
                    UIContentSizeCategoryExtraSmall: 17
                ],
                UIFontTextStyleSubheadline: [
                    UIContentSizeCategoryAccessibilityExtraExtraExtraLarge: 24,
                    UIContentSizeCategoryAccessibilityExtraExtraLarge: 23,
                    UIContentSizeCategoryAccessibilityExtraLarge: 22,
                    UIContentSizeCategoryAccessibilityLarge: 22,
                    UIContentSizeCategoryAccessibilityMedium: 21,
                    UIContentSizeCategoryExtraExtraExtraLarge: 21,
                    UIContentSizeCategoryExtraExtraLarge: 20,
                    UIContentSizeCategoryExtraLarge: 19,
                    UIContentSizeCategoryLarge: 18,
                    UIContentSizeCategoryMedium: 17,
                    UIContentSizeCategorySmall: 16,
                    UIContentSizeCategoryExtraSmall: 15
                ],
                UIFontTextStyleBody: [
                    UIContentSizeCategoryAccessibilityExtraExtraExtraLarge: 21,
                    UIContentSizeCategoryAccessibilityExtraExtraLarge: 20,
                    UIContentSizeCategoryAccessibilityExtraLarge: 19,
                    UIContentSizeCategoryAccessibilityLarge: 19,
                    UIContentSizeCategoryAccessibilityMedium: 18,
                    UIContentSizeCategoryExtraExtraExtraLarge: 18,
                    UIContentSizeCategoryExtraExtraLarge: 17,
                    UIContentSizeCategoryExtraLarge: 16,
                    UIContentSizeCategoryLarge: 15,
                    UIContentSizeCategoryMedium: 14,
                    UIContentSizeCategorySmall: 13,
                    UIContentSizeCategoryExtraSmall: 12
                ],
                UIFontTextStyleCaption1: [
                    UIContentSizeCategoryAccessibilityExtraExtraExtraLarge: 19,
                    UIContentSizeCategoryAccessibilityExtraExtraLarge: 18,
                    UIContentSizeCategoryAccessibilityExtraLarge: 17,
                    UIContentSizeCategoryAccessibilityLarge: 17,
                    UIContentSizeCategoryAccessibilityMedium: 16,
                    UIContentSizeCategoryExtraExtraExtraLarge: 16,
                    UIContentSizeCategoryExtraExtraLarge: 16,
                    UIContentSizeCategoryExtraLarge: 15,
                    UIContentSizeCategoryLarge: 14,
                    UIContentSizeCategoryMedium: 13,
                    UIContentSizeCategorySmall: 12,
                    UIContentSizeCategoryExtraSmall: 12
                ],
                UIFontTextStyleCaption2: [
                    UIContentSizeCategoryAccessibilityExtraExtraExtraLarge: 18,
                    UIContentSizeCategoryAccessibilityExtraExtraLarge: 17,
                    UIContentSizeCategoryAccessibilityExtraLarge: 16,
                    UIContentSizeCategoryAccessibilityLarge: 16,
                    UIContentSizeCategoryAccessibilityMedium: 15,
                    UIContentSizeCategoryExtraExtraExtraLarge: 15,
                    UIContentSizeCategoryExtraExtraLarge: 14,
                    UIContentSizeCategoryExtraLarge: 14,
                    UIContentSizeCategoryLarge: 13,
                    UIContentSizeCategoryMedium: 12,
                    UIContentSizeCategorySmall: 12,
                    UIContentSizeCategoryExtraSmall: 11
                ],
                UIFontTextStyleFootnote: [
                    UIContentSizeCategoryAccessibilityExtraExtraExtraLarge: 16,
                    UIContentSizeCategoryAccessibilityExtraExtraLarge: 15,
                    UIContentSizeCategoryAccessibilityExtraLarge: 14,
                    UIContentSizeCategoryAccessibilityLarge: 14,
                    UIContentSizeCategoryAccessibilityMedium: 13,
                    UIContentSizeCategoryExtraExtraExtraLarge: 13,
                    UIContentSizeCategoryExtraExtraLarge: 12,
                    UIContentSizeCategoryExtraLarge: 12,
                    UIContentSizeCategoryLarge: 11,
                    UIContentSizeCategoryMedium: 11,
                    UIContentSizeCategorySmall: 10,
                    UIContentSizeCategoryExtraSmall: 10
                ],
            ]
            Static.fontNameTable = [
                UIFontTextStyleHeadline: "NissanAG-ExtdMedium",
                UIFontTextStyleSubheadline: "NissanAG-ExtdLight",
                UIFontTextStyleBody: "NissanAG-Light",
                UIFontTextStyleCaption1: "NissanAG-Light",
                UIFontTextStyleCaption2: "NissanAG-Medium",
                UIFontTextStyleFootnote: "NissanAG-Light"
            ]
            /* 
            "NissanAG-Medium"
            "NissanAG-ExtdMedium"
            "NissanAG-ExtdLight"
            "NissanAG-Light"
            */
        }
        
        let contentSize = UIApplication.sharedApplication().preferredContentSizeCategory
        
        let size = Static.fontSizeTable[textStyle] as! NSDictionary
        let font = Static.fontNameTable[textStyle] as! String
        
        let fontDescriptor = UIFontDescriptor(name: font, size: CGFloat((size[contentSize] as! NSNumber).floatValue))
        
//        return UIFontDescriptor(name: SubStruct.preferredFontName,
//            size: CGFloat((style[contentSize] as! NSNumber).floatValue))
        return fontDescriptor
    }
}
