//
//  Extensions.swift
//  Podcast
//
//  Created by Joseph Antonakakis on 9/11/16.
//  Copyright © 2016 Cornell App Development. All rights reserved.
//

import UIKit

// Podcast App Specific Colors
extension UIColor {
    
    @nonobjc static let podcastGrayLight = UIColor.colorFromCode(0xEAEAEA)
    @nonobjc static let podcastGreenBlue = UIColor.colorFromCode(0x107A86)
    @nonobjc static let podcastBlueLight = UIColor.colorFromCode(0x82BCC2)
    
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
