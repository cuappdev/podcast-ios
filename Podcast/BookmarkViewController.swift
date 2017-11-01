import UIKit
import NVActivityIndicatorView

class BookmarkViewController: ViewController, EmptyStateTableViewDelegate, UITableViewDelegate, UITableViewDataSource, BookmarkTableViewCellDelegate {
    

    ///
    /// Mark: Constants
    ///
    var lineHeight: CGFloat = 3
    var topButtonHeight: CGFloat = 30
    var topViewHeight: CGFloat = 60
    
    ///
    /// Mark: Variables
    ///
    var bookmarkTableView: EmptyStateTableView!
    var episodes: [Episode] = []
    var currentlyPlayingIndexPath: IndexPath?
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .paleGrey
        title = "Bookmarks"
    
        //tableview.
        bookmarkTableView = EmptyStateTableView(frame: view.frame, type: .bookmarks)
        bookmarkTableView.delegate = self
        bookmarkTableView.emptyStateTableViewDelegate = self
        bookmarkTableView.dataSource = self
        bookmarkTableView.register(BookmarkTableViewCell.self, forCellReuseIdentifier: "BookmarkTableViewCellIdentifier")
        view.addSubview(bookmarkTableView)
        bookmarkTableView.rowHeight = BookmarkTableViewCell.height
        bookmarkTableView.reloadData()
        mainScrollView = bookmarkTableView
        
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = .sea
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: UIControlEvents.valueChanged)
        bookmarkTableView.addSubview(refreshControl)
        
        fetchEpisodes()
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
        let episodeViewController = EpisodeDetailViewController()
        episodeViewController.episode = episodes[indexPath.row]
        navigationController?.pushViewController(episodeViewController, animated: true)
    }
    
    
    //MARK: -
    //MARK: BookmarksTableViewCell Delegate
    //MARK: -
    
    func bookmarkTableViewCellDidPressRecommendButton(bookmarksTableViewCell: BookmarkTableViewCell) {
        guard let episodeIndexPath = bookmarkTableView.indexPath(for: bookmarksTableViewCell) else { return }
        let episode = episodes[episodeIndexPath.row]
        let completion = bookmarksTableViewCell.setRecommendedButtonToState
        if !episode.isRecommended {
            episode.createRecommendation(success: completion, failure: completion)
        } else {
            episode.deleteRecommendation(success: completion, failure: completion)
        }
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
        guard let indexPath = bookmarkTableView.indexPath(for: bookmarksTableViewCell), let episode = episodes[indexPath.row] as? Episode else { return }
        let option1 = ActionSheetOption(title: "Download", titleColor: .rosyPink, image: #imageLiteral(resourceName: "more_icon"), action: {
            //TODO
        })
        let option2 = ActionSheetOption(title: "Delete Bookmark", titleColor: .offBlack, image: #imageLiteral(resourceName: "more_icon")) {
            let possibleEpisode = self.episodes.filter { episode in episode.id == bookmarksTableViewCell.episodeID }.first
            if let episode = possibleEpisode, let index = self.episodes.index(of: episode) {
                let success: (Bool) -> () = { _ in
                    self.episodes.remove(at: index)
                    self.bookmarkTableView.reloadData()
                }
                episode.deleteBookmark(success: success)
            }
        }
        let option3 = ActionSheetOption(title: "Mark as Played", titleColor: .offBlack, image: #imageLiteral(resourceName: "play_icon")) {
            episode.createListeningHistory()
        }
        /*
        let option3 = ActionSheetOption(title: "Share Episode", titleColor: .offBlack, image: #imageLiteral(resourceName: "shareButton")) {
            let activityViewController = UIActivityViewController(activityItems: [], applicationActivities: nil)
            self.present(activityViewController, animated: true, completion: nil)
        }
         */
        
        var header: ActionSheetHeader?
        
        if let image = bookmarksTableViewCell.episodeImage.image, let title = bookmarksTableViewCell.episodeNameLabel.text, let description = bookmarksTableViewCell.dateTimeLabel.text {
            header = ActionSheetHeader(image: image, title: title, description: description)
        }
        
        let actionSheetViewController = ActionSheetViewController(options: [option1, option2, option3], header: header)
        showActionSheetViewController(actionSheetViewController: actionSheetViewController)
    }
    
    func didPressEmptyStateViewActionItem() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate, let tabBarController = appDelegate.tabBarController else { return }
        tabBarController.programmaticallyPressTabBarButton(atIndex: 1) //discover index
    }
    
    //MARK
    //MARK - Endpoint Requests
    //MARK
    
    @objc func handleRefresh() {
        fetchEpisodes()
    }
    
    
    func fetchEpisodes() {
        let endpointRequest = FetchBookmarksEndpointRequest()
        endpointRequest.success = { request in
            guard let newEpisodes = request.processedResponseValue as? [Episode] else { return }
            self.episodes = newEpisodes
            self.refreshControl.endRefreshing()
            self.bookmarkTableView.stopLoadingAnimation()
            self.bookmarkTableView.reloadSections([0] , with: .automatic)
            
        }
        System.endpointRequestQueue.addOperation(endpointRequest)
    }
}
