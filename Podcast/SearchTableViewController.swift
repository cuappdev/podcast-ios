//
//  SearchTableViewController.swift
//  Podcast
//
//  Created by Kevin Greer on 3/3/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

enum SearchType {
    case episodes
    case series
    case people
    case tags
    
    var string: String {
        switch self {
        case .episodes:
            return "Episodes"
        case .series:
            return "Series"
        case .people:
            return "People"
        case .tags:
            return "Tags"
        }
    }
}

protocol SearchTableViewControllerDelegate {
    func searchTableViewController(controller: SearchTableViewController, didTapSearchResultOfType searchType: SearchType, index: Int)
    func searchTableViewControllerNeedsFetch(controller: SearchTableViewController)
}

class SearchTableViewController: UITableViewController {
    
    var searchType: SearchType = .episodes
    let cellIdentifiersClasses: [SearchType: (String, AnyClass)] =
        [.episodes: ("EpisodeCell", SearchEpisodeTableViewCell.self),
         .series: ("SeriesCell", SearchSeriesTableViewCell.self),
         .people: ("PeopleCell", SearchPeopleTableViewCell.self),
         .tags: ("TagCell", SearchTagTableViewCell.self)]
    let cellHeights: [SearchType: CGFloat] =
        [.episodes: 84,
         .series: 95,
         .people: 76,
         .tags: 53]
    
    var searchResults: [SearchType: [Any]] = [
        .episodes: [],
        .series: [],
        .people: [],
        .tags: []]
    
    var cellDelegate: SearchTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let (cellIdentifier, cellClass) = cellIdentifiersClasses[searchType] else { return }
        tableView.register(cellClass, forCellReuseIdentifier: cellIdentifier)
        tableView.showsVerticalScrollIndicator = false
        
        tableView.addInfiniteScroll { tableView in
            self.fetchData {
//                tableView.finishInfiniteScroll()
            }
        }
        
//        tableView.setShouldShowInfiniteScrollHandler { [weak self] (tableView) -> Bool in
//            // Only show up to 5 pages then prevent the infinite scroll
//            return (self?.currentPage < 2);
//        }        
    }
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        if useAutosizingCells && tableView.responds(to: #selector(getter: UIView.layoutMargins)) {
//            tableView.estimatedRowHeight = 88
//            tableView.rowHeight = UITableViewAutomaticDimension
//        }
//        
//        // Set custom indicator margin
//        tableView.infiniteScrollIndicatorMargin = 40
//        
//        // Set custom trigger offset
//        tableView.infiniteScrollTriggerOffset = 500
//        
//        // Add infinite scroll handler
//        tableView.addInfiniteScroll { [weak self] (tableView) -> Void in
//            self?.performFetch {
//                tableView.finishInfiniteScroll()
//            }
//        }
//        
//        // Uncomment this to provide conditionally prevent the infinite scroll from triggering
//        /*
//         tableView.setShouldShowInfiniteScrollHandler { [weak self] (tableView) -> Bool in
//         // Only show up to 5 pages then prevent the infinite scroll
//         return (self?.currentPage < 5);
//         }
//         */
//        
//        // load initial data
//        tableView.beginInfiniteScroll(true)
//    }
    
//    fileprivate func performFetch(_ completionHandler: ((Void) -> Void)?) {
//        fetchData { (fetchResult) in
//            do {
//                let (newStories, pageCount, nextPage) = try fetchResult()
//                
//                // create new index paths
//                let storyCount = self.stories.count
//                let (start, end) = (storyCount, newStories.count + storyCount)
//                let indexPaths = (start..<end).map { return IndexPath(row: $0, section: 0) }
//                
//                // update data source
//                self.stories.append(contentsOf: newStories)
//                self.numPages = pageCount
//                self.currentPage = nextPage
//                
//                // update table view
//                self.tableView.beginUpdates()
//                self.tableView.insertRows(at: indexPaths, with: .automatic)
//                self.tableView.endUpdates()
//            } catch {
//                self.showAlertWithError(error)
//            }
//            
//            completionHandler?()
//        }
//    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults[searchType]?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[searchType] ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let (cellIdentifier, _) = cellIdentifiersClasses[searchType], let results = searchResults[searchType] else { return UITableViewCell() }
        
        switch searchType {
        case .episodes:
            guard let episodes = results as? [Episode], let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? SearchEpisodeTableViewCell else { return UITableViewCell() }
            cell.configure(for: episodes[indexPath.row], index: indexPath.row)
            return cell
        case .series:
            guard let series = results as? [Series], let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? SearchSeriesTableViewCell else { return UITableViewCell() }
            cell.configure(for: series[indexPath.row], index: indexPath.row)
            return cell
        case .people:
            guard let people = results as? [User], let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? SearchPeopleTableViewCell else{ return UITableViewCell() }
            cell.configure(for: people[indexPath.row], index: indexPath.row)
            return cell
        case .tags:
            guard let tags = results as? [Tag], let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? SearchTagTableViewCell else { return UITableViewCell() }
            cell.configure(tagName: tags[indexPath.row].name, index: indexPath.row)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellDelegate?.searchTableViewController(controller: self, didTapSearchResultOfType: searchType, index: indexPath.row)
    }
        
    func fetchData(_ completionHandler: ((Void) -> Void)?) {
        cellDelegate?.searchTableViewControllerNeedsFetch(controller: self)
        completionHandler?()
    }
    
    class func buildListOfAllSearchTableViewControllerTypes() -> [SearchTableViewController] {
        let searchTableViewControllerEpisodes = SearchTableViewController()
        searchTableViewControllerEpisodes.searchType = .episodes
        
        let searchTableViewControllerSeries = SearchTableViewController()
        searchTableViewControllerSeries.searchType = .series
        
        let searchTableViewControllerPeople = SearchTableViewController()
        searchTableViewControllerPeople.searchType = .people
        
        let searchTableViewControllerTags = SearchTableViewController()
        searchTableViewControllerTags.searchType = .tags

        return [searchTableViewControllerEpisodes, searchTableViewControllerSeries, searchTableViewControllerPeople, searchTableViewControllerTags]
    }
}
