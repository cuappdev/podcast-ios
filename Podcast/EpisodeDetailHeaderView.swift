//
//  EpisodeDetailHeaderView.swift
//  Podcast
//
//  Created by Mark Bryan on 4/11/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class EpisodeDetailHeaderView: UIView {
    var episodeArtworkImageView: UIImageView!
    var seriesTitleLabel: UILabel!
    var publisherLabel: UILabel!
    var episodeTitleLabel: UILabel!
    var dateLabel: UILabel!
    var descriptionLabel: UILabel!
    
    let marginSpacing: CGFloat = 18
    let artworkDimension: CGFloat = 79
    
    let seriesTitleLabelXValue: CGFloat = 109
    let seriesTitleLabelYValue: CGFloat = 36.5
    let seriesTitleHeight: CGFloat = 24
    
    let publisherLabelXValue: CGFloat = 109
    let publisherLabelYValue: CGFloat = 62
    let publisherLabelHeight: CGFloat = 17
    
    let episodeTitleLabelYValue: CGFloat = 117
    
    let dateLabelYSpacing: CGFloat = 6
    let descriptionLabelYSpacing: CGFloat = 6
    let bottomSpacing: CGFloat = 20

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        episodeArtworkImageView = UIImageView(frame: CGRect(x: marginSpacing,
                                                            y: marginSpacing,
                                                            width: artworkDimension,
                                                            height: artworkDimension))
        addSubview(episodeArtworkImageView)
        
        seriesTitleLabel = UILabel(frame: CGRect(x: seriesTitleLabelXValue,
                                                 y: seriesTitleLabelYValue,
                                                 width: frame.width - marginSpacing - seriesTitleLabelXValue,
                                                 height: seriesTitleHeight))
        seriesTitleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        seriesTitleLabel.textColor = UIColor.colorFromCode(0x4aaea9)
        addSubview(seriesTitleLabel)
        
        publisherLabel = UILabel(frame: CGRect(x: publisherLabelXValue,
                                               y: publisherLabelYValue,
                                               width: frame.width - marginSpacing - publisherLabelXValue,
                                               height: publisherLabelHeight))
        publisherLabel.font = UIFont.systemFont(ofSize: 14)
        publisherLabel.textColor = UIColor.colorFromCode(0x959ba5)
        addSubview(publisherLabel)
        
        episodeTitleLabel = UILabel(frame: CGRect(x: marginSpacing, y: episodeTitleLabelYValue, width: frame.width - 2 * marginSpacing, height: 0))
        episodeTitleLabel.font = UIFont.systemFont(ofSize: 24)
        episodeTitleLabel.lineBreakMode = .byWordWrapping
        episodeTitleLabel.numberOfLines = 0
        addSubview(episodeTitleLabel)
        
        dateLabel = UILabel(frame: CGRect(x: marginSpacing, y: 0, width: frame.width - 2 * marginSpacing, height: 0))
        dateLabel.font = UIFont.systemFont(ofSize: 14)
        addSubview(dateLabel)
        
        descriptionLabel = UILabel(frame: CGRect(x: marginSpacing, y: 0, width: frame.width - 2 * marginSpacing, height: 0))
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.textColor = UIColor.colorFromCode(0xa8a8b4)
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.numberOfLines = 0
        addSubview(descriptionLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupForEpisode(episode: Episode) {
        // TODO: load from URL
        episodeArtworkImageView.image = #imageLiteral(resourceName: "filler_image")
        if let url = episode.smallArtworkImageURL {
            if let data = try? Data(contentsOf: url) {
                episodeArtworkImageView.image = UIImage(data: data)
            }
        }
        
        if episode.seriesTitle != "" {
            seriesTitleLabel.text = "Wait Wait Don't Tell Me"
        } else {
            seriesTitleLabel.text = episode.seriesTitle
        }
        
        // TODO: implement publishers
        publisherLabel.text = "NPR >"
        
        episodeTitleLabel.text = episode.title
        episodeTitleLabel.sizeToFit()
        dateLabel.text = episode.dateTimeSeriesString()
        dateLabel.sizeToFit()
        dateLabel.frame.origin.y = episodeTitleLabel.frame.maxY + dateLabelYSpacing
        descriptionLabel.text = episode.descriptionText
        descriptionLabel.sizeToFit()
        descriptionLabel.frame.origin.y = dateLabel.frame.maxY + descriptionLabelYSpacing
        frame.size.height = descriptionLabel.frame.maxY + bottomSpacing
    }

}
