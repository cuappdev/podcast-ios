
import UIKit

extension UIFont {
    
    class func _22SemiboldFont() -> UIFont {
        return UIFont.systemFont(ofSize: 22.0, weight: UIFont.Weight.semibold)
    }
    
    class func _22LightFont() -> UIFont {
        return UIFont.systemFont(ofSize: 22.0, weight: UIFont.Weight.light)
    }
    
    class func _20SemiboldFont() -> UIFont {
        return UIFont.systemFont(ofSize: 20.0, weight: UIFont.Weight.semibold)
    }
    
    class func _16SemiboldFont() -> UIFont {
        return UIFont.systemFont(ofSize: 16.0, weight: UIFont.Weight.semibold)
    }
    
    class func _16RegularFont() -> UIFont {
        return UIFont.systemFont(ofSize: 16.0, weight: UIFont.Weight.regular)
    }
    
    class func _14SemiboldFont() -> UIFont {
        return UIFont.systemFont(ofSize: 14.0, weight: UIFont.Weight.semibold)
    }

    class func _14RegularFont() -> UIFont {
        return UIFont.systemFont(ofSize: 14.0, weight: UIFont.Weight.regular)
    }
    
    class func _12SemiboldFont() -> UIFont {
        return UIFont.systemFont(ofSize: 12.0, weight: UIFont.Weight.semibold)
    }
    
    class func _12RegularFont() -> UIFont {
        return UIFont.systemFont(ofSize: 12.0, weight: UIFont.Weight.regular)
    }
    
    class func _10SemiboldFont() -> UIFont {
        return UIFont.systemFont(ofSize: 10.0, weight: UIFont.Weight.semibold)
    }
    
    class func _10RegularFont() -> UIFont {
        return UIFont.systemFont(ofSize: 10.0, weight: UIFont.Weight.regular)
    }

    @nonobjc static let discoverTableViewCellDefaultFontAttributes = [NSAttributedStringKey.foregroundColor: UIColor.slateGrey, NSAttributedStringKey.font: UIFont._10SemiboldFont()]
    
     @nonobjc static let navigationBarDefaultFontAttributes = [NSAttributedStringKey.foregroundColor: UIColor.offBlack, NSAttributedStringKey.font: UIFont._16SemiboldFont()]
}
