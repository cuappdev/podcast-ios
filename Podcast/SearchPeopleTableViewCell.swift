//
//  SearchPeopleTableViewCell.swift
//  Podcast
//
//  Created by Kevin Greer on 3/6/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

protocol SearchPeopleTableViewCellDelegate: class {
    func searchPeopleTableViewCellDidPressFollowButton(cell: SearchPeopleTableViewCell)
}

class SearchPeopleTableViewCell: UITableViewCell {
    
    static let cellHeight: CGFloat = 76
    
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
    let followButtonWidth: CGFloat = 80
    let separatorHeight: CGFloat = 1
    
    var profilePictureImageView: ImageView!
    var nameLabel: UILabel!
    var detailLabel: UILabel!
    var followButton: FillButton!
    var separator: UIView!
    
    var index: Int!
    var username: String = ""
        
    weak var delegate: SearchPeopleTableViewCellDelegate?
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none 
        profilePictureImageView = ImageView(frame: CGRect(x: 0, y: 0, width: imageViewWidth, height: imageViewHeight))
        profilePictureImageView.layer.cornerRadius = imageViewHeight / 2
        profilePictureImageView.clipsToBounds = true
        contentView.addSubview(profilePictureImageView)
        
        nameLabel = UILabel()
        nameLabel.font = ._14SemiboldFont()
        contentView.addSubview(nameLabel)
        
        detailLabel = UILabel()
        detailLabel.font = ._12RegularFont()
        detailLabel.textColor = .charcoalGrey
        contentView.addSubview(detailLabel)
        
        followButton = FillButton(type: .followWhite)
        followButton.setTitle("Follow", for: .normal)
        followButton.setTitle("Following", for: .selected)
        followButton.backgroundColor = .clear
        followButton.addTarget(self, action: #selector(didPressFollowButton), for: .touchUpInside)
        contentView.addSubview(followButton)
        
        separator = UIView()
        separator.backgroundColor = .silver
        contentView.addSubview(separator)
        
        separator.snp.makeConstraints { make in
            make.height.equalTo(separatorHeight)
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview().inset(imageViewPaddingX + imageViewWidth)
            make.trailing.equalToSuperview()
        }
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

    func configure(for user: User, index: Int) {
        followButton.isHidden = false // prepare for reuse 
        self.index = index
        profilePictureImageView.setImageAsynchronouslyWithDefaultImage(url: user.imageURL, defaultImage: #imageLiteral(resourceName: "person"))
        profilePictureImageView.sizeToFit()
        nameLabel.text = user.firstName + " " + user.lastName
        if user.id == System.currentUser?.id {
            followButton.isHidden = true 
        }
        username  = user.username
        setFollowButtonState(isFollowing: user.isFollowing, numberOfFollowers: user.numberOfFollowers)
    }
    
    @objc func didPressFollowButton() {
        delegate?.searchPeopleTableViewCellDidPressFollowButton(cell: self)
    }

    func setFollowButtonState(isFollowing: Bool, numberOfFollowers: Int) {
        followButton.isSelected = isFollowing
        var titleString = "@\(username)"
        if numberOfFollowers > 0 {
            titleString += " • \(numberOfFollowers.shortString()) followers"
        }
        detailLabel.text = titleString
    }
}
