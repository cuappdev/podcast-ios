
import UIKit
import CoreMedia

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
