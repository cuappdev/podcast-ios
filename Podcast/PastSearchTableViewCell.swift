//
//  PastSearchTableViewCell.swift
//  Podcast
//
//  Created by Kevin Greer on 4/13/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit
class PastSearchTableViewCell: UITableViewCell {
    
    var label: UILabel!
    var iconImageView: UIImageView!
    
    let XEdgePadding: CGFloat = 18
    let YEdgePadding: CGFloat = 18
    let iconHeight: CGFloat = 15
    let iconWidth: CGFloat = 15
    static let height: CGFloat = 53
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: UIFontWeightRegular)
        contentView.addSubview(label)
        
        iconImageView = UIImageView()
        iconImageView.image = #imageLiteral(resourceName: "go")
        contentView.addSubview(iconImageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = CGRect(x: XEdgePadding, y: 0, width: frame.width - XEdgePadding, height: PastSearchTableViewCell.height)
        iconImageView.frame = CGRect(x: frame.width - iconWidth - XEdgePadding, y: YEdgePadding, width: iconWidth, height: iconHeight)
    }
    
    func configureNoPastSearches() {
        label.text = "No past searches"
        label.textAlignment = .center
        label.textColor = .podcastGray
        iconImageView.removeFromSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

