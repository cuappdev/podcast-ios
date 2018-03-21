//
//  TabBarController.swift
//  Podcast
//
//  Created by Mindy Lou on 3/21/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    let tabBarHeight: CGFloat = 55

    var feedViewController: FeedViewController!
    var internalProfileViewController: InternalProfileViewController!
    var bookmarkViewController: BookmarkViewController!
    var discoverViewController: DiscoverViewController!
    var feedViewControllerNavigationController: UINavigationController!
    var playerViewController: PlayerViewController!
    var searchViewController: SearchViewController!
    var discoverViewControllerNavigationController: UINavigationController!
    var internalProfileViewControllerNavigationController: UINavigationController!
    var bookmarkViewControllerNavigationController: UINavigationController!
    var searchViewControllerNavigationController: UINavigationController!

    var accessoryViewController: TabBarAccessoryViewController?

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
        feedViewController = FeedViewController()
        internalProfileViewController = InternalProfileViewController()
        bookmarkViewController = BookmarkViewController()
        discoverViewController = DiscoverViewController()
        playerViewController = PlayerViewController()
        searchViewController = SearchViewController()

        feedViewControllerNavigationController = NavigationController(rootViewController: feedViewController)
        feedViewControllerNavigationController.tabBarItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "home_tab_bar_unselected").withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "home_tab_bar_selected").withRenderingMode(.alwaysOriginal))

        discoverViewControllerNavigationController = NavigationController(rootViewController: discoverViewController)
        discoverViewControllerNavigationController.tabBarItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "discover_tab_bar_unselected").withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "discover_tab_bar_selected").withRenderingMode(.alwaysOriginal))

        searchViewControllerNavigationController = NavigationController(rootViewController: searchViewController)
        searchViewControllerNavigationController.tabBarItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "search_tab_bar_unselected").withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "search_tab_bar_selected").withRenderingMode(.alwaysOriginal))

        bookmarkViewControllerNavigationController = NavigationController(rootViewController: bookmarkViewController)
        bookmarkViewControllerNavigationController.tabBarItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "bookmark_feed_icon_unselected").withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "bookmarks_tab_bar_selected").withRenderingMode(.alwaysOriginal))

        internalProfileViewControllerNavigationController = NavigationController(rootViewController: internalProfileViewController)
        internalProfileViewControllerNavigationController.setNavigationBarHidden(true, animated: true)
        internalProfileViewControllerNavigationController.tabBarItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "profile_tab_bar_unselected").withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "profile_tab_bar_selected").withRenderingMode(.alwaysOriginal))

        let viewControllers: [UIViewController] = [
            feedViewControllerNavigationController,
            discoverViewControllerNavigationController,
            searchViewControllerNavigationController,
            bookmarkViewControllerNavigationController,
            internalProfileViewControllerNavigationController]

        setViewControllers(viewControllers, animated: true)
        selectedIndex = System.feedTab
    }

    func addAccessoryViewController(accessoryViewController: TabBarAccessoryViewController) {
        self.accessoryViewController?.willMove(toParentViewController: nil)
        self.accessoryViewController?.view.removeFromSuperview()
        self.accessoryViewController?.removeFromParentViewController()
        self.accessoryViewController = nil

        view.insertSubview(accessoryViewController.view, belowSubview: tabBar)
        addChildViewController(accessoryViewController)
        accessoryViewController.didMove(toParentViewController: self)
        self.accessoryViewController = accessoryViewController
        accessoryViewController.view.snp.makeConstraints { make in
            make.bottom.equalTo(tabBar.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(tabBarHeight)
        }

        // update table view insets for accessory view
        if let navigationController = tabBarController?.selectedViewController as? UINavigationController,
            let viewController = navigationController.topViewController as? ViewController {
            viewController.updateTableViewInsetsForAccessoryView()
        }
    }

    func showTabBar() {

    }

    func hideTabBar() {

    }

}

extension TabBarController: UITabBarControllerDelegate {

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let navigationController = viewController as? UINavigationController,
            let visibleViewController = navigationController.topViewController as? ViewController,
            visibleViewController == navigationController.viewControllers.first {
            // todo: fix this for search
            let newOffset = CGPoint(x: 0, y: -1 * navigationController.navigationBar.frame.maxY)
                visibleViewController.mainScrollView?.setContentOffset(newOffset, animated: true)
        }
    }
}
