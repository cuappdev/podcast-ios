//
//  NewStickerView.swift
//  Recast
//
//  Created by Jaewon Sim on 9/26/18.
//  Copyright © 2018 Cornell AppDev. All rights reserved.
//

import UIKit
import SnapKit

class NewStickerView: UIView {

    var stickerContainerView: UIView!
    var newLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        stickerContainerView = UIView()
        stickerContainerView.setCornerRadius(forViewWithSize: .small)
        stickerContainerView.backgroundColor = .red
        addSubview(stickerContainerView)

        newLabel = UILabel()
        newLabel.text = "NEW"
        newLabel.font = UIFont.systemFont(ofSize: 12, weight: .heavy)
        newLabel.textAlignment = .center
        newLabel.adjustsFontSizeToFitWidth = true
        newLabel.textColor = .white
        stickerContainerView.addSubview(newLabel)

        setUpConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpConstraints() {
        let stickerContainerViewHeight: CGFloat = 20
        let stickerContainerViewWidth: CGFloat = 43
        let newLabelEdgeInsets = UIEdgeInsets(top: 3, left: 8, bottom: 3, right: 8)

        stickerContainerView.snp.makeConstraints { make in
            make.height.equalTo(stickerContainerViewHeight)
            make.width.equalTo(stickerContainerViewWidth)
        }

        newLabel.snp.makeConstraints { make in
            make.edges.equalTo(newLabelEdgeInsets)
        }
    }

}
