//
//  FeedViewController.swift
//  Podcast
//
//  Created by Mark Bryan on 9/7/16.
//  Copyright © 2016 Cornell App Development. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import SnapKit

class FeedViewController: ViewController, UITableViewDelegate, UITableViewDataSource, FeedElementTableViewCellDelegate, EmptyStateTableViewDelegate {
    
    ///
    /// Mark: Constants
    ///
    var lineHeight: CGFloat = 3
    var topButtonHeight: CGFloat = 30
    var topViewHeight: CGFloat = 60

    ///
    /// Mark: Variables
    ///
    var feedTableView: EmptyStateTableView!
    var feedElements: [FeedElement] = []
    var currentlyPlayingIndexPath: IndexPath?
    var refreshControl: UIRefreshControl!
    let pageSize = 20
    var continueInfiniteScroll = true
    var feedSet: Set = Set<FeedElement>()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .paleGrey
        title = "Feed"

        //tableview
        feedTableView = EmptyStateTableView(frame: view.frame, type: .feed)
        feedTableView.emptyStateTableViewDelegate = self 
        feedTableView.delegate = self
        feedTableView.dataSource = self
        feedTableView.register(FeedElementTableViewCell.self, forCellReuseIdentifier: "FeedElementTableViewCellIdentifier")
        mainScrollView = feedTableView
        view.addSubview(feedTableView)
        feedTableView.rowHeight = UITableViewAutomaticDimension
        feedTableView.reloadData()
        feedTableView.addInfiniteScroll { (tableView) -> Void in
            self.fetchCards(isPullToRefresh: false)
        }
        //tells the infinite scroll when to stop
        feedTableView.setShouldShowInfiniteScrollHandler { _ -> Bool in
            return self.continueInfiniteScroll
        }
        
        feedTableView.infiniteScrollIndicatorView = createLoadingAnimationView()

