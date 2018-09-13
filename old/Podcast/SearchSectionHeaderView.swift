//
//  SearchSectionHeaderTableViewCell.swift
//  Podcast
//
//  Created by Jack Thompson on 4/6/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import UIKit
import SnapKit

protocol SearchTableViewHeaderDelegate: class {
    func searchTableViewHeaderDidPressViewAllButton(view: SearchSectionHeaderView)
}

class SearchSectionHeaderView: UIView {
    
    let edgePadding: CGFloat = 18
    var mainLabel: UILabel!
    var viewAllButton: UIButton!
    var type: SearchType!
    weak var delegate: SearchTableViewHeaderDelegate?
    
    var mainLabelHeight: CGFloat = 21
    var viewAllButtonHeight: CGFloat = 18
    var bottomInset: CGFloat = 12.5
    
    init(frame: CGRect, type: SearchType) {
        super.init(frame: frame)
        
        mainLabel = UILabel(frame: .zero)
        mainLabel.font = ._14SemiboldFont()
        mainLabel.textColor = .charcoalGrey
        
        viewAllButton = UIButton(frame: .zero)
        viewAllButton.addTarget(self, action: #selector(didPressViewAllButton), for: .touchUpInside)
        let attributedTitle = NSAttributedString(string: "See all", attributes: [NSAttributedStringKey.foregroundColor: UIColor.slateGrey, NSAttributedStringKey.font: UIFont._12RegularFont()])
        viewAllButton.setAttributedTitle(attributedTitle, for: .normal)
        
        addSubview(mainLabel)
        addSubview(viewAllButton)
        
        mainLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(edgePadding)
            make.height.equalTo(mainLabelHeight)
            make.bottom.equalToSuperview().inset(bottomInset)
        }
        
        viewAllButton.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().inset(edgePadding)
            make.height.equalTo(viewAllButtonHeight)
            make.bottom.equalTo(mainLabel)
        }
    }
    
    func configure(type: SearchType) {
        self.type = type
        mainLabel.text = type.toString()
    }
    
    func hideViewAllButton() {
        viewAllButton.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didPressViewAllButton() {
        delegate?.searchTableViewHeaderDidPressViewAllButton(view: self)
    }
}
