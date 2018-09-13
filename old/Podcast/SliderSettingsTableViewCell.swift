//
//  SliderSettingsTableViewCell.swift
//  Podcast
//
//  Created by Natasha Armbrust on 3/27/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import UIKit

class SliderSettingsTableViewCell: SettingsTableViewCell {

    override class var height: CGFloat {
        get {
            return 65
        }
    }
    var slider: PlayerRateSlider!
    let padding: CGFloat = 20

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        slider = PlayerRateSlider()
        addSubview(slider)
        slider.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(titleLabel.snp.trailing).offset(padding)
            make.trailing.equalToSuperview().inset(padding)
        }

        let currentIndex = slider.values.index(of: UserPreferences.defaultPlayerRate) ?? 1
        slider.setIndex(UInt(currentIndex), animated: false)
    }

    func getSliderValue() -> PlayerRate {
        return slider.values[Int(slider.index)]
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
