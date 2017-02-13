//
//  TagButton.swift
//  Podcast
//
//  Created by Drew Dunne on 2/19/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class TagButton: UIButton {
    
    static func tagButton() -> TagButton {
        let button = TagButton()
        button.setTitleColor(.tagButtonText, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12, weight:UIFontWeightRegular)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor.colorFromCode(0xF4F4F7)
        return button
    }

    override var isHighlighted: Bool {
        didSet {
            super.isHighlighted = isHighlighted
            UIView.animate(withDuration: 0.15, animations: {
                if self.isHighlighted {
                    self.backgroundColor = .podcastGray
                } else {
                    self.backgroundColor = UIColor.colorFromCode(0xF4F4F7)
                }
                })
        }
    }

}