        refreshControl = UIRefreshControl()
        refreshControl.tintColor = .sea
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: UIControlEvents.valueChanged)
        feedTableView.addSubview(refreshControl)

        fetchCards(isPullToRefresh: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        feedTableView.reloadData()
        // check before reloading data whether the Player has stopped playing the currentlyPlayingIndexPath
        if let indexPath = currentlyPlayingIndexPath, let episode = feedElements[indexPath.row].subject as? Episode, Player.sharedInstance.currentEpisode?.id != episode.id {
            currentlyPlayingIndexPath = nil
        }
    }
    
    @objc func handleRefresh() {
        fetchCards(isPullToRefresh: true)
        refreshControl.endRefreshing()
    }


    //MARK: -
    //MARK: TableView DataSource
    //MARK: -

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedElements.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FeedElementTableViewCellIdentifier") as? FeedElementTableViewCell else { return  UITableViewCell() }
        cell.delegate = self
        cell.setupWithFeedElement(feedElement: feedElements[indexPath.row])
        cell.layoutSubviews()
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let episode = feedElements[indexPath.row].subject as? Episode {
            let viewController = EpisodeDetailViewController()
            viewController.episode = episode
            navigationController?.pushViewController(viewController, animated: true)
            return
        }
        
        if let series = feedElements[indexPath.row].subject as? Series {
            let viewController = SeriesDetailViewController(series: series)
            navigationController?.pushViewController(viewController, animated: true)
            return
        }
    }

    func didPressEmptyStateViewActionItem() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate, let tabBarController = appDelegate.tabBarController else { return }
        tabBarController.programmaticallyPressTabBarButton(atIndex: System.searchTab)
    }
    
    //MARK: -
    //MARK: Delegate
    //MARK: -
    
    func feedElementTableViewCellDidPressEpisodeSubjectViewMoreButton(feedElementTableViewCell: FeedElementTableViewCell, episodeSubjectView: EpisodeSubjectView) {
        guard let indexPath = feedTableView.indexPath(for: feedElementTableViewCell), let episode = feedElements[indexPath.row].subject as? Episode else { return }
    
        let option1 = ActionSheetOption(type: .download(selected: episode.isDownloaded), action: nil)

        var header: ActionSheetHeader?
        
        if let image = episodeSubjectView.podcastImage?.image, let title = episodeSubjectView.episodeNameLabel.text, let description = episodeSubjectView.dateTimeLabel.text {
            header = ActionSheetHeader(image: image, title: title, description: description)
        }
        
        let actionSheetViewController = ActionSheetViewController(options: [option1], header: header)
        showActionSheetViewController(actionSheetViewController: actionSheetViewController)
    }
    
    func feedElementTableViewCellDidPressEpisodeSubjectViewPlayPauseButton(feedElementTableViewCell: FeedElementTableViewCell, episodeSubjectView: EpisodeSubjectView) {
        guard let feedElementIndexPath = feedTableView.indexPath(for: feedElementTableViewCell), let appDelegate = UIApplication.shared.delegate as? AppDelegate, let episode = feedElements[feedElementIndexPath.row].subject as? Episode else { return }
        
        if feedElementIndexPath == currentlyPlayingIndexPath {
            episodeSubjectView.episodeUtilityButtonBarView.setPlayButtonToState(isPlaying: false)
            Player.sharedInstance.pause()
            return
        }
        
        currentlyPlayingIndexPath = feedElementIndexPath
        episodeSubjectView.episodeUtilityButtonBarView.setPlayButtonToState(isPlaying: true)
        appDelegate.showPlayer(animated: true)
        Player.sharedInstance.playEpisode(episode: episode)
    }
    
    func feedElementTableViewCellDidPressEpisodeSubjectViewBookmarkButton(feedElementTableViewCell: FeedElementTableViewCell, episodeSubjectView: EpisodeSubjectView) {
        guard let indexPath = feedTableView.indexPath(for: feedElementTableViewCell), let episode = feedElements[indexPath.row].subject as? Episode else { return }
        episode.bookmarkChange(completion: episodeSubjectView.episodeUtilityButtonBarView.setBookmarkButtonToState)
    }
    
    func feedElementTableViewCellDidPressEpisodeSubjectViewTagButton(feedElementTableViewCell: FeedElementTableViewCell, episodeSubjectView: EpisodeSubjectView, index: Int) {
        guard let feedElementIndexPath = feedTableView.indexPath(for: feedElementTableViewCell) else { return }
//        let tagViewController = TagViewController()
//        tagViewController.tag = (feedElements[feedElementIndexPath.row].subject as! Episode).tags[index]
        navigationController?.pushViewController(UnimplementedViewController(), animated: true)
    }
    
    func feedElementTableViewCellDidPressEpisodeSubjectViewRecommendedButton(feedElementTableViewCell: FeedElementTableViewCell, episodeSubjectView: EpisodeSubjectView) {
        guard let indexPath = feedTableView.indexPath(for: feedElementTableViewCell), let episode = feedElements[indexPath.row].subject as? Episode else { return }
        let completion = episodeSubjectView.episodeUtilityButtonBarView.setRecommendedButtonToState
        episode.recommendedChange(completion: completion)
    }
    
    func feedElementTableViewCellDidPressSupplierViewFeedControlButton(feedElementTableViewCell: FeedElementTableViewCell, supplierView: UserSeriesSupplierView) {
        print("Pressed Feed Control")
    }
    
    func feedElementTableViewCellDidPressSeriesSubjectViewSubscribeButton(feedElementTableViewCell: FeedElementTableViewCell, seriesSubjectView: SeriesSubjectView) {
        guard let indexPath = feedTableView.indexPath(for: feedElementTableViewCell), let series = feedElements[indexPath.row].subject as? Series else { return }
        series.subscriptionChange(completion: seriesSubjectView.updateViewWithSubscribeState)
    }
    

    //MARK
    //MARK - Endpoint Requests
    //MARK

    func fetchCards(isPullToRefresh: Bool) {
        let maxtime = Int(Date().timeIntervalSince1970)
        if !isPullToRefresh {
            // TODO: retreive the time of the last element once FeedElements are used in this VC
        }

        let fetchFeedEndpointRequest = FetchFeedEndpointRequest(maxtime: maxtime, pageSize: pageSize)

        fetchFeedEndpointRequest.success = { (endpoint) in
            guard let feedElementsFromEndpoint = endpoint.processedResponseValue as? [FeedElement] else { return }

            for feedElement in feedElementsFromEndpoint {
                self.feedSet.insert(feedElement)
            }

            self.feedElements = self.feedSet.sorted { (fe1,fe2) in fe1.time < fe2.time }
            if !isPullToRefresh {
                if self.feedElements.count < self.pageSize {
                    self.continueInfiniteScroll = false
                }
            }

            self.feedTableView.stopLoadingAnimation()
            self.feedTableView.reloadData()
        }

        System.endpointRequestQueue.addOperation(fetchFeedEndpointRequest)
    }
}

