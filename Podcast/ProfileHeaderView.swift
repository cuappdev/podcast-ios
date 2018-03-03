//
//  ProfileHeaderView.swift
//  Podcast
//
//  Created by Drew Dunne on 10/17/16.
//  Copyright © 2016 Cornell App Development. All rights reserved.
//

import UIKit

protocol ProfileHeaderViewDelegate: class {
    func profileHeaderDidPressFollowButton(profileHeader: ProfileHeaderView)
    func profileHeaderDidPressFollowers(profileHeader: ProfileHeaderView)
    func profileHeaderDidPressFollowing(profileHeader: ProfileHeaderView)
}

class ProfileHeaderView: UIView {
    
    static let statusBarHeight:CGFloat = 20
    static let profileAreaHeight:CGFloat = 246
    static let height: CGFloat = 310
    static var miniBarHeight: CGFloat = 72
    
    let profileAreaHeight:CGFloat = ProfileHeaderView.profileAreaHeight
    let profileImageWidth:CGFloat = 60
    let profileImageY: CGFloat = 56
    let padding: CGFloat = 12
    let nameLabelY: CGFloat = 136
    let nameLabelHeight: CGFloat = 19
    let usernameLabelY: CGFloat = 156
    let usernameLabelHeight: CGFloat = 17
    let followButtonY: CGFloat = 194
    let followButtonWidth: CGFloat = 95
    let followButtonHeight: CGFloat = 34
    let iPhoneXTopOffset: CGFloat = 10
    
    let buttonBarHeight:CGFloat = 64
    let verticalDividerPadding: CGFloat = 18

    var profileArea: UIView!
    var usernameLabel: UILabel!
    var nameLabel: UILabel!
    var profileImage: ImageView!
    var followButton: FillButton!
    var moreButton: UIButton!
    
    var followersButton: UIButton!
    var followingButton: UIButton!
    var verticalDivider: UIView!
    var buttonBar: UIView!
    
    weak var delegate: ProfileHeaderViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .sea
        
        if Constants.isiPhoneX() { ProfileHeaderView.miniBarHeight += iPhoneXTopOffset }
        
