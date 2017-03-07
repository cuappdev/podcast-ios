//
//  SearchPeopleTableViewCell.swift
//  Podcast
//
//  Created by Kevin Greer on 3/6/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class SearchPeopleTableViewCell: UITableViewCell {
    
    let imageViewPaddingX: CGFloat = 18
    let imageViewPaddingY: CGFloat = 18
    let imageViewWidth: CGFloat = 40
    let imageViewHeight: CGFloat = 40
    let imageViewLabelPadding: CGFloat = 12
    let nameLabelPaddingY: CGFloat = 22
    let nameLabelHeight: CGFloat = 17
    let detailLabelHeight: CGFloat = 15
    let followButtonPaddingX: CGFloat = 18
    let followButtonPaddingY: CGFloat = 21
    let followButtonHeight: CGFloat = 34
    let followButtonWidth: CGFloat = 73
    
    var profilePictureImageView: UIImageView!
    var nameLabel: UILabel!
    var detailLabel: UILabel!
    var followButton: UIButton!
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        profilePictureImageView = UIImageView()
        profilePictureImageView.layer.cornerRadius = imageViewHeight/2
        profilePictureImageView.clipsToBounds = true
        contentView.addSubview(profilePictureImageView)
        
        nameLabel = UILabel()
        nameLabel.font = .systemFont(ofSize: 14, weight: UIFontWeightSemibold)
        contentView.addSubview(nameLabel)
        
        detailLabel = UILabel()
        detailLabel.font = .systemFont(ofSize: 12, weight: UIFontWeightRegular)
        detailLabel.textColor = .podcastGrayDark
        contentView.addSubview(detailLabel)
        
        followButton = UIButton()
        followButton.layer.borderColor = UIColor.podcastGreenBlue.cgColor
        followButton.layer.borderWidth = 1
        followButton.setTitle("Follow", for: .normal)
        followButton.setTitleColor(.podcastGreenBlue, for: .normal)
        followButton.titleLabel?.font = .systemFont(ofSize: 14, weight: UIFontWeightRegular)
        followButton.addTarget(self, action: #selector(didPressFollowButton), for: .touchUpInside)
        followButton.clipsToBounds = true
        contentView.addSubview(followButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profilePictureImageView.frame = CGRect(x: imageViewPaddingX, y: imageViewPaddingY, width: imageViewWidth, height: imageViewHeight)
        let nameLabelX: CGFloat = profilePictureImageView.frame.maxX + imageViewLabelPadding
        let followButtonX: CGFloat = frame.width - followButtonPaddingX - followButtonWidth
        nameLabel.frame = CGRect(x: nameLabelX, y: nameLabelPaddingY, width: followButtonX - nameLabelX, height: nameLabelHeight)
        detailLabel.frame = CGRect(x: nameLabelX, y: nameLabel.frame.maxY, width: nameLabel.frame.width, height: detailLabelHeight)
        followButton.frame = CGRect(x: followButtonX, y: followButtonPaddingY, width: followButtonWidth, height: followButtonHeight)
        separatorInset = UIEdgeInsets(top: 0, left: nameLabelX, bottom: 0, right: 0)
    }
    
    func configure(for user: User) {
        profilePictureImageView.image = user.image
        nameLabel.text = user.name
        detailLabel.text = "@\(user.username) • \(user.followersCount) followers"
    }
    
    func didPressFollowButton() {
    }
}
