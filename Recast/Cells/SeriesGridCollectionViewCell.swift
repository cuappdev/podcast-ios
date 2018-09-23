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
        seriesImageView.layer.cornerRadius = 8
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpConstraints() {
        let imageViewHeight: CGFloat = 60
        let imageViewWidth: CGFloat = 60
        
        seriesImageView.snp.makeConstraints { (make) -> Void in
            make.leading.equalTo(contentView)
            make.height.equalTo(imageViewHeight)
            make.width.equalTo(imageViewWidth)
            make.trailing.equalTo(contentView)
        }
    }

    func configure(withDummy series: DummyPodcastSeries) {
        seriesImageView.image = series.image
    }

}
