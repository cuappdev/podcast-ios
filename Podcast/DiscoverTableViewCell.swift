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
    var height: CGFloat = 80
    var defaultFont: UIFont = UIFont(name: ".SFUIText-Medium", size: 12)!
    
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
    
    var episode: Episode? {
        didSet {
            if let episode = episode {
                episodeNameLabel.text = episode.title
                if let episodeSeries = episode.series {
                    seriesNameLabel.text = episodeSeries.title
                } else {
                    seriesNameLabel.text = ""
                }
                
                if let image = episode.smallArtworkImage {
                    clickToPlayImageButton.imageView!.image = image
                } else {
                    clickToPlayImageButton.imageView!.image = UIImage(named: "fillerImage")
                }
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateStyle = .LongStyle
                dateFormatter.timeStyle = .NoStyle
                episodeDateLabel.text = dateFormatter.stringFromDate(episode.dateCreated!)
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
        backgroundColor = UIColor.whiteColor()
        selectionStyle = .None
        
        seriesNameLabel = UILabel(frame: CGRectZero)
        seriesNameLabel.textAlignment = .Left
        seriesNameLabel.lineBreakMode = .ByWordWrapping
        seriesNameLabel.attributedText = NSAttributedString(string: seriesNameLabel.text!, attributes: UIFont.discoverTableViewCellDefaultFontAttributes)
        contentView.addSubview(seriesNameLabel)
        
        episodeNameLabel = UILabel(frame: CGRectZero)
        episodeNameLabel.textAlignment = .Left
        episodeNameLabel.lineBreakMode = .ByWordWrapping
        episodeNameLabel.attributedText = NSAttributedString(string: episodeNameLabel.text!, attributes: UIFont.discoverTableViewCellDefaultFontAttributes)
        contentView.addSubview(episodeNameLabel)
        
        episodeDateLabel = UILabel(frame: CGRectZero)
        episodeDateLabel.textAlignment = .Left
        episodeDateLabel.lineBreakMode = .ByWordWrapping
        episodeDateLabel.attributedText = NSAttributedString(string: episodeDateLabel.text!, attributes: UIFont.discoverTableViewCellDefaultFontAttributes)
        contentView.addSubview(episodeDateLabel)
        
        episodeDescriptionLabel = UILabel(frame: CGRectZero)
        episodeDescriptionLabel.textAlignment = .Left
        episodeDescriptionLabel.lineBreakMode = .ByWordWrapping
        episodeDescriptionLabel.attributedText = NSAttributedString(string: episodeDescriptionLabel.text!, attributes: UIFont.discoverTableViewCellDefaultFontAttributes)
        contentView.addSubview(episodeDescriptionLabel)
        
        likeButton = UIButton(frame: CGRectZero)
        likeButton.addTarget(self, action: #selector(likeButtonPress), forControlEvents: .TouchUpInside)
        likeButton.setImage(UIImage(named: "heartButton"), forState: .Normal)
        contentView.addSubview(likeButton)
        
        moreButton = UIButton(frame: CGRectZero)
        moreButton.addTarget(self, action: #selector(moreButtonPress), forControlEvents: .TouchUpInside)
        moreButton.setImage(UIImage(named: "moreButton"), forState: .Normal)
        contentView.addSubview(moreButton)
        
        clickToPlayImageButton = UIButton(frame: CGRectZero)
        clickToPlayImageButton.addTarget(self, action: #selector(clickToPlayImageButtonPress), forControlEvents: .TouchUpInside)
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
        
        clickToPlayImageButton.frame = CGRectMake(0, 0, 50, 50)
        
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




