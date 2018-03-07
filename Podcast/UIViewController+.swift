
import UIKit
import NVActivityIndicatorView

extension UIViewController {
    
    func showActionSheetViewController(actionSheetViewController: ActionSheetViewController) {
        UIViewController.showViewController(viewController: actionSheetViewController)
        actionSheetViewController.showActionSheet(animated: true)
    }

    static func showViewController(viewController: UIViewController) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate, let rootViewController = appDelegate.window?.rootViewController else { return }

        rootViewController.view.addSubview(viewController.view)
        rootViewController.addChildViewController(viewController)
        viewController.didMove(toParentViewController: rootViewController)
    }

    func dismissViewController() {
        UIView.animate(withDuration: 0.50, animations: {
            self.view.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 0)
            self.view.alpha = 0.0
        }, completion: { _ in
            self.willMove(toParentViewController: nil)
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
        })
    }
    
    func topViewController() -> UIViewController? {
        return childViewControllers.last
    }
}
