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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .paleGrey
        title = "Bookmarks"
    
        //tableview.
        bookmarkTableView = EmptyStateTableView(frame: view.frame, type: .bookmarks, isRefreshable: true)
        bookmarkTableView.delegate = self
        bookmarkTableView.emptyStateTableViewDelegate = self
        bookmarkTableView.dataSource = self
        bookmarkTableView.register(BookmarkTableViewCell.self, forCellReuseIdentifier: "BookmarkTableViewCellIdentifier")
        view.addSubview(bookmarkTableView)
        bookmarkTableView.rowHeight = BookmarkTableViewCell.height
        bookmarkTableView.reloadData()
        mainScrollView = bookmarkTableView
        
        bookmarkTableView.refreshControl?.addTarget(self, action: #selector(fetchEpisodes), for: .valueChanged)
        fetchEpisodes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bookmarkTableView.reloadData()

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
        episode.recommendedChange(completion:  bookmarksTableViewCell.setRecommendedButtonToState)
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
        guard let indexPath = bookmarkTableView.indexPath(for: bookmarksTableViewCell) else { return }
        let episode = episodes[indexPath.row]
        let option1 = ActionSheetOption(type: .download(selected: episode.isDownloaded), action: nil)
        let option2 = ActionSheetOption(type: .bookmark(selected: episode.isBookmarked), action: {
            let success: (Bool) -> () = { _ in
                self.episodes.remove(at: indexPath.row)
                self.bookmarkTableView.reloadData()
            }
            episode.deleteBookmark(success: success)
        })
        
        var header: ActionSheetHeader?
        
        if let image = bookmarksTableViewCell.episodeImage.image, let title = bookmarksTableViewCell.episodeNameLabel.text, let description = bookmarksTableViewCell.dateTimeLabel.text {
            header = ActionSheetHeader(image: image, title: title, description: description)
        }
        
        let actionSheetViewController = ActionSheetViewController(options: [option1, option2], header: header)
        showActionSheetViewController(actionSheetViewController: actionSheetViewController)
    }
    
    func didPressEmptyStateViewActionItem() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate, let tabBarController = appDelegate.tabBarController else { return }
        tabBarController.programmaticallyPressTabBarButton(atIndex: System.discoverTab) //discover index
    }
    
    //MARK
    //MARK - Endpoint Requests
    //MARK
    
    @objc func fetchEpisodes() {
        let endpointRequest = FetchBookmarksEndpointRequest()
        endpointRequest.success = { request in
            self.bookmarkTableView.endRefreshing()
            guard let newEpisodes = request.processedResponseValue as? [Episode] else { return }
            self.episodes = newEpisodes
            self.bookmarkTableView.stopLoadingAnimation()
            self.bookmarkTableView.reloadSections([0] , with: .automatic)
        }
        endpointRequest.failure = { _ in
            self.bookmarkTableView.endRefreshing()
        }
        System.endpointRequestQueue.addOperation(endpointRequest)
    }
}
