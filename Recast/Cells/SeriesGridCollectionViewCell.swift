//
//  SeriesCollectionViewCell.swift
//  Recast
//
//  Created by Jaewon Sim on 9/16/18.
//  Copyright © 2018 Cornell AppDev. All rights reserved.
//

import UIKit
import SnapKit

class SeriesGridCollectionViewCell: UICollectionViewCell {
    private var seriesImageView: UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        seriesImageView = UIImageView()
        seriesImageView.setCornerRadius()
        contentView.addSubview(seriesImageView)

        setUpConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpConstraints() {
        seriesImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func configure(with series: DummyPodcastSeries) {
        seriesImageView.image = series.image
    }
}
