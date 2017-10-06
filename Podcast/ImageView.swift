
import Haneke

class ImageView: UIImageView {
    
    var setImageCompletionBlock: (() -> ())?
    
    override var image: UIImage? {
        didSet {
            setImageCompletionBlock?()
            setImageCompletionBlock = nil
        }
    }
    
    func setImageAsynchronouslyWithDefaultImage(url: URL?, defualtImage: UIImage = #imageLiteral(resourceName: "nullSeries")) {
        if let validURL = url {
            self.setImageAsynchronously(url: validURL, completion: nil)
        } else {
            self.image = #imageLiteral(resourceName: "nullSeries")
        }
    }
    
    func setImageAsynchronously(url: URL, completion: (() -> ())?) {
        if frame == .zero {
            print("Error: Cannot set image asynchronously with an ImageView with frame .zero")
            return
        }
        setImageCompletionBlock = completion
        hnk_setImage(from: url)
    }
}
