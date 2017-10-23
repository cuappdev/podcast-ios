//
//  PastSearchTableViewCell.swift
//  Podcast
//
//  Created by Kevin Greer on 4/13/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit
import SnapKit

class PastSearchTableViewCell: UITableViewCell {
    
    var label: UILabel!
    var iconImageView: UIImageView!
    var separator: UIView!
    
    let separatorHeight: CGFloat = 1
    let xEdgePadding: CGFloat = 18
    let yEdgePadding: CGFloat = 18
    let iconSize: CGFloat = 11
    static let height: CGFloat = 53
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .offWhite
        
        label = UILabel()
        label.font = ._14RegularFont()
        label.textColor = .slateGrey
        contentView.addSubview(label)
        
        iconImageView = UIImageView()
        iconImageView.image = #imageLiteral(resourceName: "iGo")
        contentView.addSubview(iconImageView)
        
        separator = UIView()
        separator.backgroundColor = .silver
        addSubview(separator)
        
        iconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(xEdgePadding)
            make.size.equalTo(iconSize)
            make.centerY.equalToSuperview()
        }
        
        label.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(xEdgePadding)
            make.centerY.equalToSuperview()
            make.height.equalToSuperview()
            make.trailing.equalToSuperview().inset(xEdgePadding)
        }
        
        separator.snp.makeConstraints { make in
            make.height.equalTo(separatorHeight)
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
            make.leading.equalTo(label.snp.leading)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

