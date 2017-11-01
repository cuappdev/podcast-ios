//
//  SearchITunesHeaderView.swift
//  Podcast
//
//  Created by Mindy Lou on 11/1/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

protocol SearchITunesHeaderDelegate: class {
    func searchITunesHeaderDidPressSearchITunes(searchITunesHeader: SearchITunesHeaderView)
    func searchITunesHeaderDidPressDismiss(searchITunesHeader: SearchITunesHeaderView)
}

class SearchITunesHeaderView: UIView {

    let headerHeight: CGFloat = 79.5
    let topPadding: CGFloat = 12.5
    let bottomPadding: CGFloat = 25
    let leftPadding: CGFloat = 17.5
    let rightPadding: CGFloat = 36.5
    let dividerHeight: CGFloat = 12
    let buttonWidthHeight: CGFloat = 7
    let buttonTopRightOffset: CGFloat = 18
    
    var descriptionLabel: UILabel!
    var dismissBannerButton: UIButton!
    var dividerLabel: UILabel!
    
    weak var delegate: SearchITunesHeaderDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .offWhite
        isUserInteractionEnabled = true
        
        descriptionLabel = UILabel(frame: .zero)
        descriptionLabel.font = ._14RegularFont()
        descriptionLabel.textAlignment = .left
        descriptionLabel.numberOfLines = 2
        descriptionLabel.textColor = .slateGrey
        let attributedString = NSMutableAttributedString(string: "Can’t find a series you’re looking for? You can now search iTunes directly.")
        attributedString.addAttribute(.foregroundColor, value: UIColor.sea, range: NSRange(location: 52, length: 13))
        attributedString.addAttribute(.foregroundColor, value: UIColor.slateGrey, range: NSRange(location: 66, length: 9))
        descriptionLabel.attributedText = attributedString
        descriptionLabel.isUserInteractionEnabled = true
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(searchITunes)))
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
    
    @objc func searchITunes() {
        delegate?.searchITunesHeaderDidPressSearchITunes(searchITunesHeader: self)
    }
    
    @objc func dismissHeader() {
        delegate?.searchITunesHeaderDidPressDismiss(searchITunesHeader: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
