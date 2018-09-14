//
//  TabBarController.swift
//  Podcast
//
//  Created by Mindy Lou on 3/21/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    var internalProfileViewController: InternalProfileViewController!
    var bookmarkViewController: BookmarkViewController!
    var searchViewController: SearchDiscoverViewController!
    var internalProfileViewControllerNavigationController: UINavigationController!
    var bookmarkViewControllerNavigationController: UINavigationController!
    var searchViewControllerNavigationController: UINavigationController!

    var accessoryViewController: TabBarAccessoryViewController?
    var previousViewController: UIViewController?

    override func viewDidLoad() {
        view.backgroundColor = .offWhite
        delegate = self
        setupTabs()
        guard let items = tabBar.items else { return }
        for tabBarItem in items {
            tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        }
    }

    func setupTabs() {
        internalProfileViewController = InternalProfileViewController()
        bookmarkViewController = BookmarkViewController()
        searchViewController = SearchDiscoverViewController()

        searchViewControllerNavigationController = NavigationController(rootViewController: searchViewController)
        searchViewControllerNavigationController.tabBarItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "search_tab_bar_unselected").withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "search_tab_bar_selected").withRenderingMode(.alwaysOriginal))

        bookmarkViewControllerNavigationController = NavigationController(rootViewController: bookmarkViewController)
        bookmarkViewControllerNavigationController.tabBarItem = UITabBarItem(title: "", image:#imageLiteral(resourceName: "bookmark_tab_bar_unselected").withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "bookmark_tab_bar_selected").withRenderingMode(.alwaysOriginal))

        internalProfileViewControllerNavigationController = NavigationController(rootViewController: internalProfileViewController)
        internalProfileViewControllerNavigationController.tabBarItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "library_tab_bar_unselected").withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "library_tab_bar_selected").withRenderingMode(.alwaysOriginal))

        let viewControllers: [UINavigationController] = [
            searchViewControllerNavigationController,
            bookmarkViewControllerNavigationController,
            internalProfileViewControllerNavigationController
        ]

        setViewControllers(viewControllers, animated: true)
        selectedIndex = System.feedTab
        previousViewController = viewControllers[selectedIndex].viewControllers.first
    }

    func addAccessoryViewController(accessoryViewController: TabBarAccessoryViewController) {
        self.accessoryViewController?.willMove(toParentViewController: nil)
        self.accessoryViewController?.view.removeFromSuperview()
        self.accessoryViewController?.removeFromParentViewController()
        self.accessoryViewController = nil

        view.insertSubview(accessoryViewController.view, belowSubview: tabBar)
        accessoryViewController.didMove(toParentViewController: self)
        self.accessoryViewController = accessoryViewController
        accessoryViewController.becomeFirstResponder()

        // update table view insets for player
        if let navigationController = tabBarController?.selectedViewController as? UINavigationController,
            let viewController = navigationController.topViewController as? ViewController {
            viewController.updateTableViewInsetsForAccessoryView()
        }
    }

    func showTabBar(animated: Bool) {
        if !tabBar.isHidden { return }
        tabBar.isHidden = false
        if animated {
            UIView.animate(withDuration: 0.2, animations: {
                self.tabBar.frame = CGRect(x: 0, y: self.view.frame.height - self.tabBar.frame.height, width: self.tabBar.frame.width, height: self.tabBar.frame.height)
            })
        } else {
            tabBar.frame = CGRect(x: 0, y: view.frame.height - tabBar.frame.height, width: tabBar.frame.width, height: tabBar.frame.height)
        }
    }

    func hideTabBar(animated: Bool) {
        if tabBar.isHidden { return }
        tabBar.isHidden = true
        if animated {
            UIView.animate(withDuration: 0.2, animations: {
                self.tabBar.frame = CGRect(x: 0, y: self.view.frame.height, width: self.tabBar.frame.width, height: self.tabBar.frame.height)
            })
        } else {
            tabBar.frame = CGRect(x: 0, y: view.frame.height, width: tabBar.frame.width, height: tabBar.frame.height)
        }
    }

}

// MARK: TabBarController Delegate
extension TabBarController: UITabBarControllerDelegate {

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let navigationController = viewController as? UINavigationController,
            let visibleViewController = navigationController.topViewController as? ViewController,
            let scrollView = visibleViewController.mainScrollView,
            visibleViewController == previousViewController {
            // if tab bar is selected twice, scroll up
            // this is still buggy: issue with estimated row height
            let newOffset = CGPoint(x: 0, y: -scrollView.adjustedContentInset.top)
            scrollView.setContentOffset(newOffset, animated: true)
            if visibleViewController == searchViewController {
                searchViewController.discoverVC.mainScrollView?.setContentOffset(newOffset, animated: true)
            }
            previousViewController = visibleViewController
        } else {
            // set previous view controller
            previousViewController = (viewController as? UINavigationController)?.topViewController
        }
    }
}
