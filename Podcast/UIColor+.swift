
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
    
    // Accents
    @nonobjc static let podcastPink = UIColor.colorFromCode(0xEC7EBD) // Accent 1
    @nonobjc static let podcastGreenBlue = UIColor.colorFromCode(0x22B2B2) // Accent 2
    @nonobjc static let podcastBlueLight = UIColor.colorFromCode(0x82BCC2) // Secondary
    
    @nonobjc static let podcastTealBackground = UIColor.colorFromCode(0x4AAEA9) // profile view
    @nonobjc static let podcastTeal = UIColor.colorFromCode(0x489C98) // Subscribe button
    @nonobjc static let tagButtonText = UIColor.colorFromCode(0x494949) // Tag button text
    
    public static func colorFromCode(_ code: Int) -> UIColor {
        let red = CGFloat(((code & 0xFF0000) >> 16)) / 255
        let green = CGFloat(((code & 0xFF00) >> 8)) / 255
        let blue = CGFloat((code & 0xFF)) / 255
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
}
