//
//  UserDetailHeaderView.swift
//  Podcast
//
//  Created by Drew Dunne on 3/8/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import UIKit
import SnapKit

protocol UserDetailHeaderViewDelegate: class {
    func userDetailHeaderDidPressFollowButton(header: UserDetailHeaderView)
    func userDetailHeaderDidPressFollowers(header: UserDetailHeaderView)
    func userDetailHeaderDidPressFollowing(header: UserDetailHeaderView)
}

class UserDetailHeaderView: UIView {
    
    static let minHeight: CGFloat = 526
    static let infoAreaMinHeight: CGFloat = 246
    
    static let subscriptionsViewHeight: CGFloat = 140
    
    var contentContainerTop: Constraint?
    
    var containerView: UIView!
    var infoAreaView: UserDetailInfoView!
    var buttonBar: UserDetailHeaderToolbarView!
    var subscriptionsHeaderView: UserDetailSectionHeaderView!
    var subscriptionsView: UICollectionView!
    
    weak var delegate: UserDetailHeaderViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .paleGrey
        
        containerView = UIView()
        containerView.clipsToBounds = true
        containerView.backgroundColor = .clear
        addSubview(containerView)
        
        infoAreaView = UserDetailInfoView(frame: .zero)
        infoAreaView.followButton.addTarget(self, action: #selector(followPressed), for: .touchUpInside)
        containerView.addSubview(infoAreaView)
        
        buttonBar = UserDetailHeaderToolbarView(frame: .zero)
        buttonBar.followersButton.addTarget(self, action: #selector(buttonBarPressed(sender:)), for: .touchUpInside)
        buttonBar.followingButton.addTarget(self, action: #selector(buttonBarPressed(sender:)), for: .touchUpInside)
        containerView.addSubview(buttonBar)
        
        subscriptionsHeaderView = UserDetailSectionHeaderView(reuseIdentifier: nil)
        containerView.addSubview(subscriptionsHeaderView)
        
        subscriptionsView = UICollectionView(frame: .zero, collectionViewLayout: RecommendedSeriesCollectionViewFlowLayout(layoutType: .profile))
        subscriptionsView.backgroundColor = .paleGrey
        subscriptionsView.showsHorizontalScrollIndicator = false
        containerView.addSubview(subscriptionsView)
        
        // SnapKit setup
        containerView.snp.makeConstraints { make in
            contentContainerTop = make.top.equalToSuperview().constraint
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        infoAreaView.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(UserDetailHeaderView.infoAreaMinHeight)
            make.top.greaterThanOrEqualTo(containerView.snp.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(buttonBar.snp.top)
        }
        
        buttonBar.snp.makeConstraints { make in
            make.height.equalTo(UserDetailHeaderToolbarView.height)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(subscriptionsHeaderView.snp.top)
        }
        
        subscriptionsHeaderView.snp.makeConstraints { make in
            make.height.equalTo(UserDetailSectionHeaderView.height)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(subscriptionsView.snp.top)
        }
        
        subscriptionsView.snp.makeConstraints { make in
            make.height.equalTo(UserDetailHeaderView.subscriptionsViewHeight)
            make.leading.trailing.bottom.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
    }
    
    func configure(for user: User, isMe: Bool) {
        infoAreaView.configure(for: user, isMe: isMe)
        buttonBar.configure(for: user)
        subscriptionsHeaderView.configure(for: .subscriptions, and: user, isMe: isMe)
    }
    
    // Hides both the section header and collectionView
    func setSubscriptions(hidden: Bool) {
        subscriptionsHeaderView.isHidden = hidden
        subscriptionsView.isHidden = hidden
    }
    
    func remakeSubscriptionsViewContraints() {
        // Can shrink the subscriptions view for external when we
        // show the null state, but don't have time right now
    }
    
    @objc func followPressed() {
        delegate?.userDetailHeaderDidPressFollowButton(header: self)
    }
    
    @objc func buttonBarPressed(sender: UIButton) {
        switch sender.tag {
        case UserDetailHeaderToolbarView.followersButtonTag:
            delegate?.userDetailHeaderDidPressFollowers(header: self)
        case UserDetailHeaderToolbarView.followingButtonTag:
            delegate?.userDetailHeaderDidPressFollowing(header: self)
        default:
            break
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
