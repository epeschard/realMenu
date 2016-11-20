//
//  String+ext.swift
//  Gourmies
//
//  Created by Eugène Peschard on 28/08/15.
//  Copyright © 2016 Nissan. All rights reserved.
//

import Foundation

extension String {
    func rangeFromNSRange(nsRange : NSRange) -> Range<String.Index>? {
        let from16 = utf16.startIndex.advancedBy(nsRange.length, limit: utf16.endIndex)
//        let from16 = advance(utf16.startIndex, nsRange.location, utf16.endIndex)
        let to16 = from16.advancedBy(nsRange.length, limit: utf16.endIndex)
//        let to16 = advance(from16, nsRange.length, utf16.endIndex)
        if let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self) {
                return from ..< to
        }
        return nil
    }
    
    // http://stackoverflow.com/questions/25138339/nsrange-to-rangestring-index
    func getNSRangeFrom(range : Range<String.Index>) -> NSRange {
        let a   =   substringToIndex(range.startIndex)
        let b   =   substringWithRange(range)
        
//        return  NSRange(location: a.utf16Count, length: b.utf16Count)
        return  NSRange(location: a.utf16.count, length: b.utf16.count)
    }
}