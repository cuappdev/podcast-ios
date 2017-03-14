//
//  TabbedPageViewController.swift
//  Podcast
//
//  Created by Eric Appel on 11/1/15.
//  Copyright © 2015 CUAppDev. All rights reserved.
//

import UIKit

protocol TabbedPageViewControllerDelegate: class {
    func selectedTabDidChange(toNewIndex newIndex: Int)
}

protocol TabbedPageViewControllerScrollDelegate: class {
    func scrollViewDidChange()
}

class TabbedPageViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, UISearchResultsUpdating, TabBarDelegate, SearchTableViewControllerDelegate {
    
    let TabBarHeight: CGFloat = 44
    
    var viewControllers: [UIViewController]!
    
    weak var tabDelegate: TabbedPageViewControllerDelegate?
    weak var scrollDelegate: TabbedPageViewControllerScrollDelegate?
    var tabBar: UnderlineTabBarView!
    let tabNames = ["Episodes", "Series", "People", "Tags"]
    
    var pageViewController: UIPageViewController!
    
    var searchText: String = ""
    
    var searchResults: [SearchType: [Any]] = [
        .episodes: [],
        .series: [],
        .people: [],
        .tags: []]
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .podcastGray
        automaticallyAdjustsScrollViewInsets = false
        
        tabBar = UnderlineTabBarView(frame: CGRect(x: 0, y: 64, width: view.frame.width, height: TabBarHeight))
        tabBar.setUp(sections: tabNames)
        tabBar.delegate = self
        view.addSubview(tabBar)
            
        tabDelegate = tabBar

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
        
        let episode = Episode(id: 0, title: "185: Orland & Portlando (feat. Matt Spiel)", dateCreated: Date(), descriptionText: "In today's show, we visit Buffalo, New York, and get a window into a rough business: Debt collection. This is the story of one guy who tried to make something of himself by getting people to pay their debts. He set up shop in an old karate studio, and called up people who owed money. For a while, he made a good living. And he wasn't the only one in the business—this is also the story of a low-level, semi-legal debt-collection economy that sprang up in Buffalo. And, in a small way, it's the story of the last twenty or so years in global finance, a time when the world went wild for debt.", smallArtworkImageURL: nil, series: nil, largeArtworkImageURL: nil, audioURL: nil, duration: 0, seriesTitle: "", tags: [], numberOfRecommendations: 0, isRecommended: false, isBookmarked: true)
        episode.seriesTitle = "Design Details"
        let dummyEpisodes = [Episode].init(repeating: episode, count: 10)
        
        let series = Series()
        series.title = "Design Details"
        series.author = "Spec"
        series.numberOfSubscribers = 12034
        let dummySeries = [Series].init(repeating: series, count: 10)
        
        let user = User()
        user.firstName = "Sample"
        user.lastName = "User"
        user.username = "xXsampleuserXx"
        user.numberOfFollowers = 123
        let dummyUsers = [User].init(repeating: user, count: 10)
        
        let tag = Tag(name: "Swag")
        tag.name = "Swag"
        let dummyTags = [Tag].init(repeating: tag, count: 10)
        
        searchResults = [
        .episodes: dummyEpisodes,
        .series: dummySeries,
        .people: dummyUsers,
        .tags: dummyTags]
        
        for viewController in viewControllers {
            guard let searchTableViewController = viewController as? SearchTableViewController else { break }
            searchTableViewController.searchResults = searchResults
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func scrollToViewController(_ vc: UIViewController) {
        pageViewController.setViewControllers([vc], direction: .forward, animated: false, completion: nil)
        let index = viewControllers.index(of: vc)!
        tabDelegate?.selectedTabDidChange(toNewIndex: index)
        scrollDelegate?.scrollViewDidChange()
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let index = viewControllers.index(of: viewController), index != 0 else { return nil }
        
        return viewControllers[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let index = viewControllers.index(of: viewController), index != viewControllers.count - 1 else { return nil }
        
        return viewControllers[index + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let currentViewController = pageViewController.viewControllers!.first! as! SearchTableViewController
        let index = viewControllers.index(of: currentViewController)!
        tabDelegate?.selectedTabDidChange(toNewIndex: index)
        scrollDelegate?.scrollViewDidChange()
    }
    
    //MARK: -
    //MARK: Tab Bar Delegate
    //MARK: -
    
    func selectedTabDidChange(toNewIndex newIndex: Int) {
        guard let currentViewController = pageViewController.viewControllers?.first as? SearchTableViewController,
            let currentIndex = viewControllers.index(of: currentViewController),
            newIndex != currentIndex else { return }
        
        let direction: UIPageViewControllerNavigationDirection = newIndex < currentIndex ? .reverse : .forward
        pageViewController.setViewControllers([viewControllers[newIndex]], direction: direction, animated: true, completion: nil)
        updateCurrentViewControllerTableView()
        
        scrollDelegate?.scrollViewDidChange()
    }
    
    func pluckCurrentScrollView() -> UIScrollView {
        guard let currentViewController = pageViewController.viewControllers?.first as? SearchTableViewController else { return UIScrollView() }
        return currentViewController.tableView
    }
    
    func scrollGestureDidScroll(_ offset: CGPoint) {
        guard let currentViewController = pageViewController.viewControllers?.first as? SearchTableViewController else { return }
        currentViewController.tableView.setContentOffset(offset, animated: false)
    }
    
    //MARK: -
    //MARK: UISearchResultsUpdating
    //MARK: -
    
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        updateCurrentViewControllerTableView()
        searchController.searchResultsController?.view.isHidden = false
    }
    
    func updateCurrentViewControllerTableView() {
        guard let currentViewController = viewControllers[tabBar.selectedIndex] as? SearchTableViewController else { return }
        
        switch currentViewController.searchType {
        case .episodes:
            break
        case .series:
            break
        case .people:
            break
        case .tags:
            break
        }
        currentViewController.tableView.reloadData()
    }
    
    //MARK: -
    //MARK: SearchTableViewControllerDelegate
    //MARK: -
    func searchTableViewController(controller: SearchTableViewController, didTapSearchResultOfType searchType: SearchType, index: Int) {
        let dummyViewController = UIViewController()
        dummyViewController.view.backgroundColor = .white
        presentingViewController?.navigationController?.pushViewController(dummyViewController, animated: true)
    }
}
