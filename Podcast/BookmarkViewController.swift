
import UIKit

class BookmarkViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CardTableViewCellDelegate {
    
    ///
    /// Mark: Constants
    ///
    var lineHeight: CGFloat = 3
    var topButtonHeight: CGFloat = 30
    var topViewHeight: CGFloat = 60
    
    ///
    /// Mark: Variables
    ///
    var bookmarkTableView: UITableView!
    var cards: [Card] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .podcastWhiteDark
        navigationController?.navigationBar.titleTextAttributes = UIFont.navigationBarDefaultFontAttributes
        title = "Bookmarks"
        
        //tableview
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        bookmarkTableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - appDelegate.tabBarController.tabBarHeight))
        bookmarkTableView.delegate = self
        bookmarkTableView.dataSource = self
        bookmarkTableView.backgroundColor = .clear
        bookmarkTableView.separatorStyle = .none
        bookmarkTableView.showsVerticalScrollIndicator = false
        bookmarkTableView.register(CardTableViewCell.self, forCellReuseIdentifier: "CardTableViewCellIdentifier")
        view.addSubview(bookmarkTableView)
        bookmarkTableView.rowHeight = CardTableViewCell.height
        bookmarkTableView.reloadData()
        
        cards = fetchCards()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        bookmarkTableView.reloadData()
        
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
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CardTableViewCellIdentifier") as? CardTableViewCell else { return UITableViewCell() }
        cell.delegate = self
        cell.setupWithCard(card: cards[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = bookmarkTableView.cellForRow(at: indexPath) as? CardTableViewCell else { return }
        
    }
    
    
    //MARK: -
    //MARK: CardTableViewCell Delegate
    //MARK: -
    
    func cardTableViewCellDidPressRecommendButton(cardTableViewCell: CardTableViewCell) {
        
        guard let cardIndexPath = bookmarkTableView.indexPath(for: cardTableViewCell), let card = cards[cardIndexPath.row] as? EpisodeCard else { return }
        
        card.isRecommended = !card.isRecommended
        cardTableViewCell.setRecommendedButtonToState(isRecommended: card.isRecommended)
    }
    
    
    func cardTableViewCellDidPressBookmarkButton(cardTableViewCell: CardTableViewCell) {
        guard let cardIndexPath = bookmarkTableView.indexPath(for: cardTableViewCell), let card = cards[cardIndexPath.row] as? EpisodeCard else { return }
        
        card.isBookmarked = !card.isBookmarked
        cardTableViewCell.setBookmarkButtonToState(isBookmarked: card.isBookmarked)
    }
    
    
    func cardTableViewCellDidPressPlayPauseButton(cardTableViewCell: CardTableViewCell) {
        guard let cardIndexPath = bookmarkTableView.indexPath(for: cardTableViewCell), let card = cards[cardIndexPath.row] as? EpisodeCard else { return }
        
        card.isPlaying = !card.isPlaying
        cardTableViewCell.setPlayButtonToState(isPlaying: card.isPlaying)
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
            
            let rCard = RecommendedCard(episodeID: i, episodeTitle: "Stephen Curry - EP10", dateCreated:  Date(), descriptionText: "In today's show, we visit Buffalo, New York, and get a window into a rough business: Debt collection. This is the story of one guy who tried to make something of himself by getting people to pay their debts. He set up shop in an old karate studio, and called up people who owed money. For a while, he made a good living. And he wasn't the only one in the business—this is also the story of a low-level, semi-legal debt-collection economy that sprang up in Buffalo. And, in a small way, it's the story of the last twenty or so years in global finance, a time when the world went wild for debt.", smallArtworkImageURL: url!, episodeLength: 44.0, numberOfRecommendations: 94, tags: tags, seriesTitle: "Design Details", seriesID: 3, isBookmarked: true, isRecommended: false, namesOfRecommenders: ["Eileen Dai","Natasha Armbrust", "Mark Bryan"], imageURLsOfRecommenders: [], numberOfRecommenders: 5)
            let relCard = ReleaseCard(episodeID: i, episodeTitle: "Stephen Curry - EP10", dateCreated:  Date(), descriptionText: "In today's show, we visit Buffalo, New York, and get a window into a rough business: Debt collection. This is the story of one guy who tried to make something of himself by getting people to pay their debts. He set up shop in an old karate studio, and called up people who owed money. For a while, he made a good living. And he wasn't the only one in the business—this is also the story of a low-level, semi-legal debt-collection economy that sprang up in Buffalo. And, in a small way, it's the story of the last twenty or so years in global finance, a time when the world went wild for debt.", smallArtworkImageURL: url!, episodeLength: 44.0, numberOfRecommendations: 94, tags: tags, seriesTitle: "Design Details", seriesID: 3, isBookmarked: true, isRecommended: true, seriesImageURL: url!)
            let tagCard = TagCard(episodeID: i, episodeTitle: "Stephen Curry - EP10", dateCreated:  Date(), descriptionText: "In today's show, we visit Buffalo, New York, and get a window into a rough business: Debt collection. This is the story of one guy who tried to make something of himself by getting people to pay their debts. He set up shop in an old karate studio, and called up people who owed money. For a while, he made a good living. And he wasn't the only one in the business—this is also the story of a low-level, semi-legal debt-collection economy that sprang up in Buffalo. And, in a small way, it's the story of the last twenty or so years in global finance, a time when the world went wild for debt.", smallArtworkImageURL: url!, episodeLength: 44.0, numberOfRecommendations: 94, tags: tags, seriesTitle: "Design Details", isBookmarked: true, isRecommended: false, tag: Tag(name: "Education"))
            tagCard.smallArtworkImage = #imageLiteral(resourceName: "filler_image")
            relCard.smallArtworkImage = #imageLiteral(resourceName: "filler_image")
            rCard.smallArtworkImage = #imageLiteral(resourceName: "filler_image")
            relCard.seriesImage = #imageLiteral(resourceName: "sample_series_artwork")
            
            cards.append(relCard)
            cards.append(tagCard)
            cards.append(rCard)
        }
        return cards
    }
}
