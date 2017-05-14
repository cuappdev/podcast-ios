
import Haneke

class ImageView: UIImageView {
    
    var setImageCompletionBlock: (() -> ())?
    
    override var image: UIImage? {
        didSet {
            setImageCompletionBlock?()
            setImageCompletionBlock = nil
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
