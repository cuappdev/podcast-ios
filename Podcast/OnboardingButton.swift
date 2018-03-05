//
//  OnboardingButton.swift
//  Podcast
//
//  Created by Natasha Armbrust on 3/2/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import UIKit

/// semi-transparent buttons used in onboarding view

class OnboardingButton: UIButton {

    convenience init(title: String) {
        self.init(frame: .zero, title: title)
    }

    init(frame: CGRect, title: String) {
        super.init(frame: frame)
        backgroundColor = UIColor.offWhite.withAlphaComponent(0.15)
        layer.cornerRadius = 2
        layer.borderWidth = 1.5
        layer.borderColor = UIColor.offWhite.cgColor
        setTitle(title, for: .normal)
        titleLabel?.font = ._14SemiboldFont()
        setTitleColor(.offWhite, for: .normal)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


