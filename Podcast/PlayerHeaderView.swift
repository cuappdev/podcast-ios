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
    
    let playerHeaderViewHeight: CGFloat = 48
    let buttonOrigin: CGPoint = CGPoint(x: 18, y: 27)
    let buttonSize: CGSize = CGSize(width: 12, height: 12)
    
    weak var delegate: PlayerHeaderViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.colorFromCode(0xf4f4f7)
        collapseButton = UIButton(frame: .zero)
        collapseButton.frame.origin = buttonOrigin
        collapseButton.frame.size = buttonSize
        collapseButton.setImage(#imageLiteral(resourceName: "feed_control_icon"), for: .normal)
        collapseButton.addTarget(self, action: #selector(collapseButtonTapped), for: .touchDown)
        addSubview(collapseButton)
        self.frame.size.height = playerHeaderViewHeight
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.playerHeaderViewDidTapCollapseButton()
    }
    
    func collapseButtonTapped() {
        delegate?.playerHeaderViewDidTapCollapseButton()
    }

}
