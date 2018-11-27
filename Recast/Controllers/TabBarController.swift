//
//  TabBarController.swift
//  Recast
//
//  Created by Jack Thompson on 11/17/18.
//  Copyright © 2018 Cornell AppDev. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {

    // MARK: - Variables
    var homeViewController: HomeViewController!
    var homeNavController: NavigationController!

    var discoverViewController: DiscoverTopicsViewController!
    var discoverNavController: NavigationController!

    var previousViewController: UIViewController?

    // MARK: - Constants
    let tabBarIcons = [[UIImage(named: "home_tab_bar_unselected")?.withRenderingMode(.alwaysOriginal),
                        UIImage(named: "home_tab_bar_selected")?.withRenderingMode(.alwaysOriginal)],
                       [UIImage(named: "search_tab_bar_unselected")?.withRenderingMode(.alwaysOriginal),
                        UIImage(named: "search_tab_bar_selected")?.withRenderingMode(.alwaysOriginal)]]

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self

        tabBar.barTintColor = .black
        selectedIndex = 0
        setUpTabs()

        guard let items = tabBar.items else { return }
        for (index, tabBarItem) in items.enumerated() {
            tabBarItem.title = ""
            tabBarItem.image = tabBarIcons[index][0]
            tabBarItem.selectedImage = tabBarIcons[index][1]
            tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        }
    }

    func setUpTabs() {
        homeViewController = HomeViewController()
        homeNavController = NavigationController(rootViewController: homeViewController)

        discoverViewController = DiscoverTopicsViewController()
        discoverNavController = NavigationController(rootViewController: discoverViewController)

        let navControllers: [NavigationController] = [homeNavController, discoverNavController]
        setViewControllers(navControllers, animated: true)
        previousViewController = navControllers[selectedIndex].viewControllers.first
    }

    /// Scrolls to top upon tap of current tab.
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//        if let navigationController = viewController as? UINavigationController,
//            let visibleViewController = navigationController.topViewController as? ViewController,
//            let scrollView = visibleViewController.mainScrollView,
//            visibleViewController == previousViewController {
//            let newOffset = CGPoint(x: 0, y: -visibleViewController.additionalSafeAreaInsets.top)
//            scrollView.setContentOffset(newOffset, animated: true)
//            previousViewController = visibleViewController
//        } else {
//            // set previous view controller
//            previousViewController = (viewController as? UINavigationController)?.topViewController
//        }
    }

}
