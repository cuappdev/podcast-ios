//
//  DownloadsViewController.swift
//  Podcast
//
//  Created by Drew Dunne on 2/19/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import UIKit

class DownloadsViewController: ViewController, EmptyStateTableViewDelegate, UITableViewDelegate, UITableViewDataSource, BookmarkTableViewCellDelegate {
    
    ///
    /// Mark: Constants
    ///
    var lineHeight: CGFloat = 3
    var topButtonHeight: CGFloat = 30
    var topViewHeight: CGFloat = 60
    
    ///
    /// Mark: Variables
    ///
    var downloadsTableView: EmptyStateTableView!
    var episodes: [Episode] = []
    var currentlyPlayingIndexPath: IndexPath?
    var isOffline: Bool = false
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    init(isOffline: Bool) {
        self.isOffline = isOffline
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .paleGrey
        title = "Downloads"
        
        //tableview.
        downloadsTableView = EmptyStateTableView(frame: view.frame, type: .downloads, isRefreshable: false)
        downloadsTableView.delegate = self
        downloadsTableView.emptyStateTableViewDelegate = self
        downloadsTableView.dataSource = self
        downloadsTableView.register(BookmarkTableViewCell.self, forCellReuseIdentifier: "DownloadsTableViewCellIdentifier")
        view.addSubview(downloadsTableView)
        downloadsTableView.rowHeight = BookmarkTableViewCell.height
        mainScrollView = downloadsTableView
        
        if (isOffline) {
            // TODO: display alert
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Re-Login", style: .plain, target: appDelegate, action: #selector(AppDelegate.exitOfflineMode))
        }
        
        gatherEpisodes()
    }
    
    func gatherEpisodes() {
        episodes = []
        DownloadManager.shared.downloaded.forEach { el in
            let (_, episode) = el
            episodes.append(episode)
        }
        downloadsTableView.reloadData()
    }
    
    func didPressEmptyStateViewActionItem() {
        
    }
    
    func emptyStateTableViewHandleRefresh() {
        gatherEpisodes()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DownloadsTableViewCellIdentifier") as? BookmarkTableViewCell else { return UITableViewCell() }
        cell.delegate = self
        cell.setupWithEpisode(episode: episodes[indexPath.row])
        cell.recommendedButton.isHidden = true
        
        if episodes[indexPath.row].isPlaying {
            currentlyPlayingIndexPath = indexPath
        }
        
        return cell
    }
    
    func bookmarkTableViewCellDidPressPlayPauseButton(bookmarksTableViewCell: BookmarkTableViewCell) {
        guard let episodeIndexPath = downloadsTableView.indexPath(for: bookmarksTableViewCell), let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let episode = episodes[episodeIndexPath.row]
        appDelegate.showPlayer(animated: true)
        Player.sharedInstance.playEpisode(episode: episode)
        bookmarksTableViewCell.updateWithPlayButtonPress(episode: episode)
        
        // reset previously playings view
        if let playingIndexPath = currentlyPlayingIndexPath, currentlyPlayingIndexPath != episodeIndexPath, let currentlyPlayingCell = downloadsTableView.cellForRow(at: playingIndexPath) as? BookmarkTableViewCell {
            let playingEpisode = episodes[playingIndexPath.row]
            currentlyPlayingCell.updateWithPlayButtonPress(episode: playingEpisode)
        }
        
        // update index path
        currentlyPlayingIndexPath = episodeIndexPath
    }
    
    func bookmarkTableViewCellDidPressMoreActionsButton(bookmarksTableViewCell: BookmarkTableViewCell) {
        guard let indexPath = downloadsTableView.indexPath(for: bookmarksTableViewCell) else { return }
        let episode = episodes[indexPath.row]
        let update : (Episode) -> () = { _ in
            self.gatherEpisodes()
        }
        let option1 = ActionSheetOption(type: .download(selected: episode.isDownloaded), action: episode.downloadOrRemove(resultingEpisode: update))
        
        var header: ActionSheetHeader?
        
        if let image = bookmarksTableViewCell.episodeImage.image, let title = bookmarksTableViewCell.episodeNameLabel.text, let description = bookmarksTableViewCell.dateTimeLabel.text {
            header = ActionSheetHeader(image: image, title: title, description: description)
        }
        
        let actionSheetViewController = ActionSheetViewController(options: [option1], header: header)
        showActionSheetViewController(actionSheetViewController: actionSheetViewController)
    }
    
    func bookmarkTableViewCellDidPressRecommendButton(bookmarksTableViewCell: BookmarkTableViewCell) {
        // Do nothing
    }

}
