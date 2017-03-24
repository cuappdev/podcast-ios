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
    let tabSections: [SearchType] = [.episodes, .series, .people, .tags]
    
    var pageViewController: UIPageViewController!
    
    var searchText: String = ""
    
    var searchResults: [SearchType: [Any]] = [
        .episodes: [],
        .series: [],
        .people: [],
        .tags: []]
    
    let pageSize = 20
    var sectionOffsets: [SearchType: Int] = [
        .episodes: 0,
        .series: 0,
        .people: 0,
        .tags: 0]
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .podcastGray
        automaticallyAdjustsScrollViewInsets = false
        
        tabBar = UnderlineTabBarView(frame: CGRect(x: 0, y: 64, width: view.frame.width, height: TabBarHeight))
        tabBar.setUp(sections: tabSections.map{ type in type.toString() })
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
        guard let searchText = searchController.searchBar.text, searchText != "" else { return }
        print("updateSearchResults", searchText)
        self.searchText = searchText
        sectionOffsets = [.episodes: 0, .series: 0, .people: 0, .tags: 0]
        fetchData(type: .all, query: searchText, offset: 0, max: pageSize)
        searchController.searchResultsController?.view.isHidden = false
    }
    
    func updateCurrentViewControllerTableView(append: Bool, indexBounds: (Int, Int)?) {
        if append {
            guard let currentViewController = viewControllers[tabBar.selectedIndex] as? SearchTableViewController else { return }
            currentViewController.searchResults = searchResults
            guard let (start, end) = indexBounds else {
                currentViewController.tableView.reloadData()
                return
            }
            let indexPaths = (start..<end).map { return IndexPath(row: $0, section: 0) }
            currentViewController.tableView.beginUpdates()
            currentViewController.tableView.insertRows(at: indexPaths, with: .automatic)
            currentViewController.tableView.endUpdates()
            currentViewController.tableView.finishInfiniteScroll()
            return
        }
        
        // If we are not appending then we are fetching data for all tables
        guard let searchTableViewControllers = viewControllers as? [SearchTableViewController] else { return }
        for viewController in searchTableViewControllers {
            viewController.searchResults = searchResults
            viewController.tableView.reloadData()
        }
    }
    
    func fetchData(type: SearchType, query: String, offset: Int, max: Int) {
        
        System.endpointRequestQueue.cancelAllEndpointRequestsOfType(type: SearchEpisodesEndpointRequest.self)
        System.endpointRequestQueue.cancelAllEndpointRequestsOfType(type: SearchUsersEndpointRequest.self)
        System.endpointRequestQueue.cancelAllEndpointRequestsOfType(type: SearchSeriesEndpointRequest.self)
        System.endpointRequestQueue.cancelAllEndpointRequestsOfType(type: SearchAllEndpointRequest.self)
        
        switch type {
        case .episodes:
            let request = SearchEpisodesEndpointRequest(query: query, offset: offset, max: max)
            request.success = { request in
                guard let episodes = request.processedResponseValue as? [Any] else { return }
                let oldCount = self.searchResults[.episodes]?.count ?? 0
                self.searchResults[.episodes]!.append(contentsOf: episodes)
                let (start, end) = (oldCount, oldCount + episodes.count)
                self.updateCurrentViewControllerTableView(append: true, indexBounds: (start, end))
                self.sectionOffsets[.episodes]? += self.pageSize
            }
            System.endpointRequestQueue.addOperation(request)
        case .series:
            let request = SearchSeriesEndpointRequest(query: query, offset: offset, max: max)
            request.success = { request in
                guard let series = request.processedResponseValue as? [Any] else { return }
                let oldCount = self.searchResults[.series]?.count ?? 0
                self.searchResults[.series]?.append(contentsOf: series)
                let (start, end) = (oldCount, oldCount + series.count)
                self.updateCurrentViewControllerTableView(append: true, indexBounds: (start, end))
                self.sectionOffsets[.series]? += self.pageSize
            }
            System.endpointRequestQueue.addOperation(request)
        case .people:
            let request = SearchUsersEndpointRequest(query: query, offset: offset, max: max)
            request.success = { request in
                guard let users = request.processedResponseValue as? [Any] else { return }
                let oldCount = self.searchResults[.people]?.count ?? 0
                self.searchResults[.people]?.append(contentsOf: users)
                let (start, end) = (oldCount, oldCount + users.count)
                self.updateCurrentViewControllerTableView(append: true, indexBounds: (start, end))
                self.sectionOffsets[.people]? += self.pageSize
            }
            System.endpointRequestQueue.addOperation(request)
        case .all:
            let request = SearchAllEndpointRequest(query: query, offset: offset, max: max)
            request.success = { request in
                guard let results = request.processedResponseValue as? [SearchType: [Any]] else { return }
                self.searchResults = results
                self.updateCurrentViewControllerTableView(append: false, indexBounds: nil)
                self.sectionOffsets = [.episodes: self.pageSize, .series: self.pageSize, .people: self.pageSize, .tags: self.pageSize]
            }
            System.endpointRequestQueue.addOperation(request)
        default:
            break
        }
    }
    
    //MARK: -
    //MARK: SearchTableViewControllerDelegate
    //MARK: -
    func searchTableViewController(controller: SearchTableViewController, didTapSearchResultOfType searchType: SearchType, index: Int) {
        let dummyViewController = UIViewController()
        dummyViewController.view.backgroundColor = .white
        presentingViewController?.navigationController?.pushViewController(dummyViewController, animated: true)
    }
    
    func searchTableViewControllerNeedsFetch(controller: SearchTableViewController) {
        fetchData(type: controller.searchType, query: searchText, offset: sectionOffsets[controller.searchType] ?? 0, max: pageSize)
    }
}
