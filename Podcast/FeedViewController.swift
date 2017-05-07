//
//  FeedViewController.swift
//  Podcast
//
//  Created by Mark Bryan on 9/7/16.
//  Copyright © 2016 Cornell App Development. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class FeedViewController: ViewController, UITableViewDelegate, UITableViewDataSource, CardTableViewCellDelegate {

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
    var cards: [Card] = []
    var currentlyPlayingIndexPath: IndexPath?
    var loadingAnimation: NVActivityIndicatorView!
    var refreshControl: UIRefreshControl!
    let pageSize = 20
    var continueInfiniteScroll = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .podcastWhiteDark
        title = "Feed"

        //tableview
        feedTableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        feedTableView.delegate = self
        feedTableView.dataSource = self
        feedTableView.backgroundColor = .clear
        feedTableView.separatorStyle = .none
        feedTableView.showsVerticalScrollIndicator = false
        feedTableView.register(CardTableViewCell.self, forCellReuseIdentifier: "CardTableViewCellIdentifier")
        mainScrollView = feedTableView
        view.addSubview(feedTableView)
        feedTableView.rowHeight = CardTableViewCell.height
        feedTableView.reloadData()
        feedTableView.addInfiniteScroll { (tableView) -> Void in
            self.fetchCards(isPullToRefresh: false)
        }
        //tells the infinite scroll when to stop
        feedTableView.setShouldShowInfiniteScrollHandler { _ -> Bool in
            return self.continueInfiniteScroll
        }
        feedTableView.infiniteScrollIndicatorView = createLoadingAnimationView()
        
        loadingAnimation = createLoadingAnimationView()
        loadingAnimation.center = view.center
        view.addSubview(loadingAnimation)
        loadingAnimation.startAnimating()
        
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = .podcastTeal
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: UIControlEvents.valueChanged)
        feedTableView.addSubview(refreshControl)
        
        fetchCards(isPullToRefresh: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // check before reloading data whether the Player has stopped playing the currentlyPlayingIndexPath
        if let indexPath = currentlyPlayingIndexPath, let card = cards[indexPath.row] as? EpisodeCard, Player.sharedInstance.currentEpisode?.id != card.episode.id {
            currentlyPlayingIndexPath = nil
        }
        feedTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleRefresh() {
        fetchCards(isPullToRefresh: true)
        refreshControl.endRefreshing()
    }

    
    //MARK: -
    //MARK: TableView DataSource
    //MARK: -
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CardTableViewCellIdentifier") as? CardTableViewCell else { return  UITableViewCell() }
        cell.delegate = self
        cell.setupWithCard(card: cards[indexPath.row])
        if indexPath == currentlyPlayingIndexPath {
            cell.setPlayButtonToState(isPlaying: true)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let episodeCard = cards[indexPath.row] as? EpisodeCard else { return }
        let episodeViewController = EpisodeDetailViewController()
        episodeViewController.episode = episodeCard.episode
        navigationController?.pushViewController(episodeViewController, animated: true)
    }

    
    //MARK: -
    //MARK: CardTableViewCell Delegate
    //MARK: - 
    
    func cardTableViewCellDidPressRecommendButton(cardTableViewCell: CardTableViewCell) {
        
        guard let cardIndexPath = feedTableView.indexPath(for: cardTableViewCell), let card = cards[cardIndexPath.row] as? EpisodeCard else { return }
        
        if !card.episode.isRecommended {
            let endpointRequest = CreateRecommendationEndpointRequest(episodeID: card.episode.id)
            endpointRequest.success = { request in
                card.episode.isRecommended = true
                cardTableViewCell.setRecommendedButtonToState(isRecommended: true)
            }
            System.endpointRequestQueue.addOperation(endpointRequest)
        } else {
            let endpointRequest = DeleteRecommendationEndpointRequest(episodeID: card.episode.id)
            endpointRequest.success = { request in
                card.episode.isRecommended = false
                cardTableViewCell.setRecommendedButtonToState(isRecommended: false)
            }
            System.endpointRequestQueue.addOperation(endpointRequest)
        }
    }
    
    
    func cardTableViewCellDidPressBookmarkButton(cardTableViewCell: CardTableViewCell) {
        guard let cardIndexPath = feedTableView.indexPath(for: cardTableViewCell), let card = cards[cardIndexPath.row] as? EpisodeCard else { return }
        
        if !card.episode.isBookmarked {
            let endpointRequest = CreateBookmarkEndpointRequest(episodeID: card.episode.id)
            endpointRequest.success = { request in
                card.episode.isBookmarked = true
                cardTableViewCell.setBookmarkButtonToState(isBookmarked: true)
            }
            System.endpointRequestQueue.addOperation(endpointRequest)
        } else {
            let endpointRequest = DeleteBookmarkEndpointRequest(episodeID: card.episode.id)
            endpointRequest.success = { request in
                card.episode.isBookmarked = true
                cardTableViewCell.setBookmarkButtonToState(isBookmarked: true)
            }
            System.endpointRequestQueue.addOperation(endpointRequest)
        }
    }
    
    
    func cardTableViewCellDidPressPlayPauseButton(cardTableViewCell: CardTableViewCell) {
        guard let cardIndexPath = feedTableView.indexPath(for: cardTableViewCell), let card = cards[cardIndexPath.row] as? EpisodeCard, cardIndexPath != currentlyPlayingIndexPath, let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        if let indexPath = currentlyPlayingIndexPath, let cell = feedTableView.cellForRow(at: indexPath) as? CardTableViewCell {
            cell.setPlayButtonToState(isPlaying: false)
        }
        currentlyPlayingIndexPath = cardIndexPath
        cardTableViewCell.setPlayButtonToState(isPlaying: true)
        appDelegate.showPlayer(animated: true)
        Player.sharedInstance.playEpisode(episode: card.episode)
    }
    
    func cardTableViewCellDidPressTagButton(cardTableViewCell: CardTableViewCell, index: Int) {
        guard let cardIndexPath = feedTableView.indexPath(for: cardTableViewCell), let card = cards[cardIndexPath.row] as? EpisodeCard else { return }
        let tagViewController = TagViewController()
        tagViewController.tag = card.episode.tags[index]
        navigationController?.pushViewController(tagViewController, animated: true)
    }
    
    func cardTableViewCellDidPressMoreActionsButton(cardTableViewCell: CardTableViewCell) {
        
        let option1 = ActionSheetOption(title: "Mark as Played", titleColor: .podcastBlack, image: #imageLiteral(resourceName: "more_icon"), action: nil)
        let option2 = ActionSheetOption(title: "Remove Download", titleColor: .cancelButtonRed, image: #imageLiteral(resourceName: "heart_icon"), action: nil)
        let option3 = ActionSheetOption(title: "Share Episode", titleColor: .podcastBlack, image: #imageLiteral(resourceName: "more_icon")) {
            let activityViewController = UIActivityViewController(activityItems: [], applicationActivities: nil)
            self.present(activityViewController, animated: true, completion: nil)
        }
        
        var header: ActionSheetHeader?
        
        if let image = cardTableViewCell.podcastImageView?.image, let title = cardTableViewCell.episodeNameLabel.text, let description = cardTableViewCell.dateTimeLabel.text {
            header = ActionSheetHeader(image: image, title: title, description: description)
        }
        
        let actionSheetViewController = ActionSheetViewController(options: [option1, option2, option3], header: header)
        showActionSheetViewController(actionSheetViewController: actionSheetViewController)
    }
    
    //MARK
    //MARK - Endpoint Requests
    //MARK
    
    func fetchCards(isPullToRefresh: Bool) {
        let fetchFeedEndpointRequest = FetchFeedEndpointRequest(offset: cards.count, max: pageSize)
        
        fetchFeedEndpointRequest.success = { (endpoint) in
            print("success")
            guard let cardsFromEndpoint = endpoint.processedResponseValue as? [Card] else { return }
            
            if isPullToRefresh {
                self.cards = cardsFromEndpoint + self.cards
            } else { //infinite scroll
                self.cards = self.cards + cardsFromEndpoint
                if cardsFromEndpoint.count < self.pageSize {
                    self.continueInfiniteScroll = false
                }
            }

            self.loadingAnimation.stopAnimating()
            self.feedTableView.reloadData()
        }

        System.endpointRequestQueue.addOperation(fetchFeedEndpointRequest)
    }
}
