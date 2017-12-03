//
//  EpisodeTableViewCell.swift
//  Podcast
//
//  Created by Drew Dunne on 2/25/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit
import SnapKit

protocol EpisodeTableViewCellDelegate: class {
    
    func episodeTableViewCellDidPressPlayPauseButton(episodeTableViewCell: EpisodeTableViewCell)
    func episodeTableViewCellDidPressRecommendButton(episodeTableViewCell: EpisodeTableViewCell)
    func episodeTableViewCellDidPressBookmarkButton(episodeTableViewCell: EpisodeTableViewCell)
    func episodeTableViewCellDidPressTagButton(episodeTableViewCell: EpisodeTableViewCell, index: Int)
    func episodeTableViewCellDidPressMoreActionsButton(episodeTableViewCell: EpisodeTableViewCell)
}

class EpisodeTableViewCell: UITableViewCell, EpisodeSubjectViewDelegate {
    
    var episodeSubjectView: EpisodeSubjectView!
    
    weak var delegate: EpisodeTableViewCellDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        episodeSubjectView = EpisodeSubjectView()
        contentView.addSubview(episodeSubjectView)
        
        episodeSubjectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        episodeSubjectView.delegate = self 
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupWithEpisode(episode: Episode) {
        episodeSubjectView.setupWithEpisode(episode: episode)
    }

    func updateWithPlayButtonPress(episode: Episode) {
        episodeSubjectView.updateWithPlayButtonPress(episode: episode)
    }
    
    ///
    /// Mark: Delegate
    ///
    func setBookmarkButtonToState(isBookmarked: Bool) {
        episodeSubjectView.episodeUtilityButtonBarView.setBookmarkButtonToState(isBookmarked: isBookmarked)
    }
    
    func setRecommendedButtonToState(isRecommended: Bool, numberOfRecommendations: Int) {
        episodeSubjectView.episodeUtilityButtonBarView.setRecommendedButtonToState(isRecommended: isRecommended, numberOfRecommendations: numberOfRecommendations)
    }
    
    func episodeSubjectViewDidPressPlayPauseButton(episodeSubjectView: EpisodeSubjectView) {
        delegate?.episodeTableViewCellDidPressPlayPauseButton(episodeTableViewCell: self)
    }
    
    func episodeSubjectViewDidPressRecommendButton(episodeSubjectView: EpisodeSubjectView) {
        delegate?.episodeTableViewCellDidPressRecommendButton(episodeTableViewCell: self)
    }
    
    func episodeSubjectViewDidPressBookmarkButton(episodeSubjectView: EpisodeSubjectView) {
        delegate?.episodeTableViewCellDidPressBookmarkButton(episodeTableViewCell: self)
    }
    
    func episodeSubjectViewDidPressTagButton(episodeSubjectView: EpisodeSubjectView, index: Int) {
        delegate?.episodeTableViewCellDidPressTagButton(episodeTableViewCell: self, index: index)
    }
    
    func episodeSubjectViewDidPressMoreActionsButton(episodeSubjectView: EpisodeSubjectView) {
        delegate?.episodeTableViewCellDidPressMoreActionsButton(episodeTableViewCell: self)
    }
}




