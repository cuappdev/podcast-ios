//
//  SettingsTableViewCell.swift
//  Podcast
//
//  Created by Drew Dunne on 3/8/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    
    static let height: CGFloat = 46
    let height: CGFloat = SettingsTableViewCell.height
    let labelSidePadding: CGFloat = 17
    let labelTopPadding: CGFloat = 14.5
    
    var titleLabel: UILabel!
        
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        titleLabel = UILabel(frame: CGRect.zero)
        titleLabel.font = ._14RegularFont()
        titleLabel.textColor = .offBlack
        titleLabel.textAlignment = .left
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints({ make in
            make.right.lessThanOrEqualToSuperview().inset(labelSidePadding)
            make.left.equalToSuperview().inset(labelSidePadding)
            make.top.equalToSuperview().inset(labelTopPadding)
            make.bottom.equalToSuperview().inset(labelTopPadding)
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitle(_ title: String) {
        titleLabel.text = title
        titleLabel.sizeToFit()
    }
    
    func displayError(error: String) {
        // Override for subclassed views
    }
    
    func clearError() {
        // Override for subclassed views
    }

}
