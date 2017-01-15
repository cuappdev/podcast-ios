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
    var iconButtonSize: CGFloat = 16
    var clickToPlayImageButtonSize: CGFloat = 64
    var episodeDescriptionLabelWidth: CGFloat = 265
    var episodeDescriptionLabelHeight: CGFloat = 50
    var seperatorHeight: CGFloat = 10
    var textMinX: CGFloat = 88
    var moreButtonMinX: CGFloat = 120
    var clickToPlayButtonMinX: CGFloat = 12
    var clickToPlayButtonMinY: CGFloat = 13
    var padding: CGFloat = 10
    var episodeNameLabelHeight: CGFloat = 36
    var iconButtonMinYOffset: CGFloat = 12
    var seriesNameLabelMinY: CGFloat = 33
    var episodeDescriptionLabelMinY: CGFloat = 50
    var episodeNameLabelMinY: CGFloat = 4
    var heightConstraint: NSLayoutConstraint!
    var playIconButtonSize: CGFloat = 30
    
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
    var isExpanded: Bool!
    var playIconView: UIImageView!
    
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
                    clickToPlayImageButton.setImage(image, for: .normal)
                } else {
                    clickToPlayImageButton.setImage(#imageLiteral(resourceName: "fillerImage"), for: .normal)
                }
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .long
                dateFormatter.timeStyle = .none
                episodeDateLabel.text = dateFormatter.string(from: episode.dateCreated! as Date)
                episodeDescriptionLabel.text = episode.descriptionText
            }
        }
    }
    
    
    ///
    ///Mark: Init
    ///
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        frame.size.height = height
        backgroundColor = .podcastWhite
        selectionStyle = .none
        isExpanded = false
        adjustForScreenSizeUsingPercentage()
        
        seperator = UIView(frame: CGRect.zero)
        seperator.backgroundColor = .podcastGray
        contentView.addSubview(seperator)
        
        seriesNameLabel = UILabel(frame: CGRect.zero)
        seriesNameLabel.textAlignment = .left
        seriesNameLabel.lineBreakMode = .byWordWrapping
        seriesNameLabel.font = .systemFont(ofSize: 12.0)
        contentView.addSubview(seriesNameLabel)
        
        episodeNameLabel = UILabel(frame: CGRect.zero)
        episodeNameLabel.textAlignment = .left
        episodeNameLabel.lineBreakMode = .byWordWrapping
        episodeNameLabel.font = UIFont.systemFont(ofSize: 15.0)
        episodeNameLabel.textColor = UIColor.black
        contentView.addSubview(episodeNameLabel)
        
        episodeDateLabel = UILabel(frame: CGRect.zero)
        episodeDateLabel.textAlignment = .left
        episodeDateLabel.lineBreakMode = .byWordWrapping
        episodeDateLabel.font = .systemFont(ofSize: 12.0)
        contentView.addSubview(episodeDateLabel)
        
        episodeDescriptionLabel = UILabel(frame: CGRect.zero)
        episodeDescriptionLabel.textAlignment = .left
        episodeDescriptionLabel.lineBreakMode = .byWordWrapping
        episodeDescriptionLabel.numberOfLines = 3
        episodeDescriptionLabel.font = .systemFont(ofSize: 11.0)
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
        
        playIconView = UIImageView(frame: CGRect.zero)
        playIconView.image = #imageLiteral(resourceName: "Play")
        
        adjustForScreenSize()
        
        heightConstraint = NSLayoutConstraint(item: contentView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: height)
    
        contentView.addConstraint(heightConstraint!)
        
        NSLayoutConstraint.activate([heightConstraint])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        clickToPlayImageButton.frame = CGRect(x: clickToPlayButtonMinX, y: clickToPlayButtonMinY, width: clickToPlayImageButtonSize, height: clickToPlayImageButtonSize)
        
        playIconView.frame = CGRect(x: 0, y: 0, width: playIconButtonSize, height: playIconButtonSize)
        playIconView.center = CGPoint(x: clickToPlayImageButtonSize / 2, y: clickToPlayImageButtonSize / 2)
        clickToPlayImageButton.imageView?.addSubview(playIconView)
        
        episodeDescriptionLabel.frame = CGRect(x: textMinX, y: episodeDescriptionLabelMinY, width: frame.width - textMinX - padding, height: 0)
        
        let size = CGSize(width: episodeDescriptionLabel.frame.width, height: CGFloat(MAXFLOAT))
        
        if isExpanded! {
            episodeDescriptionLabel.numberOfLines = 0
            episodeDescriptionLabel.frame.size.height = episodeDescriptionLabel.sizeThatFits(size).height
            heightConstraint?.constant = height + episodeDescriptionLabel.frame.size.height - episodeDescriptionLabelHeight
        } else {
            episodeDescriptionLabel.numberOfLines = 3
            episodeDescriptionLabel.frame.size.height = episodeDescriptionLabel.sizeThatFits(size).height
            heightConstraint?.constant = height
            episodeDescriptionLabelHeight = episodeDescriptionLabel.frame.size.height
        }
        
        moreButton.frame = CGRect(x: moreButtonMinX, y: episodeDescriptionLabel.frame.minY + episodeDescriptionLabel.frame.height + iconButtonMinYOffset, width: iconButtonSize, height: iconButtonSize)
        likeButton.frame = CGRect(x: textMinX, y: episodeDescriptionLabel.frame.minY + episodeDescriptionLabel.frame.height + iconButtonMinYOffset, width: iconButtonSize, height: iconButtonSize)
        
        seriesNameLabel.frame = CGRect(x: textMinX, y: seriesNameLabelMinY, width: 0, height: 0)
        seriesNameLabel.sizeToFit()
        
        episodeNameLabel.frame = CGRect(x: textMinX, y: episodeNameLabelMinY, width: frame.width - textMinX - padding, height:  episodeNameLabelHeight)
        
        episodeDateLabel.frame = CGRect(x: seriesNameLabel.frame.maxX, y: seriesNameLabelMinY, width: 0, height: 0)
        episodeDateLabel.sizeToFit()
        
        seperator.frame = CGRect(x: 0, y: frame.height - seperatorHeight, width: frame.width, height: seperatorHeight)

    }

    func adjustForScreenSizeUsingPercentage() {
        let screenWidth = UIScreen.main.bounds.width
        
        var percentageOfiPhone6: CGFloat = 1.0
        if screenWidth <= 320 { //iphone 5
            percentageOfiPhone6 = 0.852
        }
        
        if screenWidth >= 414 { //iphone 6/7 plus
            percentageOfiPhone6 = 1.104
        }
        
        iconButtonSize = iconButtonSize * percentageOfiPhone6
        clickToPlayImageButtonSize = clickToPlayImageButtonSize * percentageOfiPhone6
        episodeDescriptionLabelWidth = episodeDescriptionLabelWidth * percentageOfiPhone6
        episodeDescriptionLabelHeight = episodeDescriptionLabelHeight * percentageOfiPhone6
        seperatorHeight = seperatorHeight * percentageOfiPhone6
        padding =  padding * percentageOfiPhone6
        episodeNameLabelHeight = episodeNameLabelHeight * percentageOfiPhone6
        textMinX = textMinX * percentageOfiPhone6
        iconButtonMinYOffset = iconButtonMinYOffset * percentageOfiPhone6
        moreButtonMinX = moreButtonMinX * percentageOfiPhone6
        
        if screenWidth >= 414 { //iphone 6/7 plus extra check cuz it looks terrible without
            iconButtonMinYOffset = iconButtonMinYOffset - padding
        }
        
        if screenWidth >= 320 {
            height = height * percentageOfiPhone6
        }
    }
    
    
    func adjustForScreenSize() {
        let screenWidth = UIScreen.main.bounds.width
        
        if screenWidth <= 320 { //iphone 5
            
            episodeDateLabel.font = episodeDateLabel.font.withSize(episodeDateLabel.font.pointSize - 1)
            episodeNameLabel.font = episodeNameLabel.font.withSize(episodeNameLabel.font.pointSize - 1)
            seriesNameLabel.font = seriesNameLabel.font.withSize(seriesNameLabel.font.pointSize - 1)
            episodeDescriptionLabel.font = episodeDescriptionLabel.font.withSize(episodeDescriptionLabel.font.pointSize - 1)
            
            clickToPlayImageButton.frame.origin.x = clickToPlayImageButton.frame.origin.x - 4
         
        }
        
        if screenWidth >= 414 { //iphone 6/7 plus
            episodeDateLabel.font = episodeDateLabel.font.withSize(episodeDateLabel.font.pointSize + 2)
            episodeNameLabel.font = episodeNameLabel.font.withSize(episodeNameLabel.font.pointSize + 2)
            seriesNameLabel.font = seriesNameLabel.font.withSize(seriesNameLabel.font.pointSize + 2)
            episodeDescriptionLabel.font = episodeDescriptionLabel.font.withSize(episodeDescriptionLabel.font.pointSize + 2)
            
            clickToPlayImageButton.frame.origin.x = clickToPlayImageButton.frame.origin.x + 2
        }
        
    }
    
    
    ///
    ///Mark - Buttons
    ///
    func likeButtonPress() {
       
    }
    
    func moreButtonPress() {
        
    }
    
    func clickToPlayImageButtonPress() {
        guard let episode = episode else { return }
        Player.sharedInstance.playEpisode(episode: episode)
    }
}




