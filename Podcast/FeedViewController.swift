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

class FeedViewController: ViewController {
    
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
    let pageSize = 20
    var feedMaxTime: Int = Int(Date().timeIntervalSince1970)
    var continueInfiniteScroll = true
    var feedSet: Set = Set<FeedElement>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .paleGrey
        title = "Feed"
        
        //tableview
        feedTableView = EmptyStateTableView(frame: view.frame, type: .feed, isRefreshable:   true)
        feedTableView.emptyStateTableViewDelegate = self
        feedTableView.delegate = self
        feedTableView.dataSource = self
        feedTableView.registerFeedElementTableViewCells()
        mainScrollView = feedTableView
        view.addSubview(feedTableView)
        feedTableView.rowHeight = UITableViewAutomaticDimension
        feedTableView.estimatedRowHeight = 200.0
        feedTableView.reloadData()
        feedTableView.addInfiniteScroll { _ -> Void in
            self.fetchFeedElements(isPullToRefresh: false)
        }
        //tells the infinite scroll when to stop
        feedTableView.setShouldShowInfiniteScrollHandler { _ -> Bool in
            return self.continueInfiniteScroll
        }
        
        feedTableView.infiniteScrollIndicatorView = LoadingAnimatorUtilities.createInfiniteScrollAnimator()

        fetchFeedElements()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        feedTableView.reloadData()
    }
    
    //MARK
    //MARK - Endpoint Requests
    //MARK
    func emptyStateTableViewHandleRefresh() {
        fetchFeedElements()
    }

    func fetchFeedElements(isPullToRefresh: Bool = true) {
        let fetchFeedEndpointRequest = FetchFeedEndpointRequest(maxtime: self.feedMaxTime, pageSize: pageSize)
        
        fetchFeedEndpointRequest.success = { (endpoint) in
            guard let feedElementsFromEndpoint = endpoint.processedResponseValue as? [FeedElement] else { return }
            for feedElement in feedElementsFromEndpoint {
                self.feedSet.insert(feedElement)
            }

            self.feedElements = self.feedSet.sorted { (fe1,fe2) in fe1.time > fe2.time }
            if self.feedElements.count > 0 {
                self.feedMaxTime = Int(self.feedElements[self.feedElements.count - 1].time.timeIntervalSince1970)
            }
            if !isPullToRefresh {
                if self.feedElements.count < self.pageSize {
                    self.continueInfiniteScroll = false
                }
            }
            
            self.feedTableView.endRefreshing()
            self.feedTableView.stopLoadingAnimation()
            self.feedTableView.finishInfiniteScroll()
            self.feedTableView.reloadData()
        }
        
        fetchFeedEndpointRequest.failure = { _ in
            self.feedTableView.stopLoadingAnimation()
            self.feedTableView.endRefreshing()
            self.feedTableView.finishInfiniteScroll()
            self.feedTableView.reloadData()
        }
        
        System.endpointRequestQueue.addOperation(fetchFeedEndpointRequest)
    }
    
}

