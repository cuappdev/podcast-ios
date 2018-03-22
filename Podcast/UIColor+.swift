
import UIKit

extension UIColor {
    
    public static func colorFromCode(_ code: Int) -> UIColor {
        let red = CGFloat(((code & 0xFF0000) >> 16)) / 255
        let green = CGFloat(((code & 0xFF00) >> 8)) / 255
        let blue = CGFloat((code & 0xFF)) / 255
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }

    @nonobjc class var offWhite: UIColor {
        return UIColor(red: 252.0 / 255.0, green: 252.0 / 255.0, blue: 254.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var paleGrey: UIColor {
        return UIColor(red: 240.0 / 255.0, green: 240.0 / 255.0, blue: 244.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var lightGrey: UIColor {
        return UIColor(red: 234.0 / 255.0, green: 235.0 / 255.0, blue: 238.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var coolGrey: UIColor {
        return UIColor(red: 168.0 / 255.0, green: 172.0 / 255.0, blue: 180.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var silver: UIColor {
        return UIColor(red: 211.0 / 255.0, green: 213.0 / 255.0, blue: 215.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var slateGrey: UIColor {
        return UIColor(red: 149.0 / 255.0, green: 155.0 / 255.0, blue: 165.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var charcoalGrey: UIColor {
        return UIColor(red: 100.0 / 255.0, green: 103.0 / 255.0, blue: 108.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var offBlack: UIColor {
        return UIColor(red: 48.0 / 255.0, green: 48.0 / 255.0, blue: 60.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var sea: UIColor {
        return UIColor(red: 60.0 / 255.0, green: 165.0 / 255.0, blue: 160.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var gradientWhite: UIColor {
        return UIColor(red: 246.0 / 255.0, green: 246.0 / 255.0, blue: 250.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var rosyPink: UIColor {
        return UIColor(red: 239.0 / 255.0, green: 118.0 / 255.0, blue: 122.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var duskyBlue: UIColor {
        return UIColor(red: 69.0 / 255.0, green: 105.0 / 255.0, blue: 144.0 / 255.0, alpha: 1.0)
    }

    @nonobjc class var bluish: UIColor {
        return UIColor(red: 40.0 / 255.0, green: 136.0 / 255.0, blue: 162.0 / 255.0, alpha: 1.0)
    }

    @nonobjc class var mutedBlue: UIColor {
        return UIColor(red: 54.0 / 255.0, green: 121.0 / 255.0, blue: 156.0 / 255.0, alpha: 1.0)
    }

    @nonobjc class var tealish: UIColor {
        return UIColor(red: 41.0 / 255.0, green: 151.0 / 255.0, blue: 163.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var dullYellow: UIColor {
        return UIColor(red: 238.0 / 255.0, green: 184.0 / 255.0, blue: 104.0 / 255.0, alpha: 1.0)
    }

    
    @nonobjc class var aquamarine: UIColor {
        return UIColor(red: 1.0 / 255.0, green: 202.0 / 255.0, blue: 183.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var turquoiseBlue: UIColor {
        return UIColor(red: 0.0, green: 179.0 / 255.0, blue: 188.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var tealBlue: UIColor {
        return UIColor(red: 0.0, green: 154.0 / 255.0, blue: 184.0 / 255.0, alpha: 1.0)

    /// Creates a 1x1 size UIImage of a color. Used for changing navigation bar underline colors
    func as1ptImage() -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        guard let context = UIGraphicsGetCurrentContext() else { return UIImage() }
        self.setFill()
        context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        UIGraphicsEndImageContext()
        return image
    }
}
