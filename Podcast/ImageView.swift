import Kingfisher
import NVActivityIndicatorView

class ImageView: UIImageView {
    
    func setImageAsynchronouslyWithDefaultImage(url: URL?, defaultImage: UIImage = #imageLiteral(resourceName: "nullSeries")) {
        guard frame != .zero else { return }

        kf.setImage(with: url, placeholder: defaultImage)
    }
}
