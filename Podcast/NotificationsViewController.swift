//
//  NotificationsViewController.swift
//  Podcast
//
//  Created by Mindy Lou on 4/4/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import UIKit

class NotificationsViewController: UIPageViewController {

    var pages = [UIViewController]()
    var tabBarView: UnderlineTabBarView!

    let tabBarViewHeight: CGFloat = 44.5

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Notifications"
        tabBarView = UnderlineTabBarView(frame: CGRect(x: 0, y: navigationController?.navigationBar.frame.maxY ?? 0, width: view.frame.width, height: tabBarViewHeight))
        tabBarView.delegate = self
        tabBarView.setUp(sections: ["New Episodes", "Activity"])
        tabBarView.isHidden = false
        view.addSubview(tabBarView)

        pages = [NewEpisodesViewController(), NewEpisodesViewController()]
        setViewControllers([pages[0]], direction: .forward, animated: true, completion: nil)
        delegate = self
        dataSource = self
    }
}

extension NotificationsViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
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
        if let lastViewController = previousViewControllers.first, let index = pages.index(of: lastViewController) {
            tabBarView.updateSelectedTabAppearance(toNewIndex: index == 1 ? 0 : 1)
        }
    }
}

extension NotificationsViewController: TabBarDelegate {
    func selectedTabDidChange(toNewIndex newIndex: Int) {
        if newIndex == 1 {
            setViewControllers([pages[newIndex]], direction: .forward, animated: true, completion: nil)
        } else {
            setViewControllers([pages[newIndex]], direction: .reverse, animated: true, completion: nil)
        }
    }
}
