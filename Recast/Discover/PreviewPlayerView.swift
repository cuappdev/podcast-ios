//
//  PreviewPlayerView.swift
//  Recast
//
//  Created by Jack Thompson on 9/19/18.
//  Copyright © 2018 Cornell AppDev. All rights reserved.
//

import UIKit
import SnapKit

class PreviewPlayerView: UIView {

    // MARK: - Variables
    var upNextView: UIView!
    var upNextLabel: UILabel!
    var nextButton: UIButton!
    var timeSlider: UISlider!
    var timeView: UIView!
    var timeLabel: UILabel!

    static let upNextViewHeight: CGFloat = 40

    override init(frame: CGRect) {
        super.init(frame: frame)

        upNextView = UIView()
        upNextView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        addSubview(upNextView)

        upNextLabel = UILabel()
        upNextLabel.font = .boldSystemFont(ofSize: 14.0)
        upNextLabel.textColor = .white
        upNextView.addSubview(upNextLabel)

        nextButton = UIButton()
        nextButton.setImage(#imageLiteral(resourceName: "next"), for: .normal)
        upNextView.addSubview(nextButton)

        timeView = UIView()
        timeView.backgroundColor = .black
        addSubview(timeView)

        timeLabel = UILabel()
        timeLabel.font = .systemFont(ofSize: 12.0)
        timeLabel.textColor = .white
        timeView.addSubview(timeLabel)

        timeSlider = UISlider()
        timeSlider.setThumbImage(#imageLiteral(resourceName: "oval"), for: .normal)
        addSubview(timeSlider)

        // MARK: - Test Data
        upNextLabel.text = "Up Next: Developer Tea"
        timeSlider.value = 0.5
        timeLabel.text = "0:15"

        makeConstraints()
    }

    func makeConstraints() {
        // MARK: - Constants
        let topPadding: CGFloat = 5
        let sideMargin: CGFloat = 12

        upNextView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(PreviewPlayerView.upNextViewHeight)
        }

        upNextLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(sideMargin)
        }

        nextButton.snp.makeConstraints { make in
            make.centerY.height.equalTo(upNextLabel)
            make.right.equalToSuperview().inset(sideMargin)
        }

        timeView.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            make.top.equalTo(upNextView.snp.bottom)
        }

        timeLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.top.equalToSuperview().offset(topPadding)
            make.bottom.equalToSuperview().inset(topPadding)
        }

        timeSlider.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.centerY.equalTo(upNextView.snp.bottom).inset(topPadding)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
