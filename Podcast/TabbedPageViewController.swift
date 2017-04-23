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

protocol TabbedViewControllerSearchResultsControllerDelegate: class {
    func didTapOnSeriesCell(series: Series)
    func didTapOnTagCell(tag: Tag)
    func didTapOnEpisodeCell(episode: Episode)
}

protocol SearchRequestsDelegate: class {
    func didRequestSearch(text: String)
}

class TabbedPageViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, UISearchResultsUpdating, TabBarDelegate, SearchTableViewControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    let TabBarHeight: CGFloat = 44
    
    var viewControllers: [UIViewController]!
    
    weak var tabDelegate: TabbedPageViewControllerDelegate?
    weak var scrollDelegate: TabbedPageViewControllerScrollDelegate?
    weak var searchResultsDelegate: TabbedViewControllerSearchResultsControllerDelegate?
    weak var searchRequestsDelegate: SearchRequestsDelegate?
    var tabBar: UnderlineTabBarView!
    let tabSections: [SearchType] = [.episodes, .series, .people, .tags]
    
    var pageViewController: UIPageViewController!
    var pastSearchesTableView: UITableView!
    
    var searchText: String = ""
    var searchDelayTimer: Timer?
    var searchDelayBlock: (() -> ())?
    
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
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
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
        
        pastSearchesTableView = UITableView(frame: CGRect(x: 0, y: 64, width: view.frame.width, height: view.frame.height - appDelegate.tabBarController.tabBarHeight))
        pastSearchesTableView.register(PastSearchTableViewCell.self, forCellReuseIdentifier: "PastSearchCell")
        pastSearchesTableView.delegate = self
        pastSearchesTableView.dataSource = self
        pastSearchesTableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.addSubview(pastSearchesTableView)
        view.bringSubview(toFront: pastSearchesTableView)
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
        guard let searchText = searchController.searchBar.text else { return }
        
        if searchText == "" {
            view.addSubview(pastSearchesTableView)
            view.bringSubview(toFront: pastSearchesTableView)
            return
        }
        
        if pastSearchesTableView.superview == view {
            pastSearchesTableView.removeFromSuperview()
        }
    
        if let timer = searchDelayTimer {
            timer.invalidate()
            searchDelayTimer = nil
        }
        
        searchDelayBlock = {
            self.searchText = searchText
            self.sectionOffsets = [.episodes: 0, .series: 0, .people: 0, .tags: 0]
            self.fetchData(type: .all, query: searchText, offset: 0, max: self.pageSize)
            searchController.searchResultsController?.view.isHidden = false
        }
        
        searchDelayTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(searchAfterDelay), userInfo: nil, repeats: false)
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
    
    func searchAfterDelay() {
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
            self.startAllLoadingAnimations()
            let request = SearchAllEndpointRequest(query: query, offset: offset, max: max)
            request.success = { request in
                guard let results = request.processedResponseValue as? [SearchType: [Any]] else { return }
                self.searchResults = results
                self.updateCurrentViewControllerTableView(append: false, indexBounds: nil)
                self.sectionOffsets = [.episodes: self.pageSize, .series: self.pageSize, .people: self.pageSize, .tags: self.pageSize]
                self.stopAllLoadingAnimations()
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
            let dummyViewController = UIViewController()
            presentingViewController?.navigationController?.pushViewController(dummyViewController, animated: true)
        case .tags:
            //present tag view here
            guard let tag = searchResults[.tags]?[index] as? Tag else { return }
            searchResultsDelegate?.didTapOnTagCell(tag: tag)
        default:
            break
        }
    }
    
    func searchTableViewControllerNeedsFetch(controller: SearchTableViewController) {
        fetchData(type: controller.searchType, query: searchText, offset: sectionOffsets[controller.searchType] ?? 0, max: pageSize)
    }
    
    //MARK: -
    //MARK: UITableViewDelegate & Data source
    //MARK: -
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PastSearchCell") as? PastSearchTableViewCell else { return UITableViewCell() }
        guard let pastSearches = UserDefaults.standard.array(forKey: "PastSearches") as? [String] else {
            cell.configureNoPastSearches()
            return cell
        }
        cell.label.text = pastSearches[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let pastSearches = UserDefaults.standard.array(forKey: "PastSearches") as? [String] {
            return pastSearches.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return PastSearchTableViewCell.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let pastSearches = UserDefaults.standard.array(forKey: "PastSearches") as? [String] else { return }
        searchRequestsDelegate?.didRequestSearch(text: pastSearches[indexPath.row])
    }
}
