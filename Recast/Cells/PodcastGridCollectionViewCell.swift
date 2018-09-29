//
//  SeriesCollectionViewCell.swift
//  Recast
//
//  Created by Jaewon Sim on 9/16/18.
//  Copyright © 2018 Cornell AppDev. All rights reserved.
//

import UIKit
import SnapKit

class PodcastGridCollectionViewCell: UICollectionViewCell {

    var isNew: Bool?

    // MARK: View vars
    var seriesImageView: UIImageView!
    var newStickerView: NewStickerView!

    // MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        seriesImageView = UIImageView()
        seriesImageView.setCornerRadius(forView: .large)
        contentView.addSubview(seriesImageView)

        newStickerView = NewStickerView()
        newStickerView.isHidden = true
        seriesImageView.addSubview(newStickerView)
        newStickerView.bringSubview(toFront: newStickerView)

        setUpConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Constraint setup
    private func setUpConstraints() {
        let newStickerViewLeadingOffset: CGFloat = 8
        let newStickerViewBottomInset: CGFloat = 8
        let newStickerViewHeight: CGFloat = 20
        let newStickerViewWidth: CGFloat = 43

        seriesImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        newStickerView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(newStickerViewLeadingOffset)
            make.bottom.equalToSuperview().inset(newStickerViewBottomInset)
            make.height.equalTo(newStickerViewHeight)
            make.width.equalTo(newStickerViewWidth)
        }
    }
}
