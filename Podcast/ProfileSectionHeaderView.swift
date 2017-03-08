//
//  ProfileSectionHeaderView.swift
//  Podcast
//
//  Created by Drew Dunne on 11/16/16.
//  Copyright © 2016 Cornell App Development. All rights reserved.
//

import UIKit

class ProfileSectionHeaderView: UIView {
    
    let edgePadding: CGFloat = 20
    let labelHeight: CGFloat = 18
    var mainLabel: UILabel!
    var detailButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .podcastWhiteDark
        mainLabel = UILabel(frame: CGRect(x: edgePadding, y: edgePadding, width: frame.width * 3 / 4, height: labelHeight))
        mainLabel.text = "Doggos You Might Enjoy"
        mainLabel.font = .systemFont(ofSize: 14, weight: UIFontWeightSemibold)
        mainLabel.textColor = .podcastGrayDark
        addSubview(mainLabel)
    }
    
    func setSectionText(sectionName: String) {
        mainLabel.text = sectionName
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        mainLabel.frame = CGRect(x: edgePadding, y: edgePadding, width: frame.width * 3 / 4, height: labelHeight)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
