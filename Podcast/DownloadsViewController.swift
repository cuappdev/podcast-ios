//
//  DownloadsViewController.swift
//  Podcast
//
//  Created by Drew Dunne on 2/19/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import UIKit
import Alamofire

class DownloadsViewController: ViewController, EmptyStateTableViewDelegate, UITableViewDelegate, UITableViewDataSource, DownloadsTableViewCellDelegate {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .paleGrey
        title = "Downloads"
        
        //tableview.
        downloadsTableView = EmptyStateTableView(frame: view.frame, type: .downloads, isRefreshable: true)
        downloadsTableView.delegate = self
        downloadsTableView.emptyStateTableViewDelegate = self
        downloadsTableView.dataSource = self
        downloadsTableView.register(DownloadsTableViewCell.self, forCellReuseIdentifier: "DownloadsTableViewCellIdentifier")
        view.addSubview(downloadsTableView)
        downloadsTableView.rowHeight = DownloadsTableViewCell.height
        mainScrollView = downloadsTableView
        
        gatherEpisodes()
    }
    
    func gatherEpisodes() {
        episodes = []
        DownloadManager.shared.downloaded.forEach { el in
            let (_, episode) = el
            episodes.append(episode)
        }
        downloadsTableView.reloadData()
        self.downloadsTableView.endRefreshing()
        self.downloadsTableView.stopLoadingAnimation()
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DownloadsTableViewCellIdentifier") as? DownloadsTableViewCell else { return UITableViewCell() }
        cell.delegate = self
        cell.setupWithEpisode(episode: episodes[indexPath.row])
        
        if episodes[indexPath.row].isPlaying {
            currentlyPlayingIndexPath = indexPath
        }
        
        return cell
    }
    
    func downloadsTableViewCellDidPressPlayPauseButton(downloadsTableViewCell: DownloadsTableViewCell) {
        guard let episodeIndexPath = downloadsTableView.indexPath(for: downloadsTableViewCell), let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let episode = episodes[episodeIndexPath.row]
        appDelegate.showPlayer(animated: true)
        Player.sharedInstance.playEpisode(episode: episode)
        downloadsTableViewCell.updateWithPlayButtonPress(episode: episode)
        
        // reset previously playings view
        if let playingIndexPath = currentlyPlayingIndexPath, currentlyPlayingIndexPath != episodeIndexPath, let currentlyPlayingCell = downloadsTableView.cellForRow(at: playingIndexPath) as? BookmarkTableViewCell {
            let playingEpisode = episodes[playingIndexPath.row]
            currentlyPlayingCell.updateWithPlayButtonPress(episode: playingEpisode)
        }
        
        // update index path
        currentlyPlayingIndexPath = episodeIndexPath
    }
    
    func downloadsTableViewCellDidPressMoreActionsButton(downloadsTableViewCell: DownloadsTableViewCell) {
        guard let indexPath = downloadsTableView.indexPath(for: downloadsTableViewCell) else { return }
        let episode = episodes[indexPath.row]
        let option1 = ActionSheetOption(type: .download(selected: episode.isDownloaded), action: {
            if episode.isDownloaded {
                episode.removeDownload()
            } else {
                let update: Request.ProgressHandler = { progress in
                    // set animation here
                    print("Download Progress: \(progress.fractionCompleted)")
                }
                episode.download(progressCB: update)
            }
            
        })
        
        var header: ActionSheetHeader?
        
        if let image = downloadsTableViewCell.episodeImage.image, let title = downloadsTableViewCell.episodeNameLabel.text, let description = downloadsTableViewCell.dateTimeLabel.text {
            header = ActionSheetHeader(image: image, title: title, description: description)
        }
        
        let actionSheetViewController = ActionSheetViewController(options: [option1], header: header)
        showActionSheetViewController(actionSheetViewController: actionSheetViewController)
    }
    

}
