//
//  CustomNavigationBar.swift
//  Recast
//
//  Created by Jack Thompson on 11/14/18.
//  Copyright © 2018 Cornell AppDev. All rights reserved.
//

import UIKit

class CustomNavigationBar: UIView {

    // MARK: - Variables
    private var titleLabel: UILabel!
    private var subtitleLabel: UILabel!

    private var backgroundView: UIView!
    private var blurEffectView: UIVisualEffectView!
    private var backgroundImage: UIImageView!
    private var blurEffect = UIBlurEffect(style: .dark)

    /// If true, navigation bar is slightly transparent with blur effect for contents below.
    /// Otherwise bar is a solid color.
    var isTranslucent: Bool = true {
        didSet {
            backgroundView.alpha = isTranslucent ? 0.6 : 1.0
            blurEffectView.effect = isTranslucent ? blurEffect : nil
        }
    }

    /// Color of the navigation bar.
    var barColor: UIColor = .black {
        didSet {
            backgroundView.backgroundColor = barColor
        }
    }

    /// Optional image for the background of the navigation bar.
    var barImage: UIImage? {
        didSet {
            backgroundImage.image = barImage
        }
    }

    /// Title of the navigation bar.
    /// If not set, takes the value of `navigationItem.title` for the containing view controller.
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }

    /// Optional subtitle of the navigation bar.
    /// If set, adjust bar in height to fit.
    var subtitle: String? {
        didSet {
            subtitleLabel.text = subtitle

            subtitleLabel.snp.remakeConstraints { make in
                make.bottom.equalToSuperview().inset(bottomPadding)
                make.leading.trailing.equalToSuperview().inset(edgePadding)
                make.height.equalTo(titleLabel).multipliedBy(subtitleMultiplier)
            }
        }
    }

    // MARK: - Constants
    static let height = 90 + UIApplication.shared.statusBarFrame.height
    static let smallHeight = 50 + UIApplication.shared.statusBarFrame.height

    let subtitleMultiplier = 0.75
    let bottomPadding = 24
    let edgePadding = 36
    let minSubtitleHeight = 16

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundView = UIView()
        backgroundView.alpha = 0.6

        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        backgroundImage = UIImageView()
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.alpha = 0.2
        backgroundImage.clipsToBounds = true
        backgroundView.addSubview(backgroundImage)

        titleLabel = UILabel()
        titleLabel.font = .boldSystemFont(ofSize: 72)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0
        titleLabel.numberOfLines = 0

        subtitleLabel = UILabel()
        subtitleLabel.font = .systemFont(ofSize: 72)
        subtitleLabel.textColor = .gray
        subtitleLabel.textAlignment = .center
        subtitleLabel.adjustsFontSizeToFitWidth = true
        subtitleLabel.minimumScaleFactor = 0
        subtitleLabel.numberOfLines = 0

        addSubview(backgroundView)
        addSubview(blurEffectView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)

        setUpConstraints()
    }

    func setUpConstraints() {

        // MARK: - Constants
        let topPadding = UIApplication.shared.statusBarFrame.height + 10
        let maxTitleHeight = 42
        let minTitleHeight = 22

        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        blurEffectView.snp.makeConstraints { make in
            make.edges.equalTo(backgroundView)
        }

        backgroundImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.top.greaterThanOrEqualToSuperview().offset(topPadding)
            make.bottom.equalTo(subtitleLabel.snp.top)
            make.leading.trailing.equalToSuperview().inset(edgePadding)
            make.height.greaterThanOrEqualTo(minTitleHeight)
            make.height.lessThanOrEqualTo(maxTitleHeight)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(bottomPadding)
            make.leading.trailing.equalToSuperview().inset(edgePadding)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
