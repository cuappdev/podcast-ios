//
//  PlayerHeaderView.swift
//  Podcast
//
//  Created by Mark Bryan on 2/21/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

protocol PlayerHeaderViewDelegate: class {
    func playerHeaderViewDidTapCollapseButton()
}

class PlayerHeaderView: UIView {
    
    var collapseButton: UIButton!
    
    let playerHeaderViewHeight: CGFloat = 55
    let buttonX: CGFloat = 17
    let buttonY: CGFloat = 24.5
    let buttonSize: CGSize = CGSize(width: 18, height: 18)
    
    weak var delegate: PlayerHeaderViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        collapseButton = UIButton(frame: .zero)
        collapseButton.setImage(#imageLiteral(resourceName: "backArrowDown"), for: .normal)
        collapseButton.addTarget(self, action: #selector(collapseButtonTapped), for: .touchDown)
        addSubview(collapseButton)
        collapseButton.snp.makeConstraints { make in
            make.size.equalTo(buttonSize)
            make.leading.equalToSuperview().offset(buttonX)
            make.top.equalToSuperview().offset(buttonY)
        }
        self.frame.size.height = playerHeaderViewHeight
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.playerHeaderViewDidTapCollapseButton()
    }
    
    @objc func collapseButtonTapped() {
        delegate?.playerHeaderViewDidTapCollapseButton()
    }

}
