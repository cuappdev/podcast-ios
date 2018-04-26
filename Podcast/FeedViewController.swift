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

class FeedViewController: ViewController, FeedElementTableViewCellDelegate, EpisodeDownloader {
    
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
    var emptyStateViewType: EmptyStateType = .feed
    var showFacebookFriendsSection = false

    var facebookFriends: [User] = []
    var facebookFriendsCell: FacebookFriendsTableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .paleGrey
        navigationItem.title = "Feed"
        
        //tableview
        feedTableView = EmptyStateTableView(frame: view.frame, type: emptyStateViewType, isRefreshable:   true)
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

        facebookFriendsCell = FacebookFriendsTableViewCell() // don't use an identifier because its just one cell
        facebookFriendsCell.delegate = self
        facebookFriendsCell.dataSource = self

        fetchFeedElements()
        fetchFacebookFriendData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let user = System.currentUser {
            showFacebookFriendsSection = user.isFacebookUser
        }
        feedTableView.reloadData()
    }

    //MARK: -
    //MARK: EmptyStateTableViewDelegate
    //MARK: -
    func didPressEmptyStateViewActionItem() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate, let tabBarController = appDelegate.tabBarController else { return }
        tabBarController.selectedIndex = System.searchTab
    }

    func emptyStateTableViewHandleRefresh() {
        fetchFeedElements()
    }

    //MARK
    //MARK - Endpoint Requests
    //MARK

    func fetchFeedElements(isPullToRefresh: Bool = true) {

        if isPullToRefresh && showFacebookFriendsSection {
            fetchFacebookFriendData()
        }

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

    func fetchFacebookFriendData() {
        guard let facebookAcesssToken = Authentication.sharedInstance.facebookAccessToken else { return }

        let endpointRequest = FetchFacebookFriendsEndpointRequest(facebookAccessToken: facebookAcesssToken, pageSize: pageSize, offset: 0, returnFollowing: false)
        endpointRequest.success = { request in
            guard let results = request.processedResponseValue as? [User] else { return }
            self.facebookFriends = results
            self.facebookFriendsCell.collectionView.reloadData()
        }

        endpointRequest.failure = { _ in
            // TODO: handle error
        }
        System.endpointRequestQueue.addOperation(endpointRequest)
    }
    
    func didReceiveDownloadUpdateFor(episode: Episode) {
        var paths: [IndexPath] = []
        for i in 0..<feedElements.count {
            if let e = feedElements[i].context.subject as? Episode, e.id == episode.id {
                paths.append(IndexPath(row: i, section: numberOfSections(in: feedTableView) - 1))
            }
        }
        feedTableView.reloadRows(at: paths, with: .none)
    }


    //MARK: -
    //MARK: FeedElementTableViewCellDelegate
    //MARK: -
    // extensions can't be overriden so this had to be moved up

    func didPress(userSeriesSupplierView: UserSeriesSupplierView, in cell: UITableViewCell) {
        guard let indexPath = feedTableView.indexPath(for: cell) else { return }

        let supplier = feedElements[indexPath.row].context.supplier

        if let user = supplier as? User {
            let profileViewController = UserDetailViewController(user: user)
            navigationController?.pushViewController(profileViewController, animated: true)
        } else if let series = supplier as? Series {
            let seriesDetailViewController = SeriesDetailViewController(series: series)
            navigationController?.pushViewController(seriesDetailViewController, animated: true)
        }
    }

    func didPressMoreButton(for episodeSubjectView: EpisodeSubjectView, in cell: UITableViewCell) {
        guard let indexPath = feedTableView.indexPath(for: cell),
            let episode = feedElements[indexPath.row].context.subject as? Episode else { return }

        let feedElement = feedElements[indexPath.row]
        let downloadOption = ActionSheetOption(type: .download(selected: episode.isDownloaded), action: {
            guard let episode = self.feedElements[indexPath.row].context.subject as? Episode else { return }
            DownloadManager.shared.downloadOrRemove(episode: episode, callback: self.didReceiveDownloadUpdateFor)
        })
        let shareEpisodeOption = ActionSheetOption(type: .shareEpisode, action: {
            guard let user = System.currentUser else { return }
            let viewController = ShareEpisodeViewController(user: user, episode: episode)
            self.navigationController?.pushViewController(viewController, animated: true)
        })
        var options = [downloadOption, shareEpisodeOption]
        if case .followingShare = feedElement.context {
            if let id = feedElement.id { // only will work when our feedElements contain ids 
                let deleteSharedEpisode = ActionSheetOption(type: .deleteShare, action: { episode.deleteShare(id: id, success: {
                        self.feedElements.remove(at: indexPath.row)
                        self.feedTableView.reloadData()})
                })
                options.append(deleteSharedEpisode)
            }
        }


        var header: ActionSheetHeader?

        if let image = episodeSubjectView.podcastImage?.image, let title = episodeSubjectView.episodeNameLabel.text, let description = episodeSubjectView.dateTimeLabel.text {
            header = ActionSheetHeader(image: image, title: title, description: description)
        }

        let actionSheetViewController = ActionSheetViewController(options: options, header: header)
        showActionSheetViewController(actionSheetViewController: actionSheetViewController)
    }

    func didPressPlayPauseButton(for episodeSubjectView: EpisodeSubjectView, in cell: UITableViewCell) {
        guard let feedElementIndexPath = feedTableView.indexPath(for: cell),
            let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let episode = feedElements[feedElementIndexPath.row].context.subject as? Episode else { return }

        appDelegate.showAndExpandPlayer()
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

//MARK: -
//MARK: Delegate Methods
//MARK: -
extension FeedViewController: EmptyStateTableViewDelegate, UITableViewDataSource, UITableViewDelegate, FacebookFriendsTableViewCellDelegate, FacebookFriendsTableViewCellDataSource {

    //MARK: -
    //MARK: TableView DataSource
    //MARK: -
    func numberOfSections(in tableView: UITableView) -> Int {
        return showFacebookFriendsSection && facebookFriends.count > 0 ? 2 : 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if showFacebookFriendsSection && facebookFriends.count > 0 && section == 0 { return 1 }
        return feedElements.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 && showFacebookFriendsSection && facebookFriends.count > 0 { // first section is suggestion facebook friends
            return facebookFriendsCell
        }
        let context = feedElements[indexPath.row].context
        switch feedElements[indexPath.row].context {
            case .followingRecommendation(_, let episode), .newlyReleasedEpisode(_, let episode), .followingShare(_, let episode):
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
        if indexPath.section == 0 && showFacebookFriendsSection  && facebookFriends.count > 0 { return }
        switch feedElements[indexPath.row].context {
        case .followingRecommendation(_, let episode), .newlyReleasedEpisode(_, let episode), .followingShare(_, let episode):
            let viewController = EpisodeDetailViewController()
            viewController.episode = episode
            navigationController?.pushViewController(viewController, animated: true)
        case .followingSubscription(_, let series):
            let viewController = SeriesDetailViewController(series: series)
            navigationController?.pushViewController(viewController, animated: true)
        }
    }

    //MARK: -
    //MARK: FacebookFriendsTableViewCellDelegate
    //MARK: -

    func didPress(with action: FacebookFriendsCellAction, on collectionViewCell: FacebookFriendsCollectionViewCell?, in tableViewCell: FacebookFriendsTableViewCell, for indexPath: IndexPath?) {
        if action == .seeAll {
            let facebookFriendsViewController = FacebookFriendsViewController()
            navigationController?.pushViewController(facebookFriendsViewController, animated: true)
            return
        }

        guard let collectionViewCell = collectionViewCell, let indexPath = indexPath else { return }
        let user = facebookFriends[indexPath.row]
        switch(action) {
        case .didSelect:
            let externalProfileViewController = UserDetailViewController(user: user)
            navigationController?.pushViewController(externalProfileViewController, animated: true)
        case .follow:
            let completion = collectionViewCell.setFollowButtonState
            user.followChange(completion: completion)
        case .dismiss:
            let completion = {
                self.facebookFriends = self.facebookFriends.filter { $0.id != user.id }
                self.facebookFriendsCell.collectionView.reloadData()
                self.feedTableView.reloadData()
            }
            user.dismissAsSuggestedFacebookFriend(success: completion, failure: completion)
        default: break
        }
    }

    //MARK: -
    //MARK: FacebookFriendsTableViewCellDataSource
    //MARK: -

    func facebookFriendsTableViewCell(cell: FacebookFriendsTableViewCell, dataForItemAt indexPath: IndexPath) -> User {
        return facebookFriends[indexPath.row]
    }

    func numberOfFacebookFriends(forFacebookFriendsTableViewCell cell: FacebookFriendsTableViewCell) -> Int {
        return facebookFriends.count
    }
}
