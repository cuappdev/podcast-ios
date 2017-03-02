//
//  ProfileHeaderView.swift
//  Podcast
//
//  Created by Drew Dunne on 10/17/16.
//  Copyright © 2016 Cornell App Development. All rights reserved.
//

import UIKit

struct PHVConstants {
    static let height:CGFloat = 286+138+37
    static let miniHeight:CGFloat = 85
    static let bottomBarDist:CGFloat = 226
    static let statusBarHeight:CGFloat = 20
}

protocol ProfileHeaderViewDelegate {
    func followButtonPressed(follow: Bool)
    func buttonBarPressed(buttonBarNum: Int)
    func collectionViewCellDidSelectItemAtPath(path: IndexPath)
}

class ProfileHeaderView: UIView, UICollectionViewDelegate {
    
    let fullHeight:CGFloat = PHVConstants.height
    
    let statusBarHeight:CGFloat = PHVConstants.statusBarHeight
    let bottomBarDist:CGFloat = PHVConstants.bottomBarDist
    let bottomBarHeight:CGFloat = 60
    let subscriptionsHeight: CGFloat = 138
    
    let proImgWidth:CGFloat = 60
    let proImgY: CGFloat = 28.5
    let padding: CGFloat = 12
    let labelHeight: CGFloat = 19
    let labelSpacing: CGFloat = 2.5
    let vertBarPadding: CGFloat = 12
    let followButtonWidth: CGFloat = 150
    let followButtonHeight: CGFloat = 29

    var profileArea: UIView!
    var usernameLabel: UILabel!
    var nameLabel: UILabel!
    var profileImage: UIImageView!
    var followButton: FollowButton!
    
    var subsHeader: ProfileSectionHeaderView!
    var subscriptions: UICollectionView!
    
    // Currently: Followers, Following (Used to include subscriptions)
    var followersButton: UIButton!
    var followingButton: UIButton!
    private var bottomBar: UIView!
    let numBottomBarButtons: CGFloat = 2.0
    
    private var topBar: UIView!
    
    var user: User? {
        didSet {
            guard let user = user else { return }
            followersButton.setAttributedTitle(formBotBarButtonTitle("Followers", user.numberOfFollowers), for: .normal)
            followingButton.setAttributedTitle(formBotBarButtonTitle("Following", user.numberOfFollowing), for: .normal)
            
            profileImage.image = user.image
            nameLabel.text = user.name
            usernameLabel.text = "@\(user.username)"
            followButton.isSelected = user.isFollowing
            
            if user is CurrentUser {
                followButton.alpha = 0
            }
        }
    }
    var delegate: ProfileHeaderViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .podcastGrayDark
        
        topBar = UIView(frame: CGRect(x:0, y:0, width: frame.width, height: statusBarHeight))
        topBar.backgroundColor = .podcastWhite
        
        bottomBar = UIView(frame: CGRect(x:0, y:bottomBarDist, width: frame.width, height: bottomBarHeight))
        bottomBar.backgroundColor = .podcastWhiteDark
        
        profileArea = UIView(frame: CGRect(x: 0, y: statusBarHeight, width: frame.width, height: bottomBarDist-statusBarHeight))
        profileArea.backgroundColor = .clear;
        
        profileImage = UIImageView(frame: .zero)
        profileImage.layer.masksToBounds = true
        profileImage.layer.borderWidth = 2
        profileImage.layer.borderColor = UIColor.podcastWhite.cgColor
        profileArea.addSubview(profileImage)
        
