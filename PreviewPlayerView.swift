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
    private var upNextLabel: UILabel!
    private var nextButton: UIButton!
    private var timeSlider: UISlider!
    private var timeView: UIView!
    private var timeLabel: UILabel!

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

        setUpConstraints()
    }

    func setUpConstraints() {
        // MARK: - Constants
        let topPadding: CGFloat = 10
        let sideMargin: CGFloat = 12
        let upNextViewHeight: CGFloat = 40

        upNextView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(upNextViewHeight)
        }

        upNextLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(sideMargin)
        }

        nextButton.snp.makeConstraints { make in
            make.centerY.height.equalTo(upNextLabel)
            make.trailing.equalToSuperview().inset(sideMargin)
        }

        timeView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.top.equalTo(upNextView.snp.bottom)
        }

        timeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(topPadding)
            make.bottom.equalToSuperview()
        }

        timeSlider.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.centerY.equalTo(upNextView.snp.bottom)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
