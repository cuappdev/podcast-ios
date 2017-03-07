//
//  TabbedPageViewController.swift
//  Eatery
//
//  Created by Eric Appel on 11/1/15.
//  Copyright © 2015 CUAppDev. All rights reserved.
//

import UIKit

protocol TabbedPageViewControllerDelegate: class {
    func selectedTabDidChange(_ newIndex: Int)
}

protocol TabbedPageViewControllerScrollDelegate: class {
    func scrollViewDidChange()
}

private let kTabBarHeight: CGFloat = 44

class TabbedPageViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, TabBarDelegate {
    
    var viewControllers: [UIViewController]!
    fileprivate var meals: [String] = []
    
    weak var tabDelegate: TabbedPageViewControllerDelegate?
    weak var scrollDelegate: TabbedPageViewControllerScrollDelegate?
    var tabBar: UnderlineTabBarView!
    let tabNames = ["Episodes", "Series", "People", "Tags"]
    
    var pageViewController: UIPageViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .podcastGray
        
        // Tab Bar
        
        tabBar = UnderlineTabBarView(frame: CGRect(x: 0, y: 64, width: view.frame.width, height: kTabBarHeight))
        tabBar.setUp(tabNames)
        tabBar.delegate = self
        view.addSubview(tabBar)
            
        tabDelegate = tabBar
        
        // Page view controller
        
        viewControllers = SearchTableViewController.buildListOfAllSearchTableViewControllerTypes()
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.setViewControllers([viewControllers[0]], direction: .forward, animated: false, completion: nil)
        pageViewController.view.backgroundColor = .white
        let pageVCYOffset: CGFloat = tabBar.frame.maxY + 1 // get a small line between the start of the table view
        let pageVCHeight = view.frame.height - pageVCYOffset - 44 - 20 - 1
        pageViewController.view.frame = CGRect(x: 0, y: pageVCYOffset, width: view.frame.width, height: pageVCHeight)
        
        pageViewController.dataSource = self
        pageViewController.delegate = self
        pageViewController.setViewControllers([viewControllers[0]], direction: .forward, animated: false, completion: nil)
        
        addChildViewController(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParentViewController: self)
        view.bringSubview(toFront: tabBar)
    }
    
    func scrollToViewController(_ vc: UIViewController) {
        pageViewController.setViewControllers([vc], direction: .forward, animated: false, completion: nil)
        let index = viewControllers.index(of: vc)!
        tabDelegate?.selectedTabDidChange(index)
        scrollDelegate?.scrollViewDidChange()
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let index = viewControllers.index(of: viewController)!
        
        guard index != 0 else { return nil }
        
        return viewControllers[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let index = viewControllers.index(of: viewController)!
        
        guard index != viewControllers.count - 1 else { return nil }
        
        return viewControllers[index + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let currentViewController = pageViewController.viewControllers!.first! as! SearchTableViewController
        let index = viewControllers.index(of: currentViewController)!
        tabDelegate?.selectedTabDidChange(index)
        scrollDelegate?.scrollViewDidChange()
    }
    
    // Tab Bar Delegate
    func selectedTabDidChange(_ newIndex: Int) {
        let currentViewController = pageViewController.viewControllers!.first! as! SearchTableViewController
        let currentIndex = viewControllers.index(of: currentViewController)!
        
        guard newIndex != currentIndex else { return }
        
        var direction: UIPageViewControllerNavigationDirection = .forward
        if newIndex < currentIndex {
            direction = .reverse
        }
        pageViewController.setViewControllers([viewControllers[newIndex]], direction: direction, animated: true, completion: nil)
        
        scrollDelegate?.scrollViewDidChange()
    }
    
    func pluckCurrentScrollView() -> UIScrollView {
        let currentViewController = pageViewController.viewControllers!.first! as! SearchTableViewController
        return currentViewController.tableView
    }
    
    func scrollGestureDidScroll(_ offset: CGPoint) {
        let currentViewController = pageViewController.viewControllers!.first! as! SearchTableViewController
        currentViewController.tableView.setContentOffset(offset, animated: false)
    }
    
}
