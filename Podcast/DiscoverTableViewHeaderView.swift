//
//  DiscoverTableViewHeaderView.swift
//  Podcast
//
//  Created by Kevin Greer on 2/19/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

protocol DiscoverTableViewHeaderDelegate {
    func didTapDetailButton(for section: Int)
}

class DiscoverTableViewHeader: UIView {
    
    let EdgePadding: CGFloat = 8
    var mainLabel: UILabel!
    var detailButton: UIButton!
    var section: Int = -1
    var delegate: DiscoverTableViewHeaderDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        mainLabel = UILabel(frame: CGRect(x:EdgePadding, y:0, width:frame.width*3/4, height:frame.height))
        mainLabel.text = "Doggos You Might Enjoy"
        mainLabel.font = .systemFont(ofSize: 12, weight: UIFontWeightSemibold)
        mainLabel.textColor = .podcastGrayDark
        detailButton = UIButton(frame: CGRect(x:frame.width*3/4, y:0, width:frame.width/4-8, height:frame.height))
        detailButton.setTitle("See All >", for: .normal)
        detailButton.addTarget(self, action: #selector(DiscoverTableViewHeader.didTapDetailButton), for: .touchUpInside)
        detailButton.setTitleColor(.podcastGreenBlue, for: .normal)
        detailButton.titleLabel?.textAlignment = .right
        detailButton.titleLabel?.font = .systemFont(ofSize: 12, weight: UIFontWeightRegular)
        addSubview(mainLabel)
        addSubview(detailButton)
    }
    
    func didTapDetailButton() {
        delegate?.didTapDetailButton(for: section)
    }
    
    func configure(sectionName: String, detailButtonShown: Bool, section: Int) {
        self.section = section
        mainLabel.text = "\(sectionName) You Might Enjoy"
        if !detailButtonShown {
            detailButton.removeFromSuperview()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        mainLabel.frame = CGRect(x:EdgePadding, y:0, width:frame.width*3/4, height:frame.height)
        detailButton.frame = CGRect(x:frame.width*3/4, y:0, width:frame.width/4-8, height:frame.height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
