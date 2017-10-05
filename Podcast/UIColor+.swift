
import UIKit

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
    @nonobjc static let podcastDetailGray =  UIColor.colorFromCode(0x959ba5)
    
    
    // Accents
    @nonobjc static let podcastPink = UIColor.colorFromCode(0xEC7EBD) // Accent 1
    @nonobjc static let podcastGreenBlue = UIColor.colorFromCode(0x22B2B2) // Accent 2
    @nonobjc static let podcastBlueLight = UIColor.colorFromCode(0x82BCC2) // Secondary
    
    @nonobjc static let podcastTealBackground = UIColor.colorFromCode(0x4AAEA9) // profile view
    @nonobjc static let podcastTeal = UIColor.colorFromCode(0x489C98) // Subscribe button
    @nonobjc static let tagButtonText = UIColor.colorFromCode(0x494949) // Tag button text
    
    @nonobjc static let cancelButtonRed = UIColor.colorFromCode(0xDA5A5A) // Cancel button text
    
    @nonobjc static let charcolGray = UIColor.colorFromCode(0x30303C)
    
    @nonobjc static let charcolGrayDark = UIColor.colorFromCode(0x30313C)
    @nonobjc static let podcastSilver = UIColor.colorFromCode(0xd4d6d7)
    
    @nonobjc static let podcastPlayerGray = UIColor.colorFromCode(0xf4f4f7)
    @nonobjc static let podcastPlayerTeal = UIColor.colorFromCode(0x3ea098)
    @nonobjc static let podcastPlayerDescriptionGray = UIColor.colorFromCode(0x64676c)
    @nonobjc static let podcastMiniPlayerGray = UIColor.colorFromCode(0xf0f1f4)
    
    @nonobjc static let seriesDetailGradientWhite = UIColor.colorFromCode(0xf6f6fa)
    
    public static func colorFromCode(_ code: Int) -> UIColor {
        let red = CGFloat(((code & 0xFF0000) >> 16)) / 255
        let green = CGFloat(((code & 0xFF00) >> 8)) / 255
        let blue = CGFloat((code & 0xFF)) / 255
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
}
