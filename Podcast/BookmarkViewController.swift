import UIKit
import NVActivityIndicatorView


class BookmarkViewController: DiscoverComponentViewController, EmptyStateTableViewDelegate, UITableViewDelegate, UITableViewDataSource, BookmarkTableViewCellDelegate {
    
    ///
    /// Mark: Constants
    ///
    var lineHeight: CGFloat = 3
    var topButtonHeight: CGFloat = 30
    var topViewHeight: CGFloat = 60
    let padding: CGFloat = 18
    let continueListeningHeaderViewHeight: CGFloat = 50
    let continueListeningCollectionViewHeight: CGFloat = 126
    var headerViewHeight: CGFloat = 0
    var continueListeningHeaderView: UIView!
    let continueListeningCollectionViewCellIdentifier: String = "continueListeningIdentifier"
    
    ///
    /// Mark: Variables
    ///
    var bookmarkTableView: EmptyStateTableView!
    var continueListeningCollectionView: UICollectionView!
    var episodes: [Episode] = []
    var continueListeningEpisodes: [Episode] = []
    var currentlyPlayingIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .paleGrey
        navigationItem.title = "Saved for Later"

        //tableview
        bookmarkTableView = EmptyStateTableView(frame: view.frame, type: .bookmarks, isRefreshable: true)
        bookmarkTableView.delegate = self
        bookmarkTableView.emptyStateTableViewDelegate = self
        bookmarkTableView.dataSource = self
        bookmarkTableView.register(BookmarkTableViewCell.self, forCellReuseIdentifier: "BookmarkTableViewCellIdentifier")
        view.addSubview(bookmarkTableView)
        bookmarkTableView.rowHeight = BookmarkTableViewCell.height
        bookmarkTableView.reloadData()
        mainScrollView = bookmarkTableView

        bookmarkTableView.tableHeaderView = headerView

        continueListeningHeaderView = UIView()
        continueListeningHeaderView.backgroundColor = .offWhite
        let mainLabel = UILabel()
        mainLabel.text = "Jump Back In"
        mainLabel.font = ._14SemiboldFont()
        mainLabel.textColor = .charcoalGrey
        continueListeningHeaderView.addSubview(mainLabel)
        mainLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(padding)
        }

        headerView.addSubview(continueListeningHeaderView)
        continueListeningHeaderView.snp.makeConstraints { make in
            make.top.centerX.width.equalToSuperview()
            make.height.equalTo(continueListeningHeaderViewHeight)
        }

        continueListeningCollectionView = createCollectionView(type: .continueListening)
        continueListeningCollectionView.backgroundColor = .offWhite
        headerView.addSubview(continueListeningCollectionView)
        continueListeningCollectionView.register(ContinueListeningCollectionViewCell.self, forCellWithReuseIdentifier: continueListeningCollectionViewCellIdentifier)
        continueListeningCollectionView.dataSource = self
        continueListeningCollectionView.delegate = self
        continueListeningCollectionView.snp.makeConstraints { make in
            make.top.equalTo(continueListeningHeaderView.snp.bottom)
            make.width.centerX.equalToSuperview()
            make.height.equalTo(continueListeningCollectionViewHeight)
        }

        headerView.translatesAutoresizingMaskIntoConstraints = true
        // adjust header height
        headerViewHeight = continueListeningCollectionViewHeight + continueListeningHeaderViewHeight + padding
        headerView.snp.makeConstraints { make in
            make.width.top.centerX.equalToSuperview()
            make.height.equalTo(headerViewHeight)
        }

        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()

        fetchEpisodes()
        fetchContinueListening()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bookmarkTableView.reloadData()
        continueListeningCollectionView.reloadData()
        fetchContinueListening()
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
        let episode = episodes[indexPath.row]
        cell.setup(with: episode, downloadStatus: DownloadManager.shared.status(for: episode.id))

        if episodes[indexPath.row].isPlaying {
            currentlyPlayingIndexPath = indexPath
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
        guard let episodeIndexPath = bookmarkTableView.indexPath(for: bookmarksTableViewCell), let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let episode = episodes[episodeIndexPath.row]
        appDelegate.showAndExpandPlayer()
        Player.sharedInstance.playEpisode(episode: episode)
        bookmarksTableViewCell.updateWithPlayButtonPress(episode: episode)

        // reset previously playings view
        if let playingIndexPath = currentlyPlayingIndexPath, currentlyPlayingIndexPath != episodeIndexPath, let currentlyPlayingCell = bookmarkTableView.cellForRow(at: playingIndexPath) as? BookmarkTableViewCell {
            let playingEpisode = episodes[playingIndexPath.row]
            currentlyPlayingCell.updateWithPlayButtonPress(episode: playingEpisode)
        }

        // update index path
        currentlyPlayingIndexPath = episodeIndexPath
    }
    
    func bookmarkTableViewCellDidPressMoreActionsButton(bookmarksTableViewCell: BookmarkTableViewCell) {
        guard let indexPath = bookmarkTableView.indexPath(for: bookmarksTableViewCell) else { return }
        let episode = episodes[indexPath.row]
        let option1 = ActionSheetOption(type: DownloadManager.shared.actionSheetType(for: episode.id), action: {
            DownloadManager.shared.handle(episode)
        })
        let option2 = ActionSheetOption(type: .bookmark(selected: episode.isBookmarked), action: {
            let success: (Bool) -> () = { _ in
                self.episodes.remove(at: indexPath.row)
                self.bookmarkTableView.reloadData()
            }
            episode.deleteBookmark(success: success)
        })
        let shareEpisodeOption = ActionSheetOption(type: .shareEpisode, action: {
            guard let user = System.currentUser else { return }
            let viewController = ShareEpisodeViewController(user: user, episode: episode)
            self.navigationController?.pushViewController(viewController, animated: true)
        })

        var header: ActionSheetHeader?
        
        if let image = bookmarksTableViewCell.episodeImage.image, let title = bookmarksTableViewCell.episodeNameLabel.text, let description = bookmarksTableViewCell.dateTimeLabel.text {
            header = ActionSheetHeader(image: image, title: title, description: description)
        }
        
        let actionSheetViewController = ActionSheetViewController(options: [option1, option2, shareEpisodeOption], header: header)
        showActionSheetViewController(actionSheetViewController: actionSheetViewController)
    }
    
    func didPressEmptyStateViewActionItem() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate, let tabBarController = appDelegate.tabBarController else { return }
        tabBarController.selectedIndex = System.discoverTab
    }
    
    //MARK
    //MARK - Endpoint Requests
    //MARK
    func emptyStateTableViewHandleRefresh() {
        fetchEpisodes()
        fetchContinueListening()
    }

    @objc func fetchEpisodes() {
        let endpointRequest = FetchBookmarksEndpointRequest()
        endpointRequest.success = { request in
            guard let newEpisodes = request.processedResponseValue as? [Episode] else { return }
            self.episodes = newEpisodes
            self.bookmarkTableView.reloadData()
            self.bookmarkTableView.endRefreshing()
            self.bookmarkTableView.stopLoadingAnimation()
        }
        endpointRequest.failure = { _ in
            self.bookmarkTableView.endRefreshing()
            self.bookmarkTableView.stopLoadingAnimation()
        }
        System.endpointRequestQueue.addOperation(endpointRequest)
    }
}

