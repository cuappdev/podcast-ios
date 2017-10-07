//
//  RecommendButton.swift
//  Podcast
//
//  Created by Mark Bryan on 4/27/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class RecommendButton: UIButton {
    let buttonTitlePadding: CGFloat = 7
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setImage(#imageLiteral(resourceName: "heart_icon"), for: .normal)
        setImage(#imageLiteral(resourceName: "heart_icon_selected"), for: .selected)
        contentHorizontalAlignment = .left
        titleEdgeInsets = UIEdgeInsets(top: 0, left: buttonTitlePadding, bottom: 0, right: 0)
        setTitleColor(.charcoalGrey, for: .normal)
        setTitleColor(.rosyPink, for: .selected)
        setTitle("0", for: .normal)
        titleLabel?.font = ._12RegularFont()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setNumberRecommended(numberRecommended: Int) {
        setTitle(String(numberRecommended), for: .normal)
    }

}
