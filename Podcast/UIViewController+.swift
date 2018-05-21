
import UIKit
import NVActivityIndicatorView
import SwiftMessages

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

extension UIViewController {

    func recast(for episode: Episode, completion: ((Bool, Int) -> ())?) {
        if episode.isRecommended {
            editRecastAction(episode: episode, completion: completion)
        } else {
            episode.createRecommendation(with: nil, success: { isRecommended,nRecomendations in
                MessageView.showRecastView(for: episode, completion: {
                    self.editRecastAction(episode: episode, completion: completion)
                })
                completion?(isRecommended,nRecomendations)
            }, failure: completion)
        }
    }

    // shown when user recasts an episode and then clicks to edit it
    func editRecastAction(episode: Episode, completion: ((Bool, Int) -> ())?) {
        // ask user if they want to add a blurb
        let addBlurbOption = ActionSheetOption(type: .blurb(hasBlurb: UserEpisodeData.shared.getBlurbForCurrentUser(and: episode) != nil), action: {
            let editBlurb = ActionSheetOption(type: .createBlurb(currentBlurb:  UserEpisodeData.shared.getBlurbForCurrentUser(and: episode)), action: nil)
            editBlurb.action = {
                if case .createBlurb(let currentBlurb) = editBlurb.type {
                    // update episode with blurb
                    episode.createRecommendation(with: currentBlurb, success: completion, failure: completion)
                }
            }
            let actionSheetViewController = ActionSheetViewController(options: [editBlurb], header: nil)
            self.showActionSheetViewController(actionSheetViewController: actionSheetViewController)
        })

        // if episode is was just recasted don't ask them to undo it
        let undoOption = ActionSheetOption(type: .undoRecast, action: {
            episode.deleteRecommendation(success: completion, failure: completion)
        })

        let actionSheetViewController = ActionSheetViewController(options: [addBlurbOption, undoOption], header: nil)
        self.showActionSheetViewController(actionSheetViewController: actionSheetViewController)
    }
}
