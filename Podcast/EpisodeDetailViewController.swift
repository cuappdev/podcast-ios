//
//  EpisodeDetailViewController.swift
//  Podcast
//
//  Created by Mark Bryan on 4/11/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class EpisodeDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var scrollView: UIScrollView!
    var episodeDetailHeaderView: EpisodeDetailHeaderView!
    var episode: Episode?
    var commentsTableViewHeader: CommentsTableViewHeader!
    var commentsTableView: UITableView!
    var comments: [Comment] = Array.init(repeating: Comment(episodeId: "", creator: "Mark Bryan", text: "Great point here!!", creationDate: "5 months ago", time: "5:13"), count: 10)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView = UIScrollView(frame: view.frame)
        scrollView.backgroundColor = .white
        scrollView.contentSize = CGSize(width: view.frame.width, height: 0)
        view.addSubview(scrollView)
        
        episodeDetailHeaderView = EpisodeDetailHeaderView(frame: CGRect(x: 0, y: 0, width: scrollView.frame.width, height: 0))
        scrollView.addSubview(episodeDetailHeaderView)
        
        commentsTableViewHeader = CommentsTableViewHeader(frame: CGRect(x: 0, y: 0, width: scrollView.frame.width, height: 0))
        scrollView.addSubview(commentsTableViewHeader)
        
        commentsTableView = UITableView(frame: .zero)
        commentsTableView.dataSource = self
        commentsTableView.delegate = self
        commentsTableView.register(CommentsTableViewCell.self, forCellReuseIdentifier: "CommentsTableViewCellIdentifier")
        scrollView.addSubview(commentsTableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let episode = episode else { return }
        episodeDetailHeaderView.setupForEpisode(episode: episode)
        commentsTableViewHeader.frame.origin = CGPoint(x: 0, y: episodeDetailHeaderView.frame.maxY)
        commentsTableView.frame = CGRect(x: 0, y: commentsTableViewHeader.frame.maxY, width: scrollView.frame.width, height: 300)
        scrollView.contentSize.height = commentsTableView.frame.maxY
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentsTableViewCellIdentifier") as? CommentsTableViewCell else { return UITableViewCell() }
        cell.setupForComment(comment: comments[indexPath.row])
        commentsTableView.rowHeight = cell.frame.height
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
}