        profileArea = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: profileAreaHeight))
        profileArea.backgroundColor = .sea;
        
        buttonBar = UIView(frame: CGRect(x: 0, y: profileAreaHeight, width: frame.width, height: buttonBarHeight))
        buttonBar.backgroundColor = .offWhite
        
        profileImage = ImageView(frame: CGRect(x: (frame.width - profileImageWidth) / 2, y: profileImageY, width: profileImageWidth, height: profileImageWidth))
        profileImage.layer.cornerRadius = profileImageWidth/2.0
        profileImage.layer.masksToBounds = true
        profileImage.layer.borderWidth = 2
        profileImage.layer.borderColor = UIColor.offWhite.cgColor
        profileArea.addSubview(profileImage)
        
        nameLabel = UILabel(frame: .zero)
        nameLabel.font = ._16SemiboldFont()
        nameLabel.textAlignment = .center
        nameLabel.textColor = .offWhite
        nameLabel.text = ""
        nameLabel.numberOfLines = 1
        profileArea.addSubview(nameLabel)
        
        usernameLabel = UILabel(frame: .zero)
        usernameLabel.font = ._14RegularFont()
        usernameLabel.textAlignment = .center
        usernameLabel.textColor = .offWhite
        usernameLabel.alpha = 0.7
        usernameLabel.text = "@"
        usernameLabel.numberOfLines = 1
        profileArea.addSubview(usernameLabel)
        
        followButton = FillButton(type: .follow)
        followButton.setTitle("Follow", for: .normal)
        followButton.setTitle("Following", for: .selected)
        followButton.addTarget(self, action: #selector(followPressed), for: .touchUpInside)
        profileArea.addSubview(followButton)
        
        verticalDivider = UIView()
        verticalDivider.backgroundColor = .paleGrey
        buttonBar.addSubview(verticalDivider)
        followersButton = makeBottomBarButton(1)
        buttonBar.addSubview(followersButton)
        followingButton = makeBottomBarButton(2)
        buttonBar.addSubview(followingButton)
        
        addSubview(buttonBar)
        addSubview(profileArea)
        
        profileArea.isHidden = true
        followingButton.isHidden = true
        followersButton.isHidden = true
    }
    
    override func layoutSubviews() {
        // Width for bottom bar buttons
        followersButton.frame = CGRect(x: 0, y: 0, width: frame.width / 2, height: buttonBarHeight)
        followingButton.frame = CGRect(x: frame.width / 2, y: 0, width: frame.width / 2, height: buttonBarHeight)
        verticalDivider.frame = CGRect(x: frame.width / 2, y: verticalDividerPadding, width: 1, height: buttonBarHeight - 2 * verticalDividerPadding)
        
        profileArea.frame = CGRect(x: 0, y: 0, width: frame.width, height: profileAreaHeight)
        profileImage.frame = CGRect(x: (frame.width - profileImageWidth) / 2, y: profileImageY, width: profileImageWidth, height: profileImageWidth)
        profileImage.layer.cornerRadius = profileImageWidth/2.0
        
        let labelWidth: CGFloat = frame.width - 2 * padding
        nameLabel.frame = CGRect(x: padding, y: nameLabelY, width: labelWidth, height: nameLabelHeight)
        usernameLabel.frame = CGRect(x: padding, y: usernameLabelY, width: labelWidth, height: usernameLabelHeight)
        followButton.frame = CGRect(x: (frame.width - followButtonWidth) / 2, y: followButtonY, width: followButtonWidth, height: followButtonHeight)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUser(_ user: User) {
        followersButton.setAttributedTitle(formatBottomBarButtonTitle("Followers", user.numberOfFollowers), for: .normal)
        followingButton.setAttributedTitle(formatBottomBarButtonTitle("Following", user.numberOfFollowing), for: .normal)
        
        profileImage.setImageAsynchronouslyWithDefaultImage(url: user.imageURL, defaultImage: #imageLiteral(resourceName: "person"))
        
        nameLabel.text = user.fullName()
        usernameLabel.text = "@\(user.username)"
        followButton.isSelected = user.isFollowing
        if let currentUser = System.currentUser {
            followButton.isHidden = (user.id == currentUser.id)
        } else {
            followButton.isHidden = false
        }
        
        profileArea.isHidden = false
        followingButton.isHidden = false
        followersButton.isHidden = false
    }
    
    func animateByYOffset(_ yOffset: CGFloat) {
        let proImageHalfPoint = (profileImageY+profileImageWidth/4)
        if yOffset <= 0 {
            profileImage.alpha = 1
        } else if yOffset >= proImageHalfPoint {
            profileImage.alpha = 0
        } else {
            profileImage.alpha = abs((proImageHalfPoint-yOffset)/yOffset)
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
    
    func makeBottomBarButton(_ tag: Int) -> UIButton {
        let button = UIButton(frame: CGRect.zero)
        button.tag = tag
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.numberOfLines = 2
        button.addTarget(self, action: #selector(buttonBarPressed(sender:)), for: .touchUpInside)
        return button
    }
    
    func formatBottomBarButtonTitle(_ text: String, _ num: Int) -> NSMutableAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 2.5
        paragraphStyle.alignment = .center
        
        let numText = "\(num)"
        let title = NSMutableAttributedString(string: "\(text)\n\(numText)")
        title.addAttributes([NSAttributedStringKey.font: UIFont._12RegularFont(), NSAttributedStringKey.foregroundColor: UIColor.slateGrey], range: NSRange(location:0, length: text.count))
        title.addAttributes([NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14),NSAttributedStringKey.foregroundColor: UIColor.offBlack], range: NSRange(location:text.count+1, length: numText.count))
        title.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, title.length))
        return title
    }
    
    @objc func followPressed() {
        followButton.isSelected = !followButton.isSelected
        delegate?.profileHeaderDidPressFollowButton(profileHeader: self)
    }
    
    @objc func buttonBarPressed(sender: UIButton) {
        switch sender.tag {
        case 1:
            delegate?.profileHeaderDidPressFollowers(profileHeader: self)
        case 2:
            delegate?.profileHeaderDidPressFollowing(profileHeader: self)
        default:
            break
        }
    }

}
