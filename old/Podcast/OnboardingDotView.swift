//
//  OnboardingDotView.swift
//  Podcast
//
//  Created by Natasha Armbrust on 3/2/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import UIKit

/// small dots on onboarding view 
class OnboardingDotView: UIView {

    static let size: CGFloat = 4.8
    let unselectedColor: UIColor = UIColor.offWhite.withAlphaComponent(0.15)
    let selectedColor: UIColor = .offWhite

    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: OnboardingDotView.size, height: OnboardingDotView.size))
        backgroundColor = unselectedColor
        layer.cornerRadius = OnboardingDotView.size / 2
    }

    func isSelected(_ isSelected: Bool) {
        backgroundColor = isSelected ? selectedColor : unselectedColor
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
