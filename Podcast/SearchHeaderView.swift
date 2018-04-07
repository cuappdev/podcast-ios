//
//  SearchHeaderView.swift
//  Podcast
//
//  Created by Mindy Lou on 11/1/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

protocol SearchHeaderDelegate: class {
    func searchHeaderDidPress(searchHeader: SearchHeaderView)
    func searchHeaderDidPressDismiss(searchHeader: SearchHeaderView)
}

enum searchHeaderViewType {
    case itunes
    case facebook
    case facebookRelogin // when a user is a facebook user but doesn't have auth token from facebook 

    var title: NSMutableAttributedString {
        switch self {
        case .itunes:
            let attributedString = NSMutableAttributedString(string: "Can’t find a series you’re looking for? You can now search iTunes directly.")
            attributedString.addAttribute(.foregroundColor, value: UIColor.sea, range: NSRange(location: 52, length: 13))
            attributedString.addAttribute(.foregroundColor, value: UIColor.slateGrey, range: NSRange(location: 66, length: 9))
            return attributedString
        case .facebook:
            let attributedString = NSMutableAttributedString(string: "You haven't connected to Facebook yet. Connect to Facebook to find friends to follow")
            attributedString.addAttribute(.foregroundColor, value: UIColor.sea, range: NSRange(location: 39, length: 20))
            return attributedString
        case .facebookRelogin:
            let attributedString = NSMutableAttributedString(string: "Login with Facebook to find friends to follow")
            attributedString.addAttribute(.foregroundColor, value: UIColor.sea, range: NSRange(location: 0, length: 19))
            return attributedString
        }
    }
}

class SearchHeaderView: UIView {

    let headerHeight: CGFloat = 79.5
    let topPadding: CGFloat = 12.5
    let bottomPadding: CGFloat = 25
    let leftPadding: CGFloat = 17.5
    let rightPadding: CGFloat = 36.5
    let dividerHeight: CGFloat = 16
    let buttonWidthHeight: CGFloat = 15
    let buttonTopRightOffset: CGFloat = 18
    
    var descriptionLabel: UILabel!
    var dismissBannerButton: UIButton!
    var dividerLabel: UILabel!
    
    weak var delegate: SearchHeaderDelegate?

    init(frame: CGRect, type: searchHeaderViewType) {
        super.init(frame: frame)
        backgroundColor = .offWhite
        isUserInteractionEnabled = true
        
        descriptionLabel = UILabel(frame: .zero)
        descriptionLabel.font = ._14RegularFont()
        descriptionLabel.textAlignment = .left
        descriptionLabel.numberOfLines = 2
        descriptionLabel.textColor = .slateGrey
        descriptionLabel.attributedText = type.title
        descriptionLabel.isUserInteractionEnabled = true
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapSearch)))
        addSubview(descriptionLabel!)
        
        descriptionLabel?.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(leftPadding)
            make.trailing.equalToSuperview().inset(rightPadding)
            make.top.equalToSuperview().offset(topPadding)
            make.bottom.equalToSuperview().inset(bottomPadding)
        }
        
        dismissBannerButton = UIButton(frame: .zero)
        dismissBannerButton.setImage(#imageLiteral(resourceName: "dismiss_banner"), for: .normal)
        dismissBannerButton.addTarget(self, action: #selector(dismissHeader), for: .touchUpInside)
        addSubview(dismissBannerButton!)
        
        dismissBannerButton.snp.makeConstraints { make in
            make.width.height.equalTo(buttonWidthHeight)
            make.top.equalToSuperview().offset(buttonTopRightOffset)
            make.trailing.equalToSuperview().inset(buttonTopRightOffset)
        }
        
        dividerLabel = UILabel(frame: .zero)
        dividerLabel.backgroundColor = .paleGrey
        addSubview(dividerLabel!)
        
        dividerLabel.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(dividerHeight)
            make.bottom.equalToSuperview()
        }
        
    }
    
    @objc func didTapSearch() {
        delegate?.searchHeaderDidPress(searchHeader: self)
    }
    
    @objc func dismissHeader() {
        delegate?.searchHeaderDidPressDismiss(searchHeader: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
