//
//  UserDetailInfoView.swift
//  Podcast
//
//  Created by Drew Dunne on 3/8/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import UIKit

class UserDetailInfoView: UIView {

    static let infoAreaMinHeight:CGFloat = 246
    
    let padding: CGFloat = 12
    
    let profileImageY: CGFloat = 56
    let profileImageBottomY: CGFloat = 130
    let profileImageSize: CGFloat = 60
    
    let nameLabelBottomY: CGFloat = 91
    let nameLabelHeight: CGFloat = 19
    
    let usernameLabelBottomY: CGFloat = 73
    let usernameLabelHeight: CGFloat = 17
    
    let followButtonBottomY: CGFloat = 18
    let followButtonWidth: CGFloat = 95
    let followButtonHeight: CGFloat = 34
    
    var profileImageView: ImageView!
    var nameLabel: UILabel!
    var usernameLabel: UILabel!
    var followButton: FillButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .sea
        
        profileImageView = ImageView()
        profileImageView.layer.cornerRadius = profileImageSize/2.0
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.borderWidth = 2
        profileImageView.layer.borderColor = UIColor.offWhite.cgColor
        addSubview(profileImageView)
        
        nameLabel = UILabel(frame: .zero)
        nameLabel.font = ._16SemiboldFont()
        nameLabel.textAlignment = .center
        nameLabel.textColor = .offWhite
        nameLabel.text = ""
        nameLabel.numberOfLines = 1
        addSubview(nameLabel)
        
        usernameLabel = UILabel(frame: .zero)
        usernameLabel.font = ._14RegularFont()
        usernameLabel.textAlignment = .center
        usernameLabel.textColor = .offWhite
        usernameLabel.alpha = 0.7
        usernameLabel.text = "@"
        usernameLabel.numberOfLines = 1
        addSubview(usernameLabel)
        
        followButton = FillButton(type: .follow)
        followButton.setTitle("Follow", for: .normal)
        followButton.setTitle("Following", for: .selected)
        addSubview(followButton)
        
        layoutUI()
    }
    
    func animateBy(yOffset: CGFloat) {
        let proImageHalfPoint = (profileImageY+profileImageSize/4)
        if yOffset <= 0 {
            profileImageView.alpha = 1
        } else if yOffset >= proImageHalfPoint {
            profileImageView.alpha = 0
        } else {
            profileImageView.alpha = abs((proImageHalfPoint-yOffset)/yOffset)
        }
        let belowThreshold = (yOffset <= (109))
        if belowThreshold {
            followButton.alpha = 1
        } else if yOffset > 109+followButtonHeight {
            followButton.alpha = 0
        } else {
            followButton.alpha = abs((followButtonHeight+109-yOffset)/followButtonHeight)
        }
    }
    
    func configure(for user: User, isMe: Bool) {
        followButton.isSelected = user.isFollowing
        followButton.isHidden = isMe
        profileImageView.setImageAsynchronouslyWithDefaultImage(url: user.imageURL)
        nameLabel.text = user.fullName()
        usernameLabel.text = "@\(user.username)"
    }
    
    func layoutUI() {
        // SnapKit view setup
        profileImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.width.equalTo(profileImageSize)
            make.bottom.equalToSuperview().inset(profileImageBottomY)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(nameLabelHeight)
            make.leading.trailing.equalToSuperview().inset(padding)
            make.bottom.equalToSuperview().inset(nameLabelBottomY)
        }
        
        usernameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(usernameLabelHeight)
            make.leading.trailing.equalToSuperview().inset(padding)
            make.bottom.equalToSuperview().inset(usernameLabelBottomY)
        }
        
        followButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(followButtonBottomY)
            make.height.equalTo(followButtonHeight)
            make.width.equalTo(followButtonWidth)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