//MARK: -
//MARK: Delegate Methods
//MARK: -
extension FeedViewController: FeedElementTableViewCellDelegate, EmptyStateTableViewDelegate, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: -
    //MARK: TableView DataSource
    //MARK: -
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedElements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let context = feedElements[indexPath.row].context
        switch feedElements[indexPath.row].context {
            case .followingRecommendation(_, let episode), .newlyReleasedEpisode(_, let episode):
                if episode.isPlaying {
                    currentlyPlayingIndexPath = indexPath
                }
            case .followingSubscription:
                break
        }
        return tableView.dequeueFeedElementTableViewCell(with: context, delegate: self)
    }
    
    //MARK: -
    //MARK: TableView Delegate
    //MARK: -
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch feedElements[indexPath.row].context {
        case .followingRecommendation(_, let episode), .newlyReleasedEpisode(_, let episode):
            let viewController = EpisodeDetailViewController()
            viewController.episode = episode
            navigationController?.pushViewController(viewController, animated: true)
        case .followingSubscription(_, let series):
            let viewController = SeriesDetailViewController(series: series)
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    //MARK: -
    //MARK: EmptyStateTableViewDelegate
    //MARK: -
    func didPressEmptyStateViewActionItem() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate, let tabBarController = appDelegate.tabBarController else { return }
        tabBarController.programmaticallyPressTabBarButton(atIndex: System.searchTab)
    }
    
    //MARK: -
    //MARK: FeedElementTableViewCellDelegate
    //MARK: -
    func didPressMoreButton(for episodeSubjectView: EpisodeSubjectView, in cell: UITableViewCell) {
        guard let indexPath = feedTableView.indexPath(for: cell),
            let episode = feedElements[indexPath.row].context.subject as? Episode else { return }
        
        let option1 = ActionSheetOption(type: .download(selected: episode.isDownloaded), action: nil)
        
        var header: ActionSheetHeader?
        
        if let image = episodeSubjectView.podcastImage?.image, let title = episodeSubjectView.episodeNameLabel.text, let description = episodeSubjectView.dateTimeLabel.text {
            header = ActionSheetHeader(image: image, title: title, description: description)
        }
        
        let actionSheetViewController = ActionSheetViewController(options: [option1], header: header)
        showActionSheetViewController(actionSheetViewController: actionSheetViewController)
    }
    
    func didPressPlayPauseButton(for episodeSubjectView: EpisodeSubjectView, in cell: UITableViewCell) {
        guard let feedElementIndexPath = feedTableView.indexPath(for: cell),
            let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let episode = feedElements[feedElementIndexPath.row].context.subject as? Episode else { return }

        appDelegate.showPlayer(animated: true)
        Player.sharedInstance.playEpisode(episode: episode)
        episodeSubjectView.updateWithPlayButtonPress(episode: episode)

        // reset previously playings view
        if let playingIndexPath = currentlyPlayingIndexPath, currentlyPlayingIndexPath != feedElementIndexPath, let playingEpisode = feedElements[playingIndexPath.row].context.subject as? Episode, let currentlyPlayingCell = feedTableView.cellForRow(at: playingIndexPath) as? FeedElementTableViewCell, let subjectView = currentlyPlayingCell.subjectView as? EpisodeSubjectView {
            subjectView.updateWithPlayButtonPress(episode: playingEpisode)
        }

        // update currently playing episode index path
        currentlyPlayingIndexPath = feedElementIndexPath
    }
    
    func didPressBookmarkButton(for episodeSubjectView: EpisodeSubjectView, in cell: UITableViewCell) {
        guard let indexPath = feedTableView.indexPath(for: cell),
            let episode = feedElements[indexPath.row].context.subject as? Episode else { return }
        
        episode.bookmarkChange(completion: episodeSubjectView.episodeUtilityButtonBarView.setBookmarkButtonToState)
    }
    
    func didPressTagButton(for episodeSubjectView: EpisodeSubjectView, in cell: UITableViewCell, index: Int) {
        guard let feedElementIndexPath = feedTableView.indexPath(for: cell) else { return }
        //        let tagViewController = TagViewController()
        //        tagViewController.tag = (feedElements[feedElementIndexPath.row].subject as! Episode).tags[index]
        navigationController?.pushViewController(UnimplementedViewController(), animated: true)
    }
    
    func didPressRecommendedButton(for episodeSubjectView: EpisodeSubjectView, in cell: UITableViewCell) {
        guard let indexPath = feedTableView.indexPath(for: cell),
            let episode = feedElements[indexPath.row].context.subject as? Episode else { return }
        
        let completion = episodeSubjectView.episodeUtilityButtonBarView.setRecommendedButtonToState
        episode.recommendedChange(completion: completion)
    }
    
    func didPressFeedControlButton(for episodeSubjectView: UserSeriesSupplierView, in cell: UITableViewCell) {
        print("Pressed Feed Control")
    }
    
    func didPressSubscribeButton(for seriesSubjectView: SeriesSubjectView, in cell: UITableViewCell) {
        guard let indexPath = feedTableView.indexPath(for: cell),
            let series = feedElements[indexPath.row].context.subject as? Series else { return }
        
        series.subscriptionChange(completion: seriesSubjectView.updateViewWithSubscribeState)
    }
}
