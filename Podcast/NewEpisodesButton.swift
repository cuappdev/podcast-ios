//
//  NewEpisodesButton.swift
//  Podcast
//
//  Created by Mindy Lou on 5/8/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import UIKit

class NewEpisodesButton: Button {

    static let buttonWidth: CGFloat = 146
    static let buttonHeight: CGFloat = 34

    let buttonTitlePadding: CGFloat = 7.5
    let labelTopInset: CGFloat = 7.5
    let labelBottomInset: CGFloat = 8.5
    let labelLeadingInset: CGFloat = 35
    let labelTrailingInset: CGFloat = 24
    let imageTopBottomInset: CGFloat = 11
    let imageLeadingInset: CGFloat = 25.5

    override init() {
        super.init()
        backgroundColor = .white
        setImage(#imageLiteral(resourceName: "down_arrow"), for: .normal)
        setTitle("New Episodes", for: .normal)
        setTitleColor(.sea, for: .normal)
        titleLabel?.font = ._12RegularFont()
        contentHorizontalAlignment = .left
        imageEdgeInsets = UIEdgeInsets(top: imageTopBottomInset, left: imageLeadingInset, bottom: imageTopBottomInset, right: 0)
        titleEdgeInsets = UIEdgeInsets(top: labelTopInset, left: labelLeadingInset, bottom: labelBottomInset, right: 0)
        addDropShadow(xOffset: 0, yOffset: 3, opacity: 0.05, radius: 6)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
