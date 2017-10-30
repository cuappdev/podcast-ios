//
//  SearchTableViewController.swift
//  Podcast
//
//  Created by Kevin Greer on 3/3/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

enum SearchType {
    case episodes
    case series
    case people
    case itunes
    case all
    
    func toString() -> String {
        switch self {
        case .episodes:
            return "Episodes"
        case .series:
            return "Series"
        case .people:
            return "People"
        case .itunes:
            return "iTunes"
        case .all:
            return "All"
        }
    }
}

protocol SearchTableViewControllerDelegate {
    func searchTableViewController(controller: SearchTableViewController, didTapSearchResultOfType searchType: SearchType, index: Int)
    func searchTableViewControllerNeedsFetch(controller: SearchTableViewController)
}

class SearchTableViewController: ViewController, UITableViewDelegate, UITableViewDataSource, SearchEpisodeTableViewCellDelegate, SearchSeriesTableViewDelegate, SearchPeopleTableViewDelegate {
    
    var searchType: SearchType = .episodes
    let cellIdentifiersClasses: [SearchType: (String, AnyClass)] =
        [.episodes: ("EpisodeCell", SearchEpisodeTableViewCell.self),
         .series: ("SeriesCell", SearchSeriesTableViewCell.self),
         .people: ("PeopleCell", SearchPeopleTableViewCell.self)]
    
    let cellHeights: [SearchType: CGFloat] =
        [.episodes: 84,
         .series: 95,
         .people: 76]
    
    var searchResults: [SearchType: [Any]] = [
        .episodes: [],
        .series: [],
        .people: []]
    
    var cellDelegate: SearchTableViewControllerDelegate?
    var loadingIndicatorView: NVActivityIndicatorView?
    var tableView: EmptyStateTableView = EmptyStateTableView(withType: .search) //no delegate because no action button
    
    var continueInfiniteScroll: Bool = true
    var currentlyPlayingIndexPath: IndexPath?
    
    var searchITunesView: UIView?
    var descriptionLabel: UILabel?
    var dividerLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let (cellIdentifier, cellClass) = cellIdentifiersClasses[searchType] else { return }
        tableView.frame = view.frame
        tableView.register(cellClass, forCellReuseIdentifier: cellIdentifier)
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self 
        tableView.infiniteScrollIndicatorView = createLoadingAnimationView()
        tableView.addInfiniteScroll { tableView in
            self.fetchData(completion: nil)
        }
        //tells the infinite scroll when to stop
        tableView.setShouldShowInfiniteScrollHandler { _ -> Bool in
            return self.continueInfiniteScroll
        }
        view.addSubview(tableView)
        mainScrollView = tableView
        
        automaticallyAdjustsScrollViewInsets = true
        loadingIndicatorView = createLoadingAnimationView()
        loadingIndicatorView!.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
        view.addSubview(loadingIndicatorView!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let indexPath = currentlyPlayingIndexPath, let cell = tableView.cellForRow(at: indexPath) as? SearchEpisodeTableViewCell {
            cell.setPlayButtonToState(isPlaying: false)
        }
        currentlyPlayingIndexPath = nil
    }
    
