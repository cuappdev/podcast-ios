//
//  EpisodeDetailView.swift
//  Podcast
//
//  Created by Mark Bryan on 2/19/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class EpisodeDetailView: UIView {
    
    var episodeArtworkImageView: UIImageView!
    var seriesTitleLabel: UILabel!
    var episodeTitleLabel: UILabel!
    var dateLabel: UILabel!
    var descriptionLabel: UILabel!
    var recommendButton: UIButton!
    
    let leftMargin: CGFloat = 24
    let artworkDimension: CGFloat = 45.5
    let episodeTitleYInset: CGFloat = 81.5
    let dateLabelYSpacing: CGFloat = 12
    let descriptionLabelSpacing: CGFloat = 24
    let recommendButtonSpacing: CGFloat = 22.5
    let bottomSpacing: CGFloat = 28.5
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        episodeArtworkImageView = UIImageView(frame: .zero)
        episodeArtworkImageView.frame.origin = CGPoint(x: leftMargin, y: leftMargin)
        episodeArtworkImageView.frame.size = CGSize(width: artworkDimension, height: artworkDimension)
        addSubview(episodeArtworkImageView)
        
        seriesTitleLabel = UILabel(frame: .zero)
        seriesTitleLabel.font = UIFont.systemFont(ofSize: 16)
        seriesTitleLabel.textColor = UIColor.colorFromCode(0x4aaea9)
        addSubview(seriesTitleLabel)
        
        episodeTitleLabel = UILabel(frame: .zero)
        episodeTitleLabel.font = UIFont.systemFont(ofSize: 24)
        episodeTitleLabel.lineBreakMode = .byWordWrapping
        episodeTitleLabel.numberOfLines = 0
        addSubview(episodeTitleLabel)
        
        dateLabel = UILabel(frame: .zero)
        dateLabel.font = UIFont.systemFont(ofSize: 14)
        addSubview(dateLabel)
        
        descriptionLabel = UILabel(frame: .zero)
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.textColor = UIColor.colorFromCode(0xa8a8b4)
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.numberOfLines = 0
        addSubview(descriptionLabel)
        
        recommendButton = UIButton(frame: .zero)
        recommendButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        recommendButton.setTitleColor(UIColor.colorFromCode(0xa8a8b4), for: .normal)
        recommendButton.setTitle("Recommend", for: .normal)
        recommendButton.sizeToFit()
        recommendButton.frame.origin.x = leftMargin
        recommendButton.addTarget(self, action: #selector(recommendTapped), for: .touchUpInside)
        addSubview(recommendButton)
        
        updateUIForEmptyPlayer()
    }
    
    func updateUIForEpisode(episode: Episode) {
        episodeArtworkImageView.image = #imageLiteral(resourceName: "sample_series_artwork")
        seriesTitleLabel.text = episode.series?.title ?? "No Series"
        episodeTitleLabel.text = episode.title
        dateLabel.text = "November 7, 2016"
        descriptionLabel.text = episode.descriptionText
        layoutUI()
    }
    
    func updateUIForEmptyPlayer() {
        episodeArtworkImageView.image = #imageLiteral(resourceName: "sample_series_artwork")
        seriesTitleLabel.text = "No Series"
        episodeTitleLabel.text = "No Episode"
        dateLabel.text = "No Date"
        descriptionLabel.text = "No description"
        layoutUI()
    }
    
    func layoutUI() {
        seriesTitleLabel.frame = CGRect(x: 81.5, y: 24, width: frame.size.width - 81.5 - 12, height: 45.5)
        episodeTitleLabel.frame = CGRect(x: leftMargin, y: episodeTitleYInset, width: frame.size.width - 2 * leftMargin, height: 85.5)
        episodeTitleLabel.sizeToFit()
        dateLabel.frame.origin = CGPoint(x: leftMargin, y: episodeTitleLabel.frame.maxY + dateLabelYSpacing)
        dateLabel.sizeToFit()
        descriptionLabel.frame.origin = CGPoint(x: leftMargin, y: dateLabel.frame.maxY + descriptionLabelSpacing)
        descriptionLabel.frame.size = CGSize(width: frame.size.width - 2 * leftMargin, height: 0)
        descriptionLabel.sizeToFit()
        recommendButton.frame.origin.y = descriptionLabel.frame.maxY + recommendButtonSpacing
        frame.size.height = recommendButton.frame.maxY + bottomSpacing
    }
    
    func recommendTapped() {
        // TODO: implement recommend button
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
