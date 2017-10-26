//
//  EmptyStateView.swift
//  Podcast
//
//  Created by Natasha Armbrust on 10/22/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit
import SnapKit

enum EmptyStateType {
    case pastSearch
    case bookmarks
    case search
    
    var title: String {
        switch self {
        case .pastSearch:
            return "Search Podcasts"
        case .bookmarks:
            return "No Bookmarks"
        case .search:
            return "Sorry!"
        }
    }
    
    var explanation: String {
        switch self {
        case .pastSearch:
            return "Find your favorite podcast episodes & series, friends, and tags."
        case .bookmarks:
            return "You can save podcast episodes for later here. Start looking now!"
        case .search:
            return "No results found."
        }
    }
    
    var image: UIImage? {
        switch self {
        case .pastSearch:
            return #imageLiteral(resourceName: "searchIcon")
        case .bookmarks:
            return #imageLiteral(resourceName: "bookmark_empty_state")
        default:
            return nil
        }
    }
    
    var actionItemButtonTitle: String? {
        switch self {
        case .bookmarks:
            return "Discover Episodes"
        default:
            return nil
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .bookmarks:
            return .paleGrey
        default:
            return .offWhite
        }
    }
}

protocol EmptyStateViewDelegate: class {
    func didPressActionItemButton()
}

class EmptyStateView: UIView {
    
    let iconImageViewY: CGFloat = 175
    let iconImageViewWidth: CGFloat = 50
    let iconImageViewHeight: CGFloat = 48
    let explanationLabelWidth: CGFloat = 0.7
    let padding: CGFloat = 18
    
    var iconImageView: UIImageView?
    var titleLabel: UILabel!
    var explanationLabel: UILabel!
    var actionItemButton: UIButton!
    
    weak var delegate: EmptyStateViewDelegate?
    
    init(type: EmptyStateType) {
        super.init(frame: .zero)
        backgroundColor = type.backgroundColor
        
        if let image = type.image {
            iconImageView = UIImageView(image: image)
            addSubview(iconImageView!)
            iconImageView!.snp.makeConstraints { make in
                make.top.equalToSuperview().inset(iconImageViewY)
                make.centerX.equalToSuperview()
                make.width.lessThanOrEqualTo(iconImageViewWidth)
                make.height.lessThanOrEqualTo(iconImageViewHeight)
            }
        }
        
        titleLabel = UILabel()
        titleLabel.text = type.title
        titleLabel.textColor = .slateGrey
        titleLabel.font = ._16SemiboldFont()
        addSubview(titleLabel)
        
        explanationLabel = UILabel()
        explanationLabel.numberOfLines = 3
        explanationLabel.textAlignment = .center
        explanationLabel.text = type.explanation
        explanationLabel.textColor = .slateGrey
        explanationLabel.font = ._14RegularFont()
        addSubview(explanationLabel)
        
        actionItemButton = UIButton()
        actionItemButton.setTitleColor(.sea, for: .normal)
        actionItemButton.backgroundColor = .clear
        actionItemButton.addTarget(self, action: #selector(didPressActionItemButton), for: .touchUpInside)
        actionItemButton.isHidden = true
        if let actionItemButtonTitle = type.actionItemButtonTitle {
            actionItemButton.setTitle(actionItemButtonTitle, for: .normal)
            actionItemButton.isHidden = false
        }
        addSubview(actionItemButton)
        
        titleLabel.snp.makeConstraints { make in
            if let imageView = iconImageView {
                make.top.equalTo(imageView.snp.bottom).offset(padding)
            } else {
                make.top.equalToSuperview().inset(iconImageViewY)
            }
            make.centerX.equalToSuperview()
        }
        
        explanationLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(padding)
            make.width.equalTo(snp.width).multipliedBy(explanationLabelWidth)
        }
        
        actionItemButton.snp.makeConstraints { make in
            make.top.equalTo(explanationLabel.snp.bottom).offset(padding)
            make.centerX.equalToSuperview()
        }
    }

    @objc func didPressActionItemButton() {
        delegate?.didPressActionItemButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
