//
//  PlayerHeaderView.swift
//  Podcast
//
//  Created by Jack Thompson on 9/18/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import UIKit

protocol PlayerHeaderViewDelegate: class {
    func playerHeaderViewDidTapCollapseButton()
}

class PlayerHeaderView: UIView {

    // MARK: - Variables
    var collapseButton: UIButton!

    weak var delegate: PlayerHeaderViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .clear

        collapseButton = UIButton()
        collapseButton.setBackgroundImage(#imageLiteral(resourceName: "down_arrow_icon"), for: .normal)
        collapseButton.addTarget(self, action: #selector(collapseButtonTapped), for: .touchDown)
        addSubview(collapseButton)

        setUpConstraints()
    }

    func setUpConstraints() {
        // MARK: - Constants
        let buttonX: CGFloat = 22
        let buttonY: CGFloat = 28
        let buttonSize: CGSize = CGSize(width: 17, height: 8.5)

        collapseButton.snp.makeConstraints { make in
            make.size.equalTo(buttonSize)
            make.leading.equalToSuperview().offset(buttonX)
            make.top.equalToSuperview().offset(buttonY)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func collapseButtonTapped() {
        delegate?.playerHeaderViewDidTapCollapseButton()
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view != collapseButton
    }
}
