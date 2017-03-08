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

protocol SearchResultsControllerDelegate {
    func searchResultsController(controller: UIViewController, childViewDidTapSearchResultOfType: SearchType, model: Any)
}

protocol TabbedPageViewControllerScrollDelegate: class {
    func scrollViewDidChange()
}

private let kTabBarHeight: CGFloat = 44

class TabbedPageViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, UISearchResultsUpdating, TabBarDelegate, SearchTableViewControllerDelegate {
    
    var viewControllers: [UIViewController]!
    
    weak var tabDelegate: TabbedPageViewControllerDelegate?
    weak var scrollDelegate: TabbedPageViewControllerScrollDelegate?
    var tabBar: UnderlineTabBarView!
    let tabNames = ["Episodes", "Series", "People", "Tags"]
    
    var pageViewController: UIPageViewController!
    
    var searchText: String = ""
    
    var searchResultsDelegate: SearchResultsControllerDelegate?
        
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
        for viewController in viewControllers {
            guard let searchTableViewController = viewController as? SearchTableViewController else { break }
            searchTableViewController.cellDelegate = self
        }
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.view.backgroundColor = .white
        let pageVCYOffset: CGFloat = tabBar.frame.maxY + 1 // get a small line between the start of the table view
        let pageVCHeight = view.frame.height - pageVCYOffset - 44 - 1
        pageViewController.view.frame = CGRect(x: 0, y: pageVCYOffset, width: view.frame.width, height: pageVCHeight)
        
        pageViewController.dataSource = self
        pageViewController.delegate = self
        pageViewController.setViewControllers([viewControllers[0]], direction: .forward, animated: false, completion: nil)
        
        addChildViewController(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParentViewController: self)
        view.bringSubview(toFront: tabBar)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
        updateCurrentViewControllerTableView()
        
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
    
    //MARK: -
    //MARK: UISearchResultsUpdating
    //MARK: -
    
    
    func updateSearchResults(for searchController: UISearchController) {
        searchText = searchController.searchBar.text!
        print(searchText)
        updateCurrentViewControllerTableView()
        searchController.searchResultsController?.view.isHidden = false
    }
    
    func updateCurrentViewControllerTableView() {
        guard let currentViewController = viewControllers[tabBar.selectedIndex] as? SearchTableViewController else { return }
        
        switch currentViewController.searchType! {
        case .episodes:
            let episode = Episode(id: 0, title: "185: Orland & Portlando (feat. Matt Spiel)", dateCreated: Date(), descriptionText: "In today's show, we visit Buffalo, New York, and get a window into a rough business: Debt collection. This is the story of one guy who tried to make something of himself by getting people to pay their debts. He set up shop in an old karate studio, and called up people who owed money. For a while, he made a good living. And he wasn't the only one in the business—this is also the story of a low-level, semi-legal debt-collection economy that sprang up in Buffalo. And, in a small way, it's the story of the last twenty or so years in global finance, a time when the world went wild for debt.", smallArtworkImageURL: nil, series: nil, largeArtworkImageURL: nil, audioURL: nil, duration: 0, seriesTitle: "", tags: [], numberOfRecommendations: 0, isRecommended: false, isBookmarked: true)
            episode.seriesTitle = "Design Details"
            currentViewController.searchResults[currentViewController.searchType!] = [Episode].init(repeating: episode, count: 10)
        case .series:
            let series = Series()
//            series.smallArtworkImage = #imageLiteral(resourceName: "sample_series_artwork")
            series.title = "Design Details"
            series.author = "Spec"
            series.numberOfSubscribers = 12034
            currentViewController.searchResults[currentViewController.searchType!] = [Series].init(repeating: series, count: 10)
        case .people:
            let user = User()
//            user.image = #imageLiteral(resourceName: "sample_profile_pic")
            user.firstName = "Sample"
            user.lastName = "User"
            user.username = "xXsampleuserXx"
            user.numberOfFollowers = 123
            currentViewController.searchResults[currentViewController.searchType!] = [User].init(repeating: user, count: 10)
        case .tags:
            let tag = Tag(name: "Swag")
            tag.name = "Swag"
            currentViewController.searchResults[currentViewController.searchType!] = [Tag].init(repeating: tag, count: 10)
            currentViewController.tableView.reloadData()
        }
    }
    
    //MARK: -
    //MARK: SearchTableViewControllerDelegate
    //MARK: -
    func searchTableViewController(controller: SearchTableViewController, didTapSearchResultOfType searchType: SearchType, model: Any) {
        searchResultsDelegate?.searchResultsController(controller: controller, childViewDidTapSearchResultOfType: searchType, model: model)
    }
}
