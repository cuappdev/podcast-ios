
import Haneke

class ImageView: UIImageView {
    
    var setImageCompletionBlock: (() -> ())?
    
    override var image: UIImage? {
        didSet {
            setImageCompletionBlock?()
        }
    }
    
    func setImageAsynchronously(url: URL, completion: (() -> ())?) {
        setImageCompletionBlock = completion
        hnk_setImage(from: url)
    }
    
    
}
