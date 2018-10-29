//
//  CustomNavigationBar.swift
//  Recast
//
//  Created by Jack Thompson on 10/28/18.
//  Copyright © 2018 Cornell AppDev. All rights reserved.
//

import UIKit

class CustomNavigationBar: UIView {

    var titleLabel: UILabel!
    var publisherLabel: UILabel!

    var imageContainerView: UIView!
    var backgroundImage: UIImageView!
    var gradientLayer: CAGradientLayer!

    static let height = 70 + UIApplication.shared.statusBarFrame.height

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .clear

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .zero
        layer.shadowOpacity = 0.0
        layer.shadowRadius = 6.0

        imageContainerView = UIView()
        imageContainerView.clipsToBounds = true

        backgroundImage = UIImageView()
        backgroundImage.clipsToBounds = true
        backgroundImage.contentMode = .scaleAspectFill
        imageContainerView.addSubview(backgroundImage)

        gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 0.9).cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.0, 0.9]
        backgroundImage.layer.addSublayer(gradientLayer)

        titleLabel = UILabel()
        titleLabel.font = .boldSystemFont(ofSize: 22)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center

        publisherLabel = UILabel()
        publisherLabel.font = .systemFont(ofSize: 16)
        publisherLabel.textColor = .gray
        publisherLabel.textAlignment = .center

        addSubview(imageContainerView)
        addSubview(titleLabel)
        addSubview(publisherLabel)

        setUpConstraints()
    }

    func setUpConstraints() {
        let topPadding = UIApplication.shared.statusBarFrame.height + 6
        let edgePadding = 36
        let titleHeight = 30
        let publisherHeight = 21

        let imageHeight: CGFloat = 374.5 + UIApplication.shared.statusBarFrame.height

        imageContainerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        backgroundImage.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(imageHeight)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(topPadding)
            make.leading.trailing.equalToSuperview().inset(edgePadding)
            make.height.equalTo(titleHeight)
        }

        publisherLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(edgePadding)
            make.height.equalTo(publisherHeight)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
