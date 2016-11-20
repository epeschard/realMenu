/*
* Copyright (c) 2015 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import UIKit

class VenueCell: CustomCell {
  
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!

    var object: Venue? {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        // reset any existing information
        clearOutlets()
        setFonts()
        
        // load new information (if any)
        if let venue = object {
            if searchString != "" {
                grayoutLabels()
            }
            titleLabel.attributedText = highlight(searchString, inString: venue.name ?? "🚫")
            subtitleLabel.attributedText = highlight(searchString, inString: venue.url ?? "🚫")
            if let distance = venue.location?.distance {
                distanceLabel.text = "\(distance) m"
            }
            
            // Construct image from icon prefix & suffix
            if let icon = venue.categories.first?.icon,
                let imageURL = NSURL(string: "\(icon.prefix)44\(icon.suffix)") {
                
                let qualityOfServiceClass = QOS_CLASS_USER_INTERACTIVE
                let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
                dispatch_async(backgroundQueue) {
                    [weak weakSelf = self] in
                    // Executing in different thread
                    if let imageData = NSData(contentsOfURL: imageURL) {
                        dispatch_async(dispatch_get_main_queue()) {
                            //Back in main thread
                            weakSelf?.iconImageView.image = UIImage(data: imageData)
                        }
                    } else {
                        print("error getting image for \(imageURL)")
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            //Back in main thread
                            weakSelf?.iconImageView.image = UIImage(named: "Foursquare")
                        })
                    }
                }
            }
            
            // Show available menu with disclosureIndicator
            if venue.hasMenu.value != nil {
                accessoryType = .DisclosureIndicator
            } else {
                accessoryType = .None
            }
        }
    }
    
    func setFonts() {
        titleLabel.font = headline
        subtitleLabel.font = body
        distanceLabel.font = caption1
        
        titleLabel.textColor = UIColor.whiteColor()
        subtitleLabel.textColor = UIColor.lightGrayColor()
        distanceLabel.textColor = UIColor.lightGrayColor()
    }
    
    func clearOutlets() {
        titleLabel.text = nil
        subtitleLabel.text = nil
        distanceLabel.text = nil
        iconImageView.image = nil
    }
    
    func grayoutLabels() {
        titleLabel.textColor = UIColor.grayColor()
        subtitleLabel.textColor = UIColor.grayColor()
        distanceLabel.textColor = UIColor.grayColor()
    }
    
}
