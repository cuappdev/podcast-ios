import Kingfisher

class ImageView: UIImageView {
    
    func setImageAsynchronouslyWithDefaultImage(url: URL?, defaultImage: UIImage = #imageLiteral(resourceName: "nullSeries")) {
        kf.setImage(with: url, placeholder: defaultImage)
    }
}