        nameLabel = UILabel(frame: CGRect.zero)
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightSemibold)
        nameLabel.textAlignment = .center
        nameLabel.textColor = .podcastWhite
        nameLabel.text = "@"
        nameLabel.numberOfLines = 1
        profileArea.addSubview(nameLabel)
        
        usernameLabel = UILabel(frame: CGRect.zero)
        usernameLabel.font = UIFont.systemFont(ofSize: 16)
        usernameLabel.textAlignment = .center
        usernameLabel.textColor = .podcastWhite
        usernameLabel.text = "@"
        usernameLabel.numberOfLines = 1
        profileArea.addSubview(usernameLabel)
        
        followButton = FollowButton()
        followButton.tintColor = UIColor.podcastWhite
        followButton.setTitle("Follow", for: .normal)
        followButton.setTitle("Unfollow", for: .selected)
        followButton.addTarget(self, action: #selector(ProfileHeaderView.followPressed), for: .touchUpInside)
        profileArea.addSubview(followButton)
        
        followersButton = makeBotBarButton(1)
        bottomBar.addSubview(followersButton)
        
        followingButton = makeBotBarButton(2)
        bottomBar.addSubview(followingButton)
        
        subsHeader = ProfileSectionHeaderView(frame: CGRect(x: 0, y: bottomBarDist+bottomBarHeight, width: frame.width, height: profileSectionHeaderViewHeight))
        subsHeader.sectionTitle.text = "Subscriptions"
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 6
        layout.itemSize = CGSize(width: subscriptionsHeight, height: subscriptionsHeight)
        subscriptions = UICollectionView(frame: CGRect(x: 0, y: bottomBarDist+bottomBarHeight+profileSectionHeaderViewHeight, width: frame.width, height: subscriptionsHeight), collectionViewLayout: layout)
        subscriptions.delegate = self
        subscriptions.backgroundColor = UIColor.podcastWhite
        subscriptions.showsHorizontalScrollIndicator = false
        subscriptions.showsVerticalScrollIndicator = false
        subscriptions.contentInset = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 6)
        subscriptions.register(SeriesCollectionViewCell.self, forCellWithReuseIdentifier: "SeriesCell")
        subscriptions.allowsSelection = false
        
        addSubview(bottomBar)
        addSubview(topBar)
        addSubview(subsHeader)
        addSubview(subscriptions)
        addSubview(profileArea)
    }
    
    override func layoutSubviews() {
        // Width for bottom bar buttons
        let bButtonWidth:CGFloat = frame.width/numBottomBarButtons
        followersButton.frame = CGRect(x: 0, y: 0, width: bButtonWidth, height: bottomBarHeight)
        followingButton.frame = CGRect(x: bButtonWidth, y: 0, width: bButtonWidth, height: bottomBarHeight)
        
        let verticalBar1 = UIView(frame: CGRect(x: bButtonWidth, y: vertBarPadding, width: 1, height: bottomBarHeight-2*vertBarPadding))
        verticalBar1.backgroundColor = .podcastGray
        bottomBar.addSubview(verticalBar1)
        
        let labelWidth: CGFloat = frame.width-2*padding
        let usernameY = proImgY+proImgWidth+padding+labelHeight+labelSpacing
        profileArea.frame = CGRect(x: 0, y: statusBarHeight, width: frame.width, height: bottomBarDist-statusBarHeight)
        profileImage.frame = CGRect(x: (frame.width-proImgWidth)/2, y: proImgY, width: proImgWidth, height: proImgWidth)
        profileImage.layer.cornerRadius = proImgWidth/2.0
        nameLabel.frame = CGRect(x: padding, y: proImgY+proImgWidth+padding, width: labelWidth, height: labelHeight)
        usernameLabel.frame = CGRect(x: padding, y: usernameY, width: labelWidth, height: labelHeight)
        followButton.frame = CGRect(x: (frame.width-followButtonWidth)/2, y: usernameY+labelHeight+padding, width: followButtonWidth, height: followButtonHeight)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func canSeeFollowButton() -> Bool {
        if (user as? CurrentUser) != nil {
            return false
        }
        return true
    }
    
    @objc func animateByYOffset(_ yOffset: CGFloat) {
        let usernameY = proImgY+proImgWidth+padding+labelHeight+labelSpacing
        let proImageHalfPoint = (proImgY+proImgWidth/2)
        if yOffset <= 0 {
            profileImage.alpha = 1
        } else if yOffset >= proImageHalfPoint {
            profileImage.alpha = 0
        } else {
            profileImage.alpha = abs((proImageHalfPoint-yOffset)/yOffset)
        }
        if yOffset <= proImgY+proImgWidth+padding {
            nameLabel.alpha = 1
            usernameLabel.alpha = 1
            followButton.alpha = canSeeFollowButton() ? 1 : 0
        } else if yOffset >= usernameY+labelHeight {
            nameLabel.alpha = 0
            usernameLabel.alpha = 0
            followButton.alpha = 0
        } else {
            // Too complicated
            let aNum = (usernameY+labelHeight-yOffset)
            let aDen = (usernameY+labelHeight-(proImgY+proImgWidth+padding))
            let a = abs(aNum/aDen)
            print(a)
            nameLabel.alpha = a
            usernameLabel.alpha = a
            followButton.alpha = canSeeFollowButton() ? a : 0
        }
    }
    
    private func makeBotBarButton(_ tag: Int) -> UIButton {
        let button = UIButton(frame: CGRect.zero)
        button.tag = tag
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.numberOfLines = 2
        button.addTarget(self, action: #selector(ProfileHeaderView.buttonBarPressed(sender:)), for: .touchUpInside)
        return button
    }
    
    private func formBotBarButtonTitle(_ text: String, _ num: Int) -> NSMutableAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 2.5
        paragraphStyle.alignment = .center
        
        let numText = "\(num)"
        let title = NSMutableAttributedString(string: "\(text)\n\(numText)")
        title.addAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 12), NSForegroundColorAttributeName: UIColor.podcastGrayLight], range: NSRange(location:0, length: text.characters.count))
        title.addAttributes([NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14),NSForegroundColorAttributeName: UIColor.podcastBlack], range: NSRange(location:text.characters.count+1, length: numText.characters.count))
        title.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, title.length))
        return title
    }
    
    @objc private func followPressed() {
        followButton.isSelected = !followButton.isSelected
        guard let delegate = delegate else { return }
        delegate.followButtonPressed(follow: followButton.isSelected)
    }
    
    @objc private func buttonBarPressed(sender: UIButton) {
        guard let delegate = delegate else { return }
        delegate.buttonBarPressed(buttonBarNum: sender.tag)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let delegate = delegate else { return }
        // Add button action to Series detail view here
        delegate.collectionViewCellDidSelectItemAtPath(path: indexPath)
    }

}
