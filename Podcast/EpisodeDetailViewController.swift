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
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height), style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CommentsTableViewCell.self, forCellReuseIdentifier: "CommentsTableViewCellIdentifier")
        tableView.register(EpisodeDetailHeaderViewCell.self, forCellReuseIdentifier: "EpisodeDetailHeaderViewCellIdentifier")
        tableView.contentInset = UIEdgeInsetsMake(0, 0, appDelegate.tabBarController.tabBarHeight, 0)
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
        guard let episode = episode else { return }
        if !episode.isRecommended {
            let endpointRequest = CreateRecommendationEndpointRequest(episodeID: episode.id)
            endpointRequest.success = { request in
                episode.isRecommended = true
            }
            System.endpointRequestQueue.addOperation(endpointRequest)
        } else {
            let endpointRequest = DeleteRecommendationEndpointRequest(episodeID: episode.id)
            endpointRequest.success = { request in
                episode.isRecommended = false
            }
            System.endpointRequestQueue.addOperation(endpointRequest)
        }
    }
    
    func episodeDetailHeaderDidPressMoreButton(cell: EpisodeDetailHeaderViewCell) {
        let option1 = ActionSheetOption(title: "Download", titleColor: .cancelButtonRed, image: #imageLiteral(resourceName: "more_icon"), action: nil)
        let option2 = ActionSheetOption(title: "Share Episode", titleColor: .podcastBlack, image: #imageLiteral(resourceName: "shareButton")) {
            let activityViewController = UIActivityViewController(activityItems: [], applicationActivities: nil)
            self.present(activityViewController, animated: true, completion: nil)
        }
        let option3 = ActionSheetOption(title: "Go to Series", titleColor: .podcastBlack, image: #imageLiteral(resourceName: "more_icon"), action: nil)
        var header: ActionSheetHeader?
        
        if let image = cell.episodeArtworkImageView.image, let title = cell.episodeTitleLabel.text, let description = cell.dateLabel.text {
            header = ActionSheetHeader(image: image, title: title, description: description)
        }
        
        let actionSheetViewController = ActionSheetViewController(options: [option1, option2, option3], header: header)
        showActionSheetViewController(actionSheetViewController: actionSheetViewController)
    }
    
    func episodeDetailHeaderDidPressPlayButton(cell: EpisodeDetailHeaderViewCell) {
        guard let episode = episode, let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        cell.setPlaying(playing: true)
        appDelegate.showPlayer(animated: true)
        Player.sharedInstance.playEpisode(episode: episode)
        let historyRequest = CreateListeningHistoryElementEndpointRequest(episodeID: episode.id)
        System.endpointRequestQueue.addOperation(historyRequest)
    }
    
    func episodeDetailHeaderDidPressBookmarkButton(cell: EpisodeDetailHeaderViewCell) {
        guard let episode = episode else { return }
        if !episode.isBookmarked {
            let endpointRequest = CreateBookmarkEndpointRequest(episodeID: episode.id)
            endpointRequest.success = { request in
                episode.isBookmarked = true
            }
            System.endpointRequestQueue.addOperation(endpointRequest)
        } else {
            let endpointRequest = DeleteBookmarkEndpointRequest(episodeID: episode.id)
            endpointRequest.success = { request in
                episode.isBookmarked = true
            }
            System.endpointRequestQueue.addOperation(endpointRequest)
        }
    }
    
}
