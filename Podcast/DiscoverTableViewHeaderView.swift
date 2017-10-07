//
//  DiscoverTableViewHeaderView.swift
//  Podcast
//
//  Created by Kevin Greer on 2/19/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class DiscoverTableViewHeader: UIView {
    
    let edgePadding: CGFloat = 20
    var mainLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        mainLabel = UILabel(frame: CGRect(x: edgePadding, y: 0, width: frame.width*3/4, height: frame.height))
        mainLabel.text = "Doggos You Might Enjoy"
        mainLabel.font = ._14SemiboldFont()
        mainLabel.textColor = .charcoalGrey
        addSubview(mainLabel)
    }
    
    func configure(sectionName: String) {
        mainLabel.text = "Trending \(sectionName)"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        mainLabel.frame = CGRect(x: edgePadding, y:0, width:frame.width*3/4, height:frame.height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
