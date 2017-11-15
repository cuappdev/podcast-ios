
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
    
    func topViewController() -> UIViewController? {
        return childViewControllers.last
    }
}
