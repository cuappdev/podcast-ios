//
//  FeedViewController.swift
//  Podcast
//
//  Created by Mark Bryan on 9/7/16.
//  Copyright © 2016 Cornell App Development. All rights reserved.
//

import UIKit
import SwiftyJSON

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CardTableViewCellDelegate {

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .podcastWhiteDark
        title = "Feed"

        //tableview
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        feedTableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - appDelegate.tabBarController.tabBarHeight))
        feedTableView.delegate = self
        feedTableView.dataSource = self
        feedTableView.backgroundColor = .clear
        feedTableView.separatorStyle = .none
        feedTableView.showsVerticalScrollIndicator = false
        feedTableView.register(CardTableViewCell.self, forCellReuseIdentifier: "CardTableViewCellIdentifier")
        view.addSubview(feedTableView)
        feedTableView.rowHeight = CardTableViewCell.height
        feedTableView.reloadData()
        
        cards = fetchCards()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        feedTableView.reloadData()
        
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = feedTableView.cellForRow(at: indexPath) as? CardTableViewCell else { return }
        
    }

    
    //MARK: -
    //MARK: CardTableViewCell Delegate
    //MARK: - 
    
    func cardTableViewCellDidPressRecommendButton(cardTableViewCell: CardTableViewCell) {
        
        guard let cardIndexPath = feedTableView.indexPath(for: cardTableViewCell), let card = cards[cardIndexPath.row] as? EpisodeCard else { return }
        
        card.episode.isRecommended = !card.episode.isRecommended
        cardTableViewCell.setRecommendedButtonToState(isRecommended: card.episode.isRecommended)
    }
    
    
    func cardTableViewCellDidPressBookmarkButton(cardTableViewCell: CardTableViewCell) {
        guard let cardIndexPath = feedTableView.indexPath(for: cardTableViewCell), let card = cards[cardIndexPath.row] as? EpisodeCard else { return }
        
        card.episode.isBookmarked = !card.episode.isBookmarked
        cardTableViewCell.setBookmarkButtonToState(isBookmarked: card.episode.isBookmarked)
    }
    
    
    func cardTableViewCellDidPressPlayPauseButton(cardTableViewCell: CardTableViewCell) {
        guard let cardIndexPath = feedTableView.indexPath(for: cardTableViewCell), let card = cards[cardIndexPath.row] as? EpisodeCard else { return }
        
        //card.isPlaying = !card.isPlaying
        //cardTableViewCell.setPlayButtonToState(isPlaying: card.isPlaying)
    }
    
    func cardTableViewCellDidPressMoreActionsButton(cardTableViewCell: CardTableViewCell) {
        
        let option1 = ActionSheetOption(title: "Mark as Played", titleColor: .podcastBlack, image: #imageLiteral(resourceName: "more_icon"))
        let option2 = ActionSheetOption(title: "Remove Download", titleColor: .cancelButtonRed, image: #imageLiteral(resourceName: "heart_icon"))
        let option3 = ActionSheetOption(title: "Share Episode", titleColor: .podcastBlack, image: #imageLiteral(resourceName: "more_icon"))
        
        var testHeader: ActionSheetHeader?
        
        if let image = cardTableViewCell.podcastImageView?.image, let title = cardTableViewCell.episodeNameLabel.text, let description = cardTableViewCell.dateTimeLabel.text {
            testHeader = ActionSheetHeader(image: image, title: title, description: description)
        }
        
        let actionSheetViewController = ActionSheetViewController(options: [option1, option2, option3], header: testHeader)
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

            let rCard = RecommendedCard(episodeID: i, episodeTitle: "Stephen Curry - EP10", dateCreated:  Date(), descriptionText: "In today's show, we visit Buffalo, New York, and get a window into a rough business: Debt collection. This is the story of one guy who tried to make something of himself by getting people to pay their debts. He set up shop in an old karate studio, and called up people who owed money. For a while, he made a good living. And he wasn't the only one in the business—this is also the story of a low-level, semi-legal debt-collection economy that sprang up in Buffalo. And, in a small way, it's the story of the last twenty or so years in global finance, a time when the world went wild for debt.", smallArtworkImageURL: url!, episodeLength: 44.0, audioURL: nil, numberOfRecommendations: 94, tags: tags, seriesTitle: "Design Details", seriesID: 3, isBookmarked: false, isRecommended: false, namesOfRecommenders: ["Eileen Dai","Natasha Armbrust", "Mark Bryan"], imageURLsOfRecommenders: [url!,url!,url!], numberOfRecommenders: 5)
            let relCard = ReleaseCard(episodeID: i, episodeTitle: "Stephen Curry - EP10", dateCreated:  Date(), descriptionText: "In today's show, we visit Buffalo, New York, and get a window into a rough business: Debt collection. This is the story of one guy who tried to make something of himself by getting people to pay their debts. He set up shop in an old karate studio, and called up people who owed money. For a while, he made a good living. And he wasn't the only one in the business—this is also the story of a low-level, semi-legal debt-collection economy that sprang up in Buffalo. And, in a small way, it's the story of the last twenty or so years in global finance, a time when the world went wild for debt.", smallArtworkImageURL: url!, episodeLength: 44.0, audioURL: nil,numberOfRecommendations: 94, tags: tags, seriesTitle: "Design Details", seriesID: 3, isBookmarked: false, isRecommended: true, seriesImageURL: url!)
            let tagCard = TagCard(episodeID: i, episodeTitle: "Stephen Curry - EP10", dateCreated:  Date(), descriptionText: "In today's show, we visit Buffalo, New York, and get a window into a rough business: Debt collection. This is the story of one guy who tried to make something of himself by getting people to pay their debts. He set up shop in an old karate studio, and called up people who owed money. For a while, he made a good living. And he wasn't the only one in the business—this is also the story of a low-level, semi-legal debt-collection economy that sprang up in Buffalo. And, in a small way, it's the story of the last twenty or so years in global finance, a time when the world went wild for debt.", smallArtworkImageURL: url!, episodeLength: 44.0, audioURL: nil, numberOfRecommendations: 94, tags: tags, seriesTitle: "Design Details", isBookmarked: false, isRecommended: false, tag: Tag(name: "Education"))
            cards.append(rCard)
            cards.append(relCard)
            cards.append(tagCard)
        }
        return cards
    }
}
