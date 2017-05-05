//
//  FeedViewController.swift
//  Podcast
//
//  Created by Mark Bryan on 9/7/16.
//  Copyright © 2016 Cornell App Development. All rights reserved.
//

import UIKit
import SwiftyJSON

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
        
        cards = fetchCards()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // check before reloading data whether the Player has stopped playing the currentlyPlayingIndexPath
        if let indexPath = currentlyPlayingIndexPath, let card = cards[indexPath.row] as? EpisodeCard, Player.sharedInstance.currentEpisode?.id != card.episode.id {
            currentlyPlayingIndexPath = nil
        }
        feedTableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func fetchCards() -> [Card] {
        var cards: [Card] = []
        let tagStrings = ["Design", "Basketball", "Growth", "Interview", "Education", "Technology"]
        var tags: [Tag] = []
        for t in tagStrings {
            let tag = Tag(name: t)
            tags.append(tag)
        }
        //episode static data
        for i in 0..<2 {
            let url = URL(string: "https://d3rt1990lpmkn.cloudfront.net/cover/f15552e72e1fcf02484d94553a7e7cd98049361a")
            let id = String(i)
            let rCard = RecommendedCard(episodeID: id, episodeTitle: "Stephen Curry - EP10", dateCreated:  Date(), descriptionText: "In today's show, we visit Buffalo, New York, and get a window into a rough business: Debt collection. This is the story of one guy who tried to make something of himself by getting people to pay their debts. He set up shop in an old karate studio, and called up people who owed money. For a while, he made a good living. And he wasn't the only one in the business—this is also the story of a low-level, semi-legal debt-collection economy that sprang up in Buffalo. And, in a small way, it's the story of the last twenty or so years in global finance, a time when the world went wild for debt.", smallArtworkImageURL: url!, episodeLength: "1:22", audioURL: nil, numberOfRecommendations: 94, tags: tags, seriesTitle: "Design Details", seriesID: "3", isBookmarked: false, isRecommended: false, namesOfRecommenders: ["Eileen Dai","Natasha Armbrust", "Mark Bryan"], imageURLsOfRecommenders: [url!,url!,url!], numberOfRecommenders: 5)
            let relCard = ReleaseCard(episodeID: id, episodeTitle: "Stephen Curry - EP10", dateCreated:  Date(), descriptionText: "In today's show, we visit Buffalo, New York, and get a window into a rough business: Debt collection. This is the story of one guy who tried to make something of himself by getting people to pay their debts. He set up shop in an old karate studio, and called up people who owed money. For a while, he made a good living. And he wasn't the only one in the business—this is also the story of a low-level, semi-legal debt-collection economy that sprang up in Buffalo. And, in a small way, it's the story of the last twenty or so years in global finance, a time when the world went wild for debt.", smallArtworkImageURL: url!, episodeLength: "0:44", audioURL: nil,numberOfRecommendations: 94, tags: tags, seriesTitle: "Design Details", seriesID: "3", isBookmarked: false, isRecommended: true, seriesImageURL: url!)
            let tagCard = TagCard(episodeID: id, episodeTitle: "Stephen Curry - EP10", dateCreated:  Date(), descriptionText: "In today's show, we visit Buffalo, New York, and get a window into a rough business: Debt collection. This is the story of one guy who tried to make something of himself by getting people to pay their debts. He set up shop in an old karate studio, and called up people who owed money. For a while, he made a good living. And he wasn't the only one in the business—this is also the story of a low-level, semi-legal debt-collection economy that sprang up in Buffalo. And, in a small way, it's the story of the last twenty or so years in global finance, a time when the world went wild for debt.", smallArtworkImageURL: url!, episodeLength: "0:56", audioURL: nil, numberOfRecommendations: 94, tags: tags, seriesTitle: "Design Details", seriesID: "3", isBookmarked: false, isRecommended: false, tag: Tag(name: "Education"))
            cards.append(rCard)
            cards.append(relCard)
            cards.append(tagCard)
        }
        return cards
    }
}
