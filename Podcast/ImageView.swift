
import Haneke

class ImageView: UIImageView {
    
    func setImageAsynchronouslyWithDefaultImage(url: URL?, defualtImage: UIImage = #imageLiteral(resourceName: "nullSeries")) {
        hnk_setImage(from: url, placeholder: defualtImage, success: nil, failure: nil)
    }
}
