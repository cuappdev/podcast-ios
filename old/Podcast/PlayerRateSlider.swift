//
//  PlayerRateSlider.swift
//  Podcast
//
//  Created by Natasha Armbrust on 3/27/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import UIKit
import StepSlider

class PlayerRateSlider: StepSlider {

    var values = PlayerRate.values()

    init() {
        super.init(frame: .zero)
        trackHeight = 3
        trackCircleRadius = 4
        sliderCircleRadius = 10
        isDotsInteractionEnabled = true
        trackColor = .paleGrey
        sliderCircleColor = .sea
        labelColor = .charcoalGrey
        labelOrientation = .up
        maxCount = UInt(values.count)
        labels = values.map({ v in String(v.rawValue) })
        labelFont = ._12RegularFont()
        labelOffset = 2
        tintColor = .sea
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
