//
//  Extensions.swift
//  Podcast
//
//  Created by Joseph Antonakakis on 9/11/16.
//  Copyright © 2016 Cornell App Development. All rights reserved.
//

import UIKit
import CoreMedia

// Podcast App Specific Colors
extension UIColor {
    
    // Older colors in case we need to go back
//    @nonobjc static let podcastGrayLight = UIColor.colorFromCode(0xEAEAEA)
//    @nonobjc static let podcastGreenBlue = UIColor.colorFromCode(0x107A86)
    
    // Black and whites
    @nonobjc static let podcastBlack = UIColor.colorFromCode(0x30303C) // Dark text
    @nonobjc static let podcastGrayDark = UIColor.colorFromCode(0x64646C)
    @nonobjc static let podcastGrayLight = UIColor.colorFromCode(0xA8A8B4)
    @nonobjc static let podcastGray = UIColor.colorFromCode(0xDCDCE2)
    @nonobjc static let podcastWhiteDark = UIColor.colorFromCode(0xF0F0F4)
    @nonobjc static let podcastWhiteLight = UIColor.colorFromCode(0xF6F6FA)
    @nonobjc static let podcastWhite = UIColor.colorFromCode(0xFCFCFE) // Background
    
    // Accents
    @nonobjc static let podcastPink = UIColor.colorFromCode(0xEC7EBD) // Accent 1
    @nonobjc static let podcastGreenBlue = UIColor.colorFromCode(0x22B2B2) // Accent 2
    @nonobjc static let podcastBlueLight = UIColor.colorFromCode(0x82BCC2) // Secondary
    
    public static func colorFromCode(_ code: Int) -> UIColor {
        let red = CGFloat(((code & 0xFF0000) >> 16)) / 255
        let green = CGFloat(((code & 0xFF00) >> 8)) / 255
        let blue = CGFloat((code & 0xFF)) / 255
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
}

extension UIFont {
    
    @nonobjc static let discoverTableViewCellDefaultFontAttributes = [NSForegroundColorAttributeName: UIColor.podcastGrayLight, NSFontAttributeName: UIFont(name: ".SFUIText-Medium", size: 10.0)!]

}

extension CMTime {
    
    /// Returns a string representation of the CMTime in the format `h:mm:ss` if time is greater than or equal to one hour, and `mm:ss` if less than one hour
    var descriptionText: String {
        if self.isIndefinite {
            return "0:00"
        }
        let totalSeconds = Int(self.seconds)
        let hours = totalSeconds / 3600
        let minutes = totalSeconds % 3600 / 60
        let seconds = totalSeconds % 60
        
        if hours > 0 {
            return String(format: "%i:%02i:%02i", hours, minutes, seconds)
        } else {
            return String(format: "%02i:%02i", minutes, seconds)
        }
    }
}
