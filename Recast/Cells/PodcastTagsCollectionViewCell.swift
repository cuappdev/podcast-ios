//
//  PodcastTagsCollectionViewCell.swift
//  Recast
//
//  Created by Jack Thompson on 10/24/18.
//  Copyright © 2018 Cornell AppDev. All rights reserved.
//

import UIKit

class PodcastTagsCollectionViewCell: UICollectionViewCell {

    // MARK: - Variables
    var tagLabel: UILabel!
    var borderView: UIView!

    // MARK: - Constants
    static let cellReuseId = "tagCell"

    override init(frame: CGRect) {
        super.init(frame: frame)

        tagLabel = UILabel()
        tagLabel.font = .systemFont(ofSize: 16)
        tagLabel.textColor = .gray

        borderView = UIView()
        borderView.layer.borderWidth = 1
        borderView.layer.borderColor = UIColor.gray.cgColor
        borderView.setCornerRadius(forView: .small)

        addSubview(tagLabel)
        addSubview(borderView)

        setUpConstraints()
    }

    func setUpConstraints() {
        // MARK: - Constants
        let labelInset = 12

        tagLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(labelInset)
        }

        borderView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
