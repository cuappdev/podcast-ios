//
//  ProfileSectionHeaderView.swift
//  Podcast
//
//  Created by Drew Dunne on 11/16/16.
//  Copyright © 2016 Cornell App Development. All rights reserved.
//

import UIKit

enum UserDetailSectionHeaderType: String {
    case subscriptions = "Subscriptions"
    case recasts = "Recasts"
}

protocol UserDetailSectionHeaderViewDelegate: class {
    func userDetailSectionViewHeaderDidPressSeeAll(header: UserDetailSectionHeaderView)
}

class UserDetailSectionHeaderView: UITableViewHeaderFooterView {
    
    static let height: CGFloat = 60
    let headerHeight = UserDetailSectionHeaderView.height
    let edgePadding: CGFloat = 18
    var mainLabel: UILabel!
    var browseButton: UIButton!
    weak var delegate: UserDetailSectionHeaderViewDelegate?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
                
        mainLabel = UILabel()
        mainLabel.font = ._14SemiboldFont()
        mainLabel.textColor = .charcoalGrey
        addSubview(mainLabel)
        mainLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(edgePadding)
            make.height.equalTo(headerHeight)
            make.top.equalToSuperview()
        }
        
        browseButton = UIButton()
        browseButton.titleLabel?.font = ._12RegularFont()
        browseButton.setTitleColor(.slateGrey, for: .normal)
        browseButton.addTarget(self, action: #selector(pressBrowse), for: .touchUpInside)
        addSubview(browseButton)
        browseButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(edgePadding)
            make.height.equalTo(headerHeight)
            make.top.equalToSuperview()
        }
    }
    
    func configure(for sectionType: UserDetailSectionHeaderType, and user: User, isMe: Bool) {
        switch sectionType {
        case .subscriptions:
            mainLabel.text = isMe ? "Your \(sectionType.rawValue)" : sectionType.rawValue
            browseButton.setTitle("See All", for: .normal)
        case .recasts:
            mainLabel.text = isMe ? "Your \(sectionType.rawValue)" : "\(user.firstName)'s \(sectionType.rawValue)"
            browseButton.isEnabled = false
            browseButton.isHidden = true
        }
        
    }
    
    @objc func pressBrowse() {
        delegate?.userDetailSectionViewHeaderDidPressSeeAll(header: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