    func setupSearchITunesHeader() {
        // constants
        let headerHeight: CGFloat = 79.5
        let topPadding: CGFloat = 12.5
        let bottomPadding: CGFloat = 25
        let leftPadding: CGFloat = 17.5
        let rightPadding: CGFloat = 36.5
        let dividerHeight: CGFloat = 12
        
        searchITunesView = UIView(frame: .zero)
        searchITunesView?.backgroundColor = .offWhite
        searchITunesView?.isUserInteractionEnabled = true
        tableView.tableHeaderView = searchITunesView

        descriptionLabel = UILabel(frame: .zero)
        descriptionLabel?.font = ._14RegularFont()
        descriptionLabel?.textAlignment = .left
        descriptionLabel?.numberOfLines = 2
        descriptionLabel?.textColor = .slateGrey
        let attributedString = NSMutableAttributedString(string: "Can’t find a series you’re looking for? You can now search iTunes directly.")
        attributedString.addAttribute(.foregroundColor, value: UIColor.sea, range: NSRange(location: 52, length: 13))
        attributedString.addAttribute(.foregroundColor, value: UIColor.slateGrey, range: NSRange(location: 66, length: 9))
        descriptionLabel?.attributedText = attributedString
        descriptionLabel?.isUserInteractionEnabled = true
        searchITunesView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(setSearchTypeToITunes(_:))))
        searchITunesView?.addSubview(descriptionLabel!)
        
        descriptionLabel?.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(leftPadding)
            make.trailing.equalToSuperview().inset(rightPadding)
            make.top.equalToSuperview().offset(topPadding)
            make.bottom.equalToSuperview().inset(bottomPadding)
        }
        
        dividerLabel = UILabel(frame: .zero)
        dividerLabel?.backgroundColor = .paleGrey
        searchITunesView?.addSubview(dividerLabel!)
        
        dividerLabel?.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(dividerHeight)
            make.bottom.equalToSuperview()
        }
        
        searchITunesView?.snp.makeConstraints { make in
            make.width.top.centerX.equalToSuperview()
            make.height.equalTo(headerHeight)
        }
        
    }
    
    @objc func setSearchTypeToITunes(_ tapGestureRecognizer: UITapGestureRecognizer) {
//        searchType = .itunes
        if tapGestureRecognizer.didTapAttributedTextInLabel(label: descriptionLabel!, inRange: NSRange(location: 52, length: 13)) {
            print("Tapped")
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        updateTableViewInsetsForAccessoryView()
        return searchResults[searchType]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[searchType] ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let (cellIdentifier, _) = cellIdentifiersClasses[searchType], let results = searchResults[searchType] else { return UITableViewCell() }
        
        switch searchType {
        case .episodes:
            guard let episodes = results as? [Episode], let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? SearchEpisodeTableViewCell else { return UITableViewCell() }
            cell.configure(for: episodes[indexPath.row], index: indexPath.row)
            if indexPath == currentlyPlayingIndexPath {
                cell.setPlayButtonToState(isPlaying: true)
            } else {
                cell.setPlayButtonToState(isPlaying: false)
            }
            cell.delegate = self
            return cell
        case .series, .itunes:
            guard let series = results as? [Series], let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? SearchSeriesTableViewCell else { return UITableViewCell() }
            cell.configure(for: series[indexPath.row], index: indexPath.row)
            cell.delegate = self
            return cell
        case .people:
            guard let people = results as? [User], let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? SearchPeopleTableViewCell else{ return UITableViewCell() }
            cell.configure(for: people[indexPath.row], index: indexPath.row)
            cell.delegate = self
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellDelegate?.searchTableViewController(controller: self, didTapSearchResultOfType: searchType, index: indexPath.row)
    }
        
    func fetchData(completion: (() -> ())?)  {
        cellDelegate?.searchTableViewControllerNeedsFetch(controller: self)
        completion?()
    }
    
    class func buildListOfAllSearchTableViewControllerTypes() -> [SearchTableViewController] {
        let searchTableViewControllerEpisodes = SearchTableViewController()
        searchTableViewControllerEpisodes.searchType = .episodes
        
        let searchTableViewControllerSeries = SearchTableViewController()
        searchTableViewControllerSeries.setupSearchITunesHeader()
        searchTableViewControllerSeries.searchType = .series
        
        let searchTableViewControllerPeople = SearchTableViewController()
        searchTableViewControllerPeople.searchType = .people

        return [searchTableViewControllerEpisodes, searchTableViewControllerSeries, searchTableViewControllerPeople]
    }
    
    func searchEpisodeTableViewCellDidPressPlayButton(cell: SearchEpisodeTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell), indexPath != currentlyPlayingIndexPath, let episode = searchResults[.episodes]?[indexPath.row] as? Episode, let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        if let previousIndexPath = currentlyPlayingIndexPath, let previousCell = tableView.cellForRow(at: previousIndexPath) as? SearchEpisodeTableViewCell {
            previousCell.setPlayButtonToState(isPlaying: false)
        }
        currentlyPlayingIndexPath = indexPath
        cell.setPlayButtonToState(isPlaying: true)
        appDelegate.showPlayer(animated: true)
        Player.sharedInstance.playEpisode(episode: episode)
        let historyRequest = CreateListeningHistoryElementEndpointRequest(episodeID: episode.id)
        System.endpointRequestQueue.addOperation(historyRequest)
    }
    
    func searchSeriesTableViewCellDidPressSubscribeButton(cell: SearchSeriesTableViewCell) {
        guard let indexPath = tableView.indexPath(for:cell), let series = searchResults[.series]?[indexPath.row] as? Series else { return }
        series.isSubscribed = !series.isSubscribed
        if series.isSubscribed {
            let createSubscriptionEndpointRequest = CreateUserSubscriptionEndpointRequest(seriesID: series.seriesId)
            createSubscriptionEndpointRequest.success = { (endpointRequest: EndpointRequest) in
                series.isSubscribed = true
                cell.setSubscribeButtonToState(isSubscribed: series.isSubscribed)
            }
            createSubscriptionEndpointRequest.failure = { (endpointRequest: EndpointRequest) in
                series.isSubscribed = false
                cell.setSubscribeButtonToState(isSubscribed: series.isSubscribed)
            }
            System.endpointRequestQueue.addOperation(createSubscriptionEndpointRequest)
        } else {
            let deleteSubscriptionEndpointRequest = DeleteUserSubscriptionEndpointRequest(seriesID: String(series.seriesId))
            deleteSubscriptionEndpointRequest.success = { (endpointRequest: EndpointRequest) in
                series.isSubscribed = false
                cell.setSubscribeButtonToState(isSubscribed: series.isSubscribed)
            }
            deleteSubscriptionEndpointRequest.failure = { (endpointRequest: EndpointRequest) in
                series.isSubscribed = true
                cell.setSubscribeButtonToState(isSubscribed: series.isSubscribed)
            }
            System.endpointRequestQueue.addOperation(deleteSubscriptionEndpointRequest)
        }
    }
    
    func searchPeopleTableViewCell(cell: SearchPeopleTableViewCell, didSetFollowButton toNewValue: Bool) {
        guard let indexPath = tableView.indexPath(for:cell), let user = searchResults[.people]?[indexPath.row] as? User else { return }
        user.isFollowing = !user.isFollowing
        if user.isFollowing {
            let createFollowEndpointRequest = FollowUserEndpointRequest(userID: user.id)
            createFollowEndpointRequest.success = { (endpointRequest: EndpointRequest) in
                user.isFollowing = true
                cell.setFollowButtonState(isFollowing: true)
            }
            createFollowEndpointRequest.failure = { (endpointRequest: EndpointRequest) in
                user.isFollowing = false
                cell.setFollowButtonState(isFollowing: false)
            }
            System.endpointRequestQueue.addOperation(createFollowEndpointRequest)
        } else {
            let deleteFollowEndpointRequest = UnfollowUserEndpointRequest(userID: user.id)
            deleteFollowEndpointRequest.success = { (endpointRequest: EndpointRequest) in
                user.isFollowing = false
                cell.setFollowButtonState(isFollowing: false)
            }
            deleteFollowEndpointRequest.failure = { (endpointRequest: EndpointRequest) in
                user.isFollowing = true
                cell.setFollowButtonState(isFollowing: true)
            }
            System.endpointRequestQueue.addOperation(deleteFollowEndpointRequest)
        }
    }
}
