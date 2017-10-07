
import Haneke

class ImageView: UIImageView {
    
    func setImageAsynchronouslyWithDefaultImage(url: URL?, defaultImage: UIImage = #imageLiteral(resourceName: "nullSeries")) {
        hnk_setImage(from: url, placeholder: defaultImage, success: nil, failure: nil)
    }
}
