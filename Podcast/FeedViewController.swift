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

class FeedViewController: ViewController, UITableViewDelegate, UITableViewDataSource {

    ///
    /// Mark: Constants
    ///
    var lineHeight: CGFloat = 3
    var topButtonHeight: CGFloat = 30
    var topViewHeight: CGFloat = 60

    ///
    /// Mark: Variables
    ///
    var feedTableView: UITableView!
    var feedElements: [FeedElement] = []
    var currentlyPlayingIndexPath: IndexPath?
    var loadingAnimation: NVActivityIndicatorView!
    var refreshControl: UIRefreshControl!
    let pageSize = 20
    var continueInfiniteScroll = true
    var feedSet: Set = Set<FeedElement>()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .paleGrey
        title = "Feed"

        //tableview
        feedTableView = UITableView(frame: CGRect.zero)
        feedTableView.delegate = self
        feedTableView.dataSource = self
        feedTableView.backgroundColor = .clear
        feedTableView.separatorStyle = .none
        feedTableView.showsVerticalScrollIndicator = false
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
        
        feedTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        loadingAnimation = createLoadingAnimationView()
        view.addSubview(loadingAnimation)
        
        loadingAnimation.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        loadingAnimation.startAnimating()

        refreshControl = UIRefreshControl()
        refreshControl.tintColor = .sea
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: UIControlEvents.valueChanged)
        feedTableView.addSubview(refreshControl)

        fetchCards(isPullToRefresh: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // check before reloading data whether the Player has stopped playing the currentlyPlayingIndexPath
        if let indexPath = currentlyPlayingIndexPath, let episode = feedElements[indexPath.row].subject as? Episode, Player.sharedInstance.currentEpisode?.id != episode.id {
            currentlyPlayingIndexPath = nil
        }
        feedTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        //cell.delegate = self
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
            let viewController = SeriesDetailViewController()
            viewController.series = series
            navigationController?.pushViewController(viewController, animated: true)
            return
        }
    }


    //MARK: -
    //MARK: Delegate
    //MARK: -
    
    /*

    func episodeTableViewCellDidPressRecommendButton(episodeTableViewCell: EpisodeTableViewCell) {

        guard let cardIndexPath = feedTableView.indexPath(for: episodeTableViewCell), let card = cards[cardIndexPath.row] as? EpisodeCard else { return }

        if !card.episode.isRecommended {
            let endpointRequest = CreateRecommendationEndpointRequest(episodeID: card.episode.id)
            endpointRequest.success = { request in
                card.episode.isRecommended = true
                episodeTableViewCell.episodeUtilityButtonBarView.setRecommendedButtonToState(isRecommended: true)
            }
            System.endpointRequestQueue.addOperation(endpointRequest)
        } else {
            let endpointRequest = DeleteRecommendationEndpointRequest(episodeID: card.episode.id)
            endpointRequest.success = { request in
                card.episode.isRecommended = false
                episodeTableViewCell.episodeUtilityButtonBarView.setRecommendedButtonToState(isRecommended: false)
            }
            System.endpointRequestQueue.addOperation(endpointRequest)
        }
    }


    func episodeTableViewCellDidPressBookmarkButton(episodeTableViewCell: EpisodeTableViewCell) {
        guard let cardIndexPath = feedTableView.indexPath(for: episodeTableViewCell), let card = cards[cardIndexPath.row] as? EpisodeCard else { return }

        if !card.episode.isBookmarked {
            let endpointRequest = CreateBookmarkEndpointRequest(episodeID: card.episode.id)
            endpointRequest.success = { request in
                card.episode.isBookmarked = true
                episodeTableViewCell.episodeUtilityButtonBarView.setBookmarkButtonToState(isBookmarked: true)
            }
            System.endpointRequestQueue.addOperation(endpointRequest)
        } else {
            let endpointRequest = DeleteBookmarkEndpointRequest(episodeID: card.episode.id)
            endpointRequest.success = { request in
                card.episode.isBookmarked = false
                episodeTableViewCell.episodeUtilityButtonBarView.setBookmarkButtonToState(isBookmarked: false)
            }
            System.endpointRequestQueue.addOperation(endpointRequest)
        }
    }


    func episodeTableViewCellDidPressPlayPauseButton(episodeTableViewCell: EpisodeTableViewCell) {
        guard let cardIndexPath = feedTableView.indexPath(for: episodeTableViewCell), let card = cards[cardIndexPath.row] as? EpisodeCard, cardIndexPath != currentlyPlayingIndexPath, let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        if let indexPath = currentlyPlayingIndexPath, let cell = feedTableView.cellForRow(at: indexPath) as? EpisodeTableViewCell {
            cell.episodeUtilityButtonBarView.setPlayButtonToState(isPlaying: false)
        }
        currentlyPlayingIndexPath = cardIndexPath
        episodeTableViewCell.episodeUtilityButtonBarView.setPlayButtonToState(isPlaying: true)
        appDelegate.showPlayer(animated: true)
        Player.sharedInstance.playEpisode(episode: card.episode)
        let historyRequest = CreateListeningHistoryElementEndpointRequest(episodeID: card.episode.id)
        System.endpointRequestQueue.addOperation(historyRequest)
    }

    func episodeTableViewCellDidPressTagButton(episodeTableViewCell: EpisodeTableViewCell, index: Int) {
        guard let cardIndexPath = feedTableView.indexPath(for: episodeTableViewCell), let card = cards[cardIndexPath.row] as? EpisodeCard else { return }
        let tagViewController = TagViewController()
        tagViewController.tag = card.episode.tags[index]
        navigationController?.pushViewController(tagViewController, animated: true)
    }

    func episodeTableViewCellDidPressMoreActionsButton(episodeTableViewCell: EpisodeTableViewCell) {

        let option1 = ActionSheetOption(title: "Mark as Played", titleColor: .offBlack, image: #imageLiteral(resourceName: "more_icon"), action: nil)
        let option2 = ActionSheetOption(title: "Remove Download", titleColor: .rosyPink, image: #imageLiteral(resourceName: "heart_icon"), action: nil)
        let option3 = ActionSheetOption(title: "Share Episode", titleColor: .offBlack, image: #imageLiteral(resourceName: "more_icon")) {
            let activityViewController = UIActivityViewController(activityItems: [], applicationActivities: nil)
            self.present(activityViewController, animated: true, completion: nil)
        }

        var header: ActionSheetHeader?

        if let image = episodeTableViewCell.podcastImage?.image, let title = episodeTableViewCell.episodeNameLabel.text, let description = episodeTableViewCell.dateTimeLabel.text {
            header = ActionSheetHeader(image: image, title: title, description: description)
        }

        let actionSheetViewController = ActionSheetViewController(options: [option1, option2, option3], header: header)
        showActionSheetViewController(actionSheetViewController: actionSheetViewController)
    }

    func cardTableViewCelldidPressFeedControlButton(cell: CardTableViewCell) {

    }
    */

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

            self.loadingAnimation.stopAnimating()
            self.feedTableView.reloadData()
        }

        System.endpointRequestQueue.addOperation(fetchFeedEndpointRequest)
    }
}

