import UIKit
import NVActivityIndicatorView

class BookmarkViewController: ViewController, UITableViewDelegate, UITableViewDataSource, BookmarkTableViewCellDelegate {
    
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
    var loadingActivityIndicator: NVActivityIndicatorView!
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .paleGrey
        title = "Bookmarks"
    
        //tableview.
        bookmarkTableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        bookmarkTableView.delegate = self
        bookmarkTableView.dataSource = self
        bookmarkTableView.backgroundColor = .clear
        bookmarkTableView.separatorStyle = .none
        bookmarkTableView.showsVerticalScrollIndicator = false
        bookmarkTableView.register(BookmarkTableViewCell.self, forCellReuseIdentifier: "BookmarkTableViewCellIdentifier")
        view.addSubview(bookmarkTableView)
        bookmarkTableView.rowHeight = BookmarkTableViewCell.height
        bookmarkTableView.reloadData()
        mainScrollView = bookmarkTableView
        
        loadingActivityIndicator = createLoadingAnimationView()
        loadingActivityIndicator.center = view.center
        view.addSubview(loadingActivityIndicator)
        
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
        
        if !episode.isRecommended {
            let endpointRequest = CreateRecommendationEndpointRequest(episodeID: episode.id)
            endpointRequest.success = { request in
                episode.isRecommended = true
                bookmarksTableViewCell.setRecommendedButtonToState(isRecommended: true)
            }
            System.endpointRequestQueue.addOperation(endpointRequest)
        } else {
            let endpointRequest = DeleteRecommendationEndpointRequest(episodeID: episode.id)
            endpointRequest.success = { request in
                episode.isRecommended = false
                bookmarksTableViewCell.setRecommendedButtonToState(isRecommended: false)
            }
            System.endpointRequestQueue.addOperation(endpointRequest)
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
        let historyRequest = CreateListeningHistoryElementEndpointRequest(episodeID: episode.id)
        System.endpointRequestQueue.addOperation(historyRequest)
    }
    
    func bookmarkTableViewCellDidPressMoreActionsButton(bookmarksTableViewCell: BookmarkTableViewCell) {
        let option1 = ActionSheetOption(title: "Download", titleColor: .rosyPink, image: #imageLiteral(resourceName: "more_icon"), action: nil)
        let option2 = ActionSheetOption(title: "Delete Bookmark", titleColor: .offBlack, image: #imageLiteral(resourceName: "more_icon")) {
            let deleteBookmarkEndpointRequest = DeleteBookmarkEndpointRequest(episodeID: bookmarksTableViewCell.episodeID)
            deleteBookmarkEndpointRequest.success = { _ in
                let deletedEpisode = self.episodes.filter { episode in episode.id == bookmarksTableViewCell.episodeID }.first
                if let deletedEpisode = deletedEpisode, let index = self.episodes.index(of: deletedEpisode) {
                    self.episodes.remove(at: index)
                    self.bookmarkTableView.reloadData()
                }
            }
            System.endpointRequestQueue.addOperation(deleteBookmarkEndpointRequest)
        }
        let option3 = ActionSheetOption(title: "Share Episode", titleColor: .offBlack, image: #imageLiteral(resourceName: "shareButton")) {
            let activityViewController = UIActivityViewController(activityItems: [], applicationActivities: nil)
            self.present(activityViewController, animated: true, completion: nil)
        }
        let option4 = ActionSheetOption(title: "Go to Series", titleColor: .offBlack, image: #imageLiteral(resourceName: "more_icon"), action: nil)
        var header: ActionSheetHeader?
        
        if let image = bookmarksTableViewCell.episodeImage.image, let title = bookmarksTableViewCell.episodeNameLabel.text, let description = bookmarksTableViewCell.dateTimeLabel.text {
            header = ActionSheetHeader(image: image, title: title, description: description)
        }
        
        let actionSheetViewController = ActionSheetViewController(options: [option1, option2, option3, option4], header: header)
        showActionSheetViewController(actionSheetViewController: actionSheetViewController)
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
            self.loadingActivityIndicator.stopAnimating()
            self.bookmarkTableView.reloadSections([0] , with: .automatic)
            
        }
        System.endpointRequestQueue.addOperation(endpointRequest)
    }
}
