//
//  RecommendedEpisodesOuterTableViewCell.swift
//  Podcast
//
//  Created by Kevin Greer on 2/19/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

protocol RecommendedEpisodesOuterTableViewCellDataSource {
    func recommendedEpisodesTableViewCell(cell: RecommendedEpisodesOuterTableViewCell, dataForItemAt indexPath: IndexPath) -> Episode
    func numberOfRecommendedEpisodes(forRecommendedEpisodesOuterTableViewCell cell: RecommendedEpisodesOuterTableViewCell) -> Int
}

protocol RecommendedEpisodesOuterTableViewCellDelegate{
    func recommendedEpisodesOuterTableViewCell(cell: RecommendedEpisodesOuterTableViewCell, didSelectItemAt indexPath: IndexPath)
}

class RecommendedEpisodesOuterTableViewCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource, EpisodeTableViewCellDelegate {
    
    var tableView: UITableView!
    var dataSource: RecommendedEpisodesOuterTableViewCellDataSource?
    var delegate: RecommendedEpisodesOuterTableViewCellDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        tableView = UITableView(frame: bounds)
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
        return dataSource?.numberOfRecommendedEpisodes(forRecommendedEpisodesOuterTableViewCell: self) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? EpisodeTableViewCell else { return UITableViewCell() }
        let episode = dataSource?.recommendedEpisodesTableViewCell(cell: self, dataForItemAt: indexPath) ?? Episode()
        cell.setupWithEpisode(episode: episode)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return EpisodeTableViewCell.height
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
        
    }
    
    func episodeTableViewCellDidPressRecommendButton(episodeTableViewCell: EpisodeTableViewCell) {

    }
    
    func episodeTableViewCellDidPressBookmarkButton(episodeTableViewCell: EpisodeTableViewCell) {

    }
    
    func episodeTableViewCellDidPressTagButton(episodeTableViewCell: EpisodeTableViewCell, index: Int) {
        
    }
    
    func episodeTableViewCellDidPressMoreActionsButton(episodeTableViewCell: EpisodeTableViewCell) {
        
    }

    
    
}
