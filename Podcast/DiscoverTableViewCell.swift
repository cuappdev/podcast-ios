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
        
        seriesNameLabel = UILabel(frame: CGRect.zero)
        seriesNameLabel.textAlignment = .left
        seriesNameLabel.lineBreakMode = .byWordWrapping
        seriesNameLabel.attributedText = NSAttributedString(string: seriesNameLabel.text!, attributes: UIFont.discoverTableViewCellDefaultFontAttributes)
        contentView.addSubview(seriesNameLabel)
        
        episodeNameLabel = UILabel(frame: CGRect.zero)
        episodeNameLabel.textAlignment = .left
        episodeNameLabel.lineBreakMode = .byWordWrapping
        episodeNameLabel.attributedText = NSAttributedString(string: episodeNameLabel.text!, attributes: UIFont.discoverTableViewCellDefaultFontAttributes)
        contentView.addSubview(episodeNameLabel)
        
        episodeDateLabel = UILabel(frame: CGRect.zero)
        episodeDateLabel.textAlignment = .left
        episodeDateLabel.lineBreakMode = .byWordWrapping
        episodeDateLabel.attributedText = NSAttributedString(string: episodeDateLabel.text!, attributes: UIFont.discoverTableViewCellDefaultFontAttributes)
        contentView.addSubview(episodeDateLabel)
        
        episodeDescriptionLabel = UILabel(frame: CGRect.zero)
        episodeDescriptionLabel.textAlignment = .left
        episodeDescriptionLabel.lineBreakMode = .byWordWrapping
        episodeDescriptionLabel.attributedText = NSAttributedString(string: episodeDescriptionLabel.text!, attributes: UIFont.discoverTableViewCellDefaultFontAttributes)
        contentView.addSubview(episodeDescriptionLabel)
        
        likeButton = UIButton(frame: CGRect.zero)
        likeButton.addTarget(self, action: #selector(likeButtonPress), for: .touchUpInside)
        likeButton.setImage(UIImage(named: "heartButton"), for: UIControlState())
        contentView.addSubview(likeButton)
        
        moreButton = UIButton(frame: CGRect.zero)
        moreButton.addTarget(self, action: #selector(moreButtonPress), for: .touchUpInside)
        moreButton.setImage(UIImage(named: "moreButton"), for: UIControlState())
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
        
        clickToPlayImageButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        
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




