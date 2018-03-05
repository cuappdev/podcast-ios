//
//  RecommendedEpisodesOuterTableViewCell.swift
//  Podcast
//
//  Created by Kevin Greer on 2/19/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

protocol RecommendedEpisodesOuterTableViewCellDataSource: class {
    func recommendedEpisodesTableViewCell(dataForItemAt indexPath: IndexPath) -> Episode?
    func numberOfRecommendedEpisodes() -> Int?
    func getUser() -> User?
}

protocol RecommendedEpisodesOuterTableViewCellDelegate: class {
    func recommendedEpisodesOuterTableViewCell(cell: UITableViewCell, didSelectItemAt indexPath: IndexPath)
    func recommendedEpisodesOuterTableViewCellDidPressTagButton(episodeTableViewCell: EpisodeTableViewCell, episode: Episode, index: Int)
    func recommendedEpisodesOuterTableViewCellDidPressShowActionSheet(episodeTableViewCell: EpisodeTableViewCell, episode: Episode)
    func recommendedEpisodeOuterTableViewCellDidPressRecommendButton(episodeTableViewCell: EpisodeTableViewCell, episode: Episode)
    func recommendedEpisodeOuterTableViewCellDidPressBookmarkButton(episodeTableViewCell: EpisodeTableViewCell, episode: Episode)
    func recommendedEpisodeOuterTableViewCellDidPressPlayButton(episodeTableViewCell: EpisodeTableViewCell, episode: Episode)
}

class RecommendedEpisodesOuterTableViewCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource, EpisodeTableViewCellDelegate {
    
    var tableView: UITableView!
    weak var dataSource: RecommendedEpisodesOuterTableViewCellDataSource?
    weak var delegate: RecommendedEpisodesOuterTableViewCellDelegate?
    var currentlyPlayingIndexPath: IndexPath?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        tableView = UITableView(frame: bounds)
        tableView.backgroundColor = .paleGrey
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(EpisodeTableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.isScrollEnabled = false
        contentView.addSubview(tableView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let numEpisodes = dataSource?.numberOfRecommendedEpisodes() {
            return max (1, numEpisodes)
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let numEpisodes = dataSource?.numberOfRecommendedEpisodes() else { return UITableViewCell() }
        if numEpisodes > 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? EpisodeTableViewCell else { return UITableViewCell() }
            let episode = dataSource?.recommendedEpisodesTableViewCell(dataForItemAt: indexPath) ?? Episode()
            cell.setupWithEpisode(episode: episode)
            cell.delegate = self
            return cell
        }
        else {
            guard let user = dataSource?.getUser() else { return UITableViewCell() }
            let cell = NullProfileTableViewCell(user: user)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let numEpisodes = dataSource?.numberOfRecommendedEpisodes() else { return UITableViewAutomaticDimension }
        if numEpisodes > 0 {
            return UITableViewAutomaticDimension
            
        } else {
            if System.currentUser == dataSource?.getUser() {
                return NullProfileTableViewCell.heightForCurrentUser
            }
            else { return NullProfileTableViewCell.heightForUser }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.recommendedEpisodesOuterTableViewCell(cell: self, didSelectItemAt: indexPath)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tableView.frame = bounds
        tableView.layoutSubviews()
        tableView.setNeedsLayout()
    }
    
    //MARK
    //MARK - Episode Cell Delegate 
    //MARK 
    func episodeTableViewCellDidPressPlayPauseButton(episodeTableViewCell: EpisodeTableViewCell) {
        guard let episodeIndexPath = tableView.indexPath(for: episodeTableViewCell), let episode = dataSource?.recommendedEpisodesTableViewCell(dataForItemAt: episodeIndexPath) else { return }
        
        delegate?.recommendedEpisodeOuterTableViewCellDidPressPlayButton(episodeTableViewCell: episodeTableViewCell, episode: episode)
    }
    
    func episodeTableViewCellDidPressRecommendButton(episodeTableViewCell: EpisodeTableViewCell) {
        guard let episodeIndexPath = tableView.indexPath(for: episodeTableViewCell), let episode = dataSource?.recommendedEpisodesTableViewCell(dataForItemAt: episodeIndexPath) else { return }
        
        delegate?.recommendedEpisodeOuterTableViewCellDidPressRecommendButton(episodeTableViewCell: episodeTableViewCell, episode: episode)
    }
    
    func episodeTableViewCellDidPressBookmarkButton(episodeTableViewCell: EpisodeTableViewCell) {
        guard let episodeIndexPath = tableView.indexPath(for: episodeTableViewCell), let episode = dataSource?.recommendedEpisodesTableViewCell(dataForItemAt: episodeIndexPath) else { return }
        
        delegate?.recommendedEpisodeOuterTableViewCellDidPressBookmarkButton(episodeTableViewCell: episodeTableViewCell, episode: episode)
    }
    
    func episodeTableViewCellDidPressTagButton(episodeTableViewCell: EpisodeTableViewCell, index: Int) {
        guard let episodeIndexPath = tableView.indexPath(for: episodeTableViewCell), let episode = dataSource?.recommendedEpisodesTableViewCell(dataForItemAt: episodeIndexPath) else { return }
        
        delegate?.recommendedEpisodesOuterTableViewCellDidPressTagButton(episodeTableViewCell: episodeTableViewCell, episode: episode, index: index)
    }
    
    func episodeTableViewCellDidPressMoreActionsButton(episodeTableViewCell: EpisodeTableViewCell) {
        guard let episodeIndexPath = tableView.indexPath(for: episodeTableViewCell), let episode = dataSource?.recommendedEpisodesTableViewCell(dataForItemAt: episodeIndexPath) else { return }
        delegate?.recommendedEpisodesOuterTableViewCellDidPressShowActionSheet(episodeTableViewCell: episodeTableViewCell, episode: episode)
    }
}
