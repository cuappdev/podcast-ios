//
//  RecommendedEpisodesOuterTableViewCell.swift
//  Podcast
//
//  Created by Kevin Greer on 2/19/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

protocol RecommendedEpisodesOuterTableViewCellDataSource {
    func recommendedEpisodesTableViewCell(dataForItemAt indexPath: IndexPath) -> Episode
    func numberOfRecommendedEpisodes() -> Int
}

protocol RecommendedEpisodesOuterTableViewCellDelegate{
    func recommendedEpisodesOuterTableViewCell(didSelectItemAt indexPath: IndexPath)
}

class RecommendedEpisodesOuterTableViewCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {
    
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
        return dataSource?.numberOfRecommendedEpisodes() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! EpisodeTableViewCell
        let episode = dataSource?.recommendedEpisodesTableViewCell(dataForItemAt: indexPath) ?? Episode(id: 0)
        cell.setupWithEpisode(episode: episode)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return EpisodeTableViewCell.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.recommendedEpisodesOuterTableViewCell(didSelectItemAt: indexPath)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tableView.frame = bounds
        tableView.layoutSubviews()
        tableView.setNeedsLayout()
    }
}
