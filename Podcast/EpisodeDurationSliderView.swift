//
//  EpisodeDurationSliderView.swift
//  Podcast
//
//  Created by Natasha Armbrust on 11/19/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import Foundation

class EpisodeDurationSliderView: UISlider {

    init() {
        super.init(frame: .zero)
        setThumbImage(UIImage(), for: .normal)
        setMaximumTrackImage(nil, for: .normal)
        setMinimumTrackImage(nil, for: .normal)
        minimumTrackTintColor = .sea
        maximumTrackTintColor = .paleGrey
        isUserInteractionEnabled = false
        isHidden = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // value between 0.0 to 1.0 indicating episodes listening progress
    func setSliderProgress(isPlaying: Bool, progress: Double) {
        setValue(Float(progress), animated: true)
        if progress > 0 && !isPlaying { //don't show slider when playing
            isHidden = false
        } else {
            isHidden = true
        }
    }
}
