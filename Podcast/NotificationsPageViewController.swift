//
//  NotificationsPageViewController.swift
//  Podcast
//
//  Created by Mindy Lou on 4/4/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import UIKit

protocol NotificationsViewControllerDelegate: class {
    func updateNotificationCount(to number: Int, for viewController: NotificationsViewController)
}

class NotificationsPageViewController: UIPageViewController {

    var pages = [UIViewController]()
    var tabBarView: UnderlineTabBarView!

    static let tabBarViewHeight: CGFloat = 44.5
    static let readNotifications: [Notification] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Notifications"
        tabBarView = UnderlineTabBarView(frame: CGRect(x: 0, y: navigationController?.navigationBar.frame.maxY ?? 0, width: view.frame.width, height: NotificationsPageViewController.tabBarViewHeight))
        tabBarView.delegate = self
        tabBarView.setUp(sections: ["New Episodes", "Activity"])
        tabBarView.isHidden = false
        view.addSubview(tabBarView)

        let newEpisodesViewController = NotificationsViewController()
        let followSharesViewController = NotificationsViewController()
        pages = [newEpisodesViewController, followSharesViewController]
        pages.forEach {
            if let notificationsViewController = $0 as? NotificationsViewController {
                notificationsViewController.delegate = self
                notificationsViewController.view.layoutSubviews() // so that the notifications badge updates
            }
        }

        setViewControllers([pages[0]], direction: .forward, animated: true, completion: nil)
        delegate = self
        dataSource = self
    }
}

extension NotificationsPageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let index = pages.index(of: viewController), index != 0 {
            return pages[index - 1]
        }
        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let index = pages.index(of: viewController), index < pages.count - 1 {
            return pages[index + 1]
        }
        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let lastViewController = previousViewControllers.first, let index = pages.index(of: lastViewController), completed {
            tabBarView.updateSelectedTabAppearance(toNewIndex: index == 1 ? 0 : 1)
        }
    }

}

extension NotificationsPageViewController: TabBarDelegate {
    func selectedTabDidChange(toNewIndex newIndex: Int) {
        if newIndex == 1 {
            setViewControllers([pages[newIndex]], direction: .forward, animated: true, completion: nil)
        } else {
            setViewControllers([pages[newIndex]], direction: .reverse, animated: true, completion: nil)
        }
    }
}

extension NotificationsPageViewController: NotificationsViewControllerDelegate {
    func updateNotificationCount(to number: Int, for viewController: NotificationsViewController) {
        if let index = pages.index(of: viewController) {
            tabBarView.updateNotificationCount(to: number, for: index)
        }
    }
}
