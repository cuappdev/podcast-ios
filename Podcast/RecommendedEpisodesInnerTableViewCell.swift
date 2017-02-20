//
//  RecommendedEpisodesInnerTableViewCell.swift
//  Podcast
//
//  Created by Kevin Greer on 2/19/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class RecommendedEpisodesInnerTableViewCell: UITableViewCell {
    
    let kPadding: CGFloat = 8
    
    var seriesImageView: UIImageView!
    var titleLabel: UILabel!
    var detailLabel: UILabel!
    var descriptionLabel: UILabel!
    var likesLabel: UILabel!
    var saveButton: UIButton!
    
    let dateFormatter = DateFormatter()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        seriesImageView = UIImageView()
        saveButton = UIButton()
        likesLabel = UILabel()
        titleLabel = UILabel()
        detailLabel = UILabel()
        descriptionLabel = UILabel()
        
        detailLabel.numberOfLines = 2
        descriptionLabel.numberOfLines = 2
        
        titleLabel.font = .systemFont(ofSize: 14, weight: UIFontWeightSemibold)
        detailLabel.font = .systemFont(ofSize: 12, weight: UIFontWeightRegular)
        descriptionLabel.font = .systemFont(ofSize: 14, weight: UIFontWeightRegular)
        likesLabel.font = .systemFont(ofSize: 12, weight: UIFontWeightRegular)
        
        detailLabel.textColor = .podcastGrayDark
        likesLabel.textColor = .podcastGrayDark
        
        likesLabel.text = "93 Recommendations"
        titleLabel.text = "183: Vicious Soda Can (feat. Cat Noone)"
        descriptionLabel.text = "Today we caught up with Cat Noone, a designer and founder currently working on some stuff that makes this long"
        detailLabel.text = "April 21, 2016 · 58 min · Design, Product Management, Growth"
        saveButton.setImage(#imageLiteral(resourceName: "bookmark_unselected_icon"), for: .normal)
        seriesImageView.backgroundColor = .lightGray
        
        dateFormatter.dateFormat = "MMMM d, yyyy"
        
        // Uncomment when we get small gray heart
//        let attachment:NSTextAttachment = NSTextAttachment()
//        attachment.image = #imageLiteral(resourceName: "heart_icon")
//        let attachmentString: NSAttributedString = NSAttributedString(attachment: attachment)
//        
//        let textString: NSAttributedString = NSAttributedString(string: likesLabel.text!)
//        let mutableAttachmentString: NSMutableAttributedString = NSMutableAttributedString(attributedString: attachmentString)
//        mutableAttachmentString.append(textString)
//        
//        likesLabel.attributedText = mutableAttachmentString
        
        preservesSuperviewLayoutMargins = false
        separatorInset = UIEdgeInsets.zero
        layoutMargins = UIEdgeInsets.zero
        
        contentView.addSubview(seriesImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(detailLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(likesLabel)
        contentView.addSubview(saveButton)
    }
    
    func configure(episode: Episode) {
        titleLabel.text = episode.title
        detailLabel.text = "\(dateFormatter.string(from: episode.dateCreated)) · ?? min · Tag1, Longer Tag2, Tag3, Tags 4 & Long Tag Five"
        seriesImageView.image = #imageLiteral(resourceName: "sample_series_artwork")
        descriptionLabel.text = episode.descriptionText
        likesLabel.text = "?? Recommendations"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        seriesImageView.frame = CGRect(x: kPadding, y: kPadding, width: 60, height: 60)
        let afterImageViewX = seriesImageView.frame.maxX+kPadding
        saveButton.frame = CGRect(x: frame.width-kPadding-12, y: kPadding, width: 12, height: 18)
        likesLabel.frame = CGRect(x: afterImageViewX, y: frame.height-kPadding-18, width: frame.width-afterImageViewX, height: 18)
        titleLabel.frame = CGRect(x: afterImageViewX, y: kPadding, width: saveButton.frame.minX-kPadding-afterImageViewX, height: 18)
        detailLabel.frame = CGRect(x: afterImageViewX, y: titleLabel.frame.maxY+3, width: titleLabel.frame.width, height: 30)
        descriptionLabel.frame = CGRect(x: afterImageViewX, y: detailLabel.frame.maxY+kPadding, width: titleLabel.frame.width, height: 36)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