extension BookmarkViewController: EpisodeDownloader {
    func didReceive(statusUpdate: DownloadStatus, for episode: Episode) {
        // Not worth it, this view doesn't have cells that distinguish download status
//        if let row = episodes.index(of: episode) {
//            bookmarkTableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)
//        }
    }
}

extension BookmarkViewController: UICollectionViewDataSource, UICollectionViewDelegate, ContinueListeningCollectionViewCellDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = EpisodeDetailViewController()
        vc.episode = continueListeningEpisodes[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return continueListeningEpisodes.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: continueListeningCollectionViewCellIdentifier, for: indexPath) as? ContinueListeningCollectionViewCell else { return ContinueListeningCollectionViewCell() }

        cell.configure(for: continueListeningEpisodes[indexPath.row])
        cell.delegate = self
        return cell
    }

    func fetchContinueListening() {
        let endpointRequest = FetchListeningHistoryEndpointRequest(offset: 0, max: 10, dismissed: false)

        endpointRequest.success = { request in
            guard let newEpisodes = request.processedResponseValue as? [Episode] else { return }
            self.continueListeningEpisodes = newEpisodes.filter({ !$0.isPlaying })
            self.continueListeningCollectionView.reloadData()
            self.bookmarkTableView.reloadData()
            self.layoutHeaderView()
        }
        endpointRequest.failure = { _ in
        }
        System.endpointRequestQueue.addOperation(endpointRequest)
    }

    func dismissButtonPress(on cell: ContinueListeningCollectionViewCell) {
        guard let indexPath = continueListeningCollectionView.indexPath(for: cell) else { return }
        let episode = continueListeningEpisodes[indexPath.row]
        episode.dismissCurrentListeningHistory(success: {
            self.continueListeningEpisodes.remove(at: indexPath.row)
            self.continueListeningCollectionView.reloadData()
            self.layoutHeaderView()
        }, failure: {
            self.present(UIAlertController.failure(message: "Unable to dismiss - \(episode.title)"), animated: true, completion: nil)
        })
    }

    func layoutHeaderView() {
        if continueListeningEpisodes.isEmpty {
            bookmarkTableView.tableHeaderView = nil
            return
        }

        bookmarkTableView.tableHeaderView = headerView

        headerView.snp.remakeConstraints { make in
            make.width.top.centerX.equalToSuperview()
            make.height.equalTo(headerViewHeight).priority(999)
        }
        bookmarkTableView.layoutIfNeeded()
    }
}
