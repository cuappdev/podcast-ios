//
//  EpisodeDetailViewController.swift
//  Podcast
//
//  Created by Mark Bryan on 4/11/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class EpisodeDetailViewController: ViewController, EpisodeDetailHeaderViewCellDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView!
    var episode: Episode?
    var comments: [Comment] = Array.init(repeating: Comment(episodeId: "", creator: "Mark Bryan", text: "Great point here!!", creationDate: "5 months ago", time: "5:13"), count: 10)
    var episodeDetailViewHeaderHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height), style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CommentsTableViewCell.self, forCellReuseIdentifier: "CommentsTableViewCellIdentifier")
        tableView.register(EpisodeDetailHeaderViewCell.self, forCellReuseIdentifier: "EpisodeDetailHeaderViewCellIdentifier")
        mainScrollView = tableView
        view.addSubview(tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        tableView.setNeedsLayout()
        tableView.layoutIfNeeded()
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0, let cell = tableView.dequeueReusableCell(withIdentifier: "EpisodeDetailHeaderViewCellIdentifier") as? EpisodeDetailHeaderViewCell, let episode = episode {
            cell.setupForEpisode(episode: episode)
            cell.delegate = self
            cell.layoutSubviews()
            episodeDetailViewHeaderHeight = cell.frame.height
            return cell
        } else if let cell = tableView.dequeueReusableCell(withIdentifier: "CommentsTableViewCellIdentifier") as? CommentsTableViewCell  {
            cell.setupForComment(comment: comments[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : comments.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? episodeDetailViewHeaderHeight : CommentsTableViewCell.minimumHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            return CommentsTableViewHeader(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: CommentsTableViewHeader.headerHeight))
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 1 ? CommentsTableViewHeader.headerHeight : 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // EpisodeDetailHeaderViewCellDelegate methods
    
    func episodeDetailHeaderDidPressRecommendButton(cell: EpisodeDetailHeaderViewCell) {
        guard let headerEpisode = episode else { return }
        let completion = cell.setRecommendedButtonToState
        if !headerEpisode.isRecommended {
            headerEpisode.createRecommendation(success: completion, failure: completion)
        } else {
            headerEpisode.deleteRecommendation(success: completion, failure: completion)
        }
    }
    
    func episodeDetailHeaderDidPressMoreButton(cell: EpisodeDetailHeaderViewCell) {
        guard let episode = episode else { return }
        let option1 = ActionSheetOption(type: .download(selected: episode.isDownloaded), action: nil)
        var header: ActionSheetHeader?
        
        if let image = cell.episodeArtworkImageView.image, let title = cell.episodeTitleLabel.text, let description = cell.dateLabel.text {
            header = ActionSheetHeader(image: image, title: title, description: description)
        }
        
        let actionSheetViewController = ActionSheetViewController(options: [option1], header: header)
        showActionSheetViewController(actionSheetViewController: actionSheetViewController)
    }
    
    func episodeDetailHeaderDidPressPlayButton(cell: EpisodeDetailHeaderViewCell) {
        guard let episode = episode, let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        cell.setPlayButtonToState(isPlaying: true)
        appDelegate.showPlayer(animated: true)
        Player.sharedInstance.playEpisode(episode: episode)
    }
    
    func episodeDetailHeaderDidPressBookmarkButton(cell: EpisodeDetailHeaderViewCell) {
        guard let episode = episode else { return }
        let completion = cell.setBookmarkButtonToState
        if !episode.isBookmarked {
            episode.createBookmark(success: completion, failure: completion)
        } else {
            episode.deleteBookmark(success: completion, failure: completion)
        }
    }
    
}
