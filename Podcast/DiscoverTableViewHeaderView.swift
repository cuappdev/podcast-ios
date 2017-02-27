//
//  DiscoverTableViewHeaderView.swift
//  Podcast
//
//  Created by Kevin Greer on 2/19/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class DiscoverTableViewHeader: UIView {
    
    let EdgePadding: CGFloat = 20
    var mainLabel: UILabel!
    var detailButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        mainLabel = UILabel(frame: CGRect(x:EdgePadding, y:0, width:frame.width*3/4, height:frame.height))
        mainLabel.text = "Doggos You Might Enjoy"
        mainLabel.font = .systemFont(ofSize: 14, weight: UIFontWeightSemibold)
        mainLabel.textColor = .podcastGrayDark
        addSubview(mainLabel)
    }
    
    func configure(sectionName: String) {
        mainLabel.text = "Trending \(sectionName)"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        mainLabel.frame = CGRect(x:EdgePadding, y:0, width:frame.width*3/4, height:frame.height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
