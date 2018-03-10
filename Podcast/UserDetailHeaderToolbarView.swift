//
//  UserDetailHeaderToolbarView.swift
//  Podcast
//
//  Created by Drew Dunne on 3/8/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import UIKit

class UserDetailHeaderToolbarView: UIView {
    
    static let height: CGFloat = 64
    static let followersButtonTag = 9000
    static let followingButtonTag = 9001
    
    let verticalDividerPadding: CGFloat = 18
    let verticalDividerWidth: CGFloat = 1

    var followersButton: UIButton!
    var followingButton: UIButton!
    var verticalDivider: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .offWhite
        
        verticalDivider = UIView()
        verticalDivider.backgroundColor = .paleGrey
        addSubview(verticalDivider)
        
        followersButton = makeBottomBarButton(UserDetailHeaderToolbarView.followersButtonTag)
        addSubview(followersButton)
        
        followingButton = makeBottomBarButton(UserDetailHeaderToolbarView.followingButtonTag)
        addSubview(followingButton)
        
        followersButton.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview()
            make.trailing.equalTo(followingButton.snp.leading)
            make.width.equalTo(followingButton.snp.width)
        }
        
        followingButton.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
            make.leading.equalTo(followersButton.snp.trailing)
        }
        
        verticalDivider.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(verticalDividerPadding)
            make.width.equalTo(verticalDividerWidth)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(for user: User) {
        followersButton.setAttributedTitle(formatBottomBarButtonTitle("Followers", user.numberOfFollowers), for: .normal)
        followingButton.setAttributedTitle(formatBottomBarButtonTitle("Following", user.numberOfFollowing), for: .normal)
    }
    
    func makeBottomBarButton(_ tag: Int) -> UIButton {
        let button = UIButton()
        button.tag = tag
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.numberOfLines = 2
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

}
