
import UIKit

class BookmarkViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, BookmarkTableViewCellDelegate {
    
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
    var episodes: [Episode] = []
    var currentlyPlayingIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .podcastWhiteDark
        title = "Bookmarks"
        
        //tableview
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        bookmarkTableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - appDelegate.tabBarController.tabBarHeight))
        bookmarkTableView.delegate = self
        bookmarkTableView.dataSource = self
        bookmarkTableView.backgroundColor = .clear
        bookmarkTableView.separatorStyle = .none
        bookmarkTableView.showsVerticalScrollIndicator = false
        bookmarkTableView.register(BookmarkTableViewCell.self, forCellReuseIdentifier: "BookmarkTableViewCellIdentifier")
        view.addSubview(bookmarkTableView)
        bookmarkTableView.rowHeight = BookmarkTableViewCell.height
        bookmarkTableView.reloadData()
        
        episodes = fetchEpisodes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // check before reloading data whether the Player has stopped playing the currentlyPlayingIndexPath
        if let indexPath = currentlyPlayingIndexPath {
            let episode = episodes[indexPath.row]
            if Player.sharedInstance.currentEpisode?.id != episode.id {
                currentlyPlayingIndexPath = nil
            }
        }
        bookmarkTableView.reloadData()
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
        return episodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BookmarkTableViewCellIdentifier") as? BookmarkTableViewCell else { return UITableViewCell() }
        cell.delegate = self
        cell.setupWithEpisode(episode: episodes[indexPath.row])
        if indexPath == currentlyPlayingIndexPath {
            cell.setPlayButtonToState(isPlaying: true)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = bookmarkTableView.cellForRow(at: indexPath) as? BookmarkTableViewCell else { return }
        
        // Open Episode Detail View here
    }
    
    
    //MARK: -
    //MARK: BookmarksTableViewCell Delegate
    //MARK: -
    
    func bookmarkTableViewCellDidPressRecommendButton(bookmarksTableViewCell: BookmarkTableViewCell) {
        guard let episodeIndexPath = bookmarkTableView.indexPath(for: bookmarksTableViewCell) else { return }
        let episode = episodes[episodeIndexPath.row]
        
        episode.isRecommended = !episode.isRecommended
        bookmarksTableViewCell.setRecommendedButtonToState(isRecommended: episode.isRecommended)
    }
    
    func bookmarkTableViewCellDidPressPlayPauseButton(bookmarksTableViewCell: BookmarkTableViewCell) {
        guard let episodeIndexPath = bookmarkTableView.indexPath(for: bookmarksTableViewCell), episodeIndexPath != currentlyPlayingIndexPath, let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let episode = episodes[episodeIndexPath.row]
        
        if let indexPath = currentlyPlayingIndexPath, let cell = bookmarkTableView.cellForRow(at: indexPath) as? BookmarkTableViewCell {
            cell.setPlayButtonToState(isPlaying: false)
        }
        currentlyPlayingIndexPath = episodeIndexPath
        bookmarksTableViewCell.setPlayButtonToState(isPlaying: true)
        appDelegate.showPlayer(animated: true)
        Player.sharedInstance.playEpisode(episode: episode)
    }
    
    func bookmarkTableViewCellDidPressMoreActionsButton(bookmarksTableViewCell: BookmarkTableViewCell) {
        
    }
    
    //MARK
    //MARK - Endpoint Requests
    //MARK
    
    func fetchEpisodes() -> [Episode] {
        let episode = Episode()
        episode.title = "Puppies Galore"
        episode.seriesTitle = "Amazing Doggos"
        episode.dateCreated = Date()
        episode.descriptionText = "We talk lots about dogs and puppies and how cute they are and the different colors they come in and how fun they are."
        episode.tags = [Tag(name:"Design"), Tag(name:"Learning"), Tag(name: "User Experience"), Tag(name:"Technology"), Tag(name:"Innovation"), Tag(name:"Dogs")]
        episode.numberOfRecommendations = 1482386868
        return Array(repeating: episode, count: 5)
    }
}
