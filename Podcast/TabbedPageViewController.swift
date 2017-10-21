//
//  TabbedPageViewController.swift
//  Podcast
//
//  Created by Eric Appel on 11/1/15.
//  Copyright © 2015 CUAppDev. All rights reserved.
//

import UIKit
import SnapKit 

protocol TabbedPageViewControllerDelegate: class {
    func selectedTabDidChange(toNewIndex newIndex: Int)
}

protocol TabbedPageViewControllerScrollDelegate: class {
    func scrollViewDidChange()
}

protocol TabbedViewControllerSearchResultsControllerDelegate: class {
    func didTapOnSeriesCell(series: Series)
    func didTapOnTagCell(tag: Tag)
    func didTapOnEpisodeCell(episode: Episode)
}

class TabbedPageViewController: ViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, UISearchResultsUpdating, TabBarDelegate, SearchTableViewControllerDelegate, UINavigationControllerDelegate {
    
    let tabBarHeight: CGFloat = 44
    var tabBarY: CGFloat = 0
    
    var viewControllers: [UIViewController]!
    
    weak var tabDelegate: TabbedPageViewControllerDelegate?
    weak var scrollDelegate: TabbedPageViewControllerScrollDelegate?
    weak var searchResultsDelegate: TabbedViewControllerSearchResultsControllerDelegate?
    var tabBar: UnderlineTabBarView!
    let tabSections: [SearchType] = [.episodes, .series, .people]
    
    var pageViewController: UIPageViewController!
    
    var searchText: String = ""
    var searchDelayTimer: Timer?
    var searchDelayBlock: (() -> ())?
    
    var searchResults: [SearchType: [Any]] = [
        .episodes: [],
        .series: [],
        .people: []]
    
    let pageSize = 20
    var sectionOffsets: [SearchType: Int] = [
        .episodes: 0,
        .series: 0,
        .people: 0]
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .paleGrey
        automaticallyAdjustsScrollViewInsets = false
        
        tabBar = UnderlineTabBarView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: tabBarHeight))
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
        pageViewController.view.backgroundColor = .offWhite
        let pageVCYOffset: CGFloat = tabBar.frame.maxY + 1 // get a small line between the start of the table view
        let pageVCHeight = view.frame.height - pageVCYOffset - tabBarHeight - 1
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
        guard let searchText = searchController.searchBar.text else { return }
        self.searchText = searchText
        self.sectionOffsets = [.episodes: 0, .series: 0, .people: 0]
        self.fetchData(type: .all, query: searchText, offset: 0, max: self.pageSize)
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
    
    @objc func searchAfterDelay() {
        searchDelayBlock?()
    }
    
    //stop animating all loading indicators
    func stopAllLoadingAnimations() {
        for viewController in self.viewControllers {
            guard let searchTableViewController = viewController as? SearchTableViewController else { break }
            searchTableViewController.loadingIndicatorView?.stopAnimating()
        }
    }
    
    //start animating all loading indicators where vc's have empty results
    func startAllLoadingAnimations() {
        for viewController in viewControllers {
            guard let searchTableViewController = viewController as? SearchTableViewController else { break }
            if searchTableViewController.searchResults[searchTableViewController.searchType]?.count == 0 {
                searchTableViewController.loadingIndicatorView?.startAnimating()
            }
        }
    }
    
    func fetchData(type: SearchType, query: String, offset: Int, max: Int) {
        searchEndpointRequest(query: query, offset: offset, max: max, searchType: type)
    }
    
    //MARK: -
    //MARK: SearchTableViewControllerDelegate
    //MARK: -
    func searchTableViewController(controller: SearchTableViewController, didTapSearchResultOfType searchType: SearchType, index: Int) {
        //add new views here
        switch(searchType) {
        case .episodes:
            guard let episode = searchResults[.episodes]?[index] as? Episode else { return }
            searchResultsDelegate?.didTapOnEpisodeCell(episode: episode)
        case .series:
            guard let series = searchResults[.series]?[index] as? Series else { return }
            searchResultsDelegate?.didTapOnSeriesCell(series: series)
        case .people:
            //present external profile view here
            guard let user = searchResults[.people]?[index] as? User else { return }
            let externalProfileViewController = ExternalProfileViewController()
            externalProfileViewController.fetchUser(id: user.id)
            presentingViewController?.navigationController?.pushViewController(externalProfileViewController, animated: true)
        default:
            break
        }
    }
    
    func searchTableViewControllerNeedsFetch(controller: SearchTableViewController) {
        fetchData(type: controller.searchType, query: searchText, offset: sectionOffsets[controller.searchType] ?? 0, max: pageSize)
    }
    
    ///
    /// MARK: Networking
    ///
    
    func searchEndpointRequest(query: String, offset: Int, max: Int, searchType: SearchType) {
        System.endpointRequestQueue.cancelAllEndpointRequestsOfType(type: SearchEpisodesEndpointRequest.self)
        System.endpointRequestQueue.cancelAllEndpointRequestsOfType(type: SearchUsersEndpointRequest.self)
        System.endpointRequestQueue.cancelAllEndpointRequestsOfType(type: SearchSeriesEndpointRequest.self)
        
        var request: EndpointRequest
        switch (searchType) {
        case .episodes:
            request = SearchEpisodesEndpointRequest(query: query, offset: offset, max: max)
        case .series:
            request = SearchSeriesEndpointRequest(query: query, offset: offset, max: max)
        case .people:
            request = SearchUsersEndpointRequest(query: query, offset: offset, max: max)
        case .all:
            request = SearchAllEndpointRequest(query: query, offset: offset, max: max)
        default:
            request = EndpointRequest()
        }
        if searchType != .all {
            request.success = { request in
                guard let results = request.processedResponseValue as? [Any] else { return }
                let oldCount = self.searchResults[searchType]?.count ?? 0
                self.searchResults[searchType]!.append(contentsOf: results)
                let (start, end) = (oldCount, oldCount + results.count)
                self.updateCurrentViewControllerTableView(append: true, indexBounds: (start, end))
                self.sectionOffsets[searchType]? += self.pageSize
            }
        } else {
            self.startAllLoadingAnimations()
            request.success = { request in
                guard let results = request.processedResponseValue as? [SearchType: [Any]] else { return }
                self.searchResults = results
                self.updateCurrentViewControllerTableView(append: false, indexBounds: nil)
                self.sectionOffsets = [.episodes: self.pageSize, .series: self.pageSize, .people: self.pageSize]
                self.stopAllLoadingAnimations()
            }
        }
        System.endpointRequestQueue.addOperation(request)
    }
}
