//
//  InternalProfileTableViewCell.swift
//  Podcast
//
//  Created by Drew Dunne on 3/7/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class InternalProfileTableViewCell: UITableViewCell {
    
    static let height: CGFloat = 46
    let height: CGFloat = InternalProfileTableViewCell.height
    let labelHeight: CGFloat = 17
    let labelPadding: CGFloat = 17
    
    var titleLabel: UILabel!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none 
        accessoryType = .disclosureIndicator
        titleLabel = UILabel(frame: CGRect(x: labelPadding, y: (height - labelHeight) / 2, width: frame.width - 2 * labelPadding, height: labelHeight))
        titleLabel.font = ._14RegularFont()
        titleLabel.textColor = .offBlack
        titleLabel.textAlignment = .left
        addSubview(titleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
}
