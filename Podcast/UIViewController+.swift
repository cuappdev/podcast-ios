
import UIKit
import NVActivityIndicatorView

extension UIViewController {
    
    func showActionSheetViewController(actionSheetViewController: ActionSheetViewController) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate, let rootViewController = appDelegate.window?.rootViewController else { return }
        
        rootViewController.view.addSubview(actionSheetViewController.view)
        rootViewController.addChildViewController(actionSheetViewController)
        actionSheetViewController.didMove(toParentViewController: rootViewController)
        
        actionSheetViewController.showActionSheet(animated: true)
    }
    
    //this is a function extension because NVActivityIndicatorView is a final class so it cannot be subclassed
    func createLoadingAnimationView() -> NVActivityIndicatorView {
        let width: CGFloat = 30
        let height: CGFloat = 30
        let color: UIColor = .podcastTeal
        let type: NVActivityIndicatorType = .ballTrianglePath
        let frame = CGRect(x: 0, y: 0, width: width, height: height)
        return NVActivityIndicatorView(frame: frame, type: type, color: color, padding: 0)
    }
    
    func topViewController() -> UIViewController? {
        return childViewControllers.last
    }
}
