//
//  TopicsGridCollectionViewCell.swift
//  Recast
//
//  Created by Jack Thompson on 11/17/18.
//  Copyright © 2018 Cornell AppDev. All rights reserved.
//

import UIKit

class TopicsGridCollectionViewCell: UICollectionViewCell {

    // MARK: - Variables
    var backgroundTileImageView: UIImageView!
    var topicLabel: UILabel!
    let topicTileAlpha: CGFloat = 0.25

    // MARK: - Constants
    let backgroundColors: [UIColor] = [.rosyPink, .sea, .duskyBlue, .dullYellow]

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundTileImageView = UIImageView()
        backgroundTileImageView.contentMode = .scaleAspectFit
        backgroundTileImageView.alpha = 0.25

        topicLabel = UILabel(frame: .zero)
        topicLabel.textAlignment = .center
        topicLabel.lineBreakMode = .byWordWrapping
        topicLabel.numberOfLines = 0
        topicLabel.textColor = .white
        topicLabel.font = .boldSystemFont(ofSize: 16)

        addSubview(backgroundTileImageView)
        addSubview(topicLabel)

        setUpConstraints()
    }

    func setUpConstraints() {

        // MARK: - Constants
        let labelInset = 5

        backgroundTileImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        topicLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(labelInset)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
