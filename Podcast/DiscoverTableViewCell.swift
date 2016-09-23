//
//  FeedTableViewCell.swift
//  Podcast
//
//  Created by Natasha Armbrust on 9/18/16.
//  Copyright © 2016 Cornell App Development. All rights reserved.
//

import UIKit

class DiscoverTableViewCell: UITableViewCell {
    
    ///
    /// Mark: View Constants
    ///
    var height: CGFloat = 152
    
    ///
    /// Mark: Variables
    ///
    var episodeNameLabel: UILabel!
    var seriesNameLabel: UILabel!
    var episodeDateLabel: UILabel!
    var episodeDescriptionLabel: UILabel!
    var likeButton: UIButton!
    var moreButton: UIButton!
    var clickToPlayImageButton: UIButton!
    var seperator: UIView!
    
    var episode: Episode? {
        didSet {
            if let episode = episode {
                episodeNameLabel.text = episode.title
                if let episodeSeries = episode.series {
                    seriesNameLabel.text = episodeSeries.title + " • "
                } else {
                    seriesNameLabel.text = ""
                }
                
                if let image = episode.smallArtworkImage {
                    clickToPlayImageButton.imageView!.image = image
                } else {
                    clickToPlayImageButton.imageView!.image = UIImage(named: "fillerImage")
                }
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .long
                dateFormatter.timeStyle = .none
                episodeDateLabel.text = dateFormatter.string(from: episode.dateCreated! as Date)
                episodeDescriptionLabel.text = episode.description
            }
        }
    }
    
    
    ///
    ///Mark: Init
    ///
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        frame.size.height = height
        backgroundColor = UIColor.white
        selectionStyle = .none
        
        seperator = UIView(frame: CGRect.zero)
        seperator.backgroundColor = UIColor.podcastGrayLight
        contentView.addSubview(seperator)
        
        seriesNameLabel = UILabel(frame: CGRect.zero)
        seriesNameLabel.textAlignment = .left
        seriesNameLabel.lineBreakMode = .byWordWrapping
        seriesNameLabel.font = UIFont(name: "Avenir", size: 12.0)
        contentView.addSubview(seriesNameLabel)
        
        episodeNameLabel = UILabel(frame: CGRect.zero)
        episodeNameLabel.textAlignment = .left
        episodeNameLabel.lineBreakMode = .byWordWrapping
        episodeNameLabel.font = UIFont(name: "Avenir", size: 15.0)
        episodeNameLabel.textColor = UIColor.black
        contentView.addSubview(episodeNameLabel)
        
        episodeDateLabel = UILabel(frame: CGRect.zero)
        episodeDateLabel.textAlignment = .left
        episodeDateLabel.lineBreakMode = .byWordWrapping
        episodeDateLabel.font = UIFont(name: "Avenir", size: 12.0)
        contentView.addSubview(episodeDateLabel)
        
        episodeDescriptionLabel = UILabel(frame: CGRect.zero)
        episodeDescriptionLabel.textAlignment = .left
        episodeDescriptionLabel.lineBreakMode = .byWordWrapping
        episodeDescriptionLabel.numberOfLines = 3
        episodeDescriptionLabel.font = UIFont(name: "Avenir", size: 11.0)
        contentView.addSubview(episodeDescriptionLabel)
        
        likeButton = UIButton(frame: CGRect.zero)
        likeButton.addTarget(self, action: #selector(likeButtonPress), for: .touchUpInside)
        likeButton.setImage(UIImage(named: "heartIcon"), for: UIControlState())
        contentView.addSubview(likeButton)
        
        moreButton = UIButton(frame: CGRect.zero)
        moreButton.addTarget(self, action: #selector(moreButtonPress), for: .touchUpInside)
        moreButton.setImage(UIImage(named: "moreIcon"), for: UIControlState())
        contentView.addSubview(moreButton)
        
        clickToPlayImageButton = UIButton(frame: CGRect.zero)
        clickToPlayImageButton.addTarget(self, action: #selector(clickToPlayImageButtonPress), for: .touchUpInside)
        contentView.addSubview(clickToPlayImageButton)
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        clickToPlayImageButton.frame = CGRect(x: 12, y: 13, width: 64, height: 64)
        
        episodeDescriptionLabel.frame = CGRect(x: 88, y: 50, width: 265, height: 50)
        
        moreButton.frame = CGRect(x: 120, y: 109, width: 16, height: 16)
        likeButton.frame = CGRect(x: 88, y: 109, width: 16, height: 16)
        
        seriesNameLabel.frame = CGRect(x: 88, y: 33, width: 0, height: 0)
        seriesNameLabel.sizeToFit()
        
        episodeNameLabel.frame = CGRect(x: 88, y: 4, width: self.frame.width - 88 - 10, height: 36)
        
        episodeDateLabel.frame = CGRect(x: seriesNameLabel.frame.maxX, y: 33, width: 0, height: 0)
        episodeDateLabel.sizeToFit()
        
        seperator.frame = CGRect(x: 0, y: height - 10, width: self.frame.width, height: 10)
    }

    ///
    ///Mark - Buttons
    ///
    func likeButtonPress() {
        
    }
    
    func moreButtonPress() {
        
    }
    
    func clickToPlayImageButtonPress() {
        
    }
}




