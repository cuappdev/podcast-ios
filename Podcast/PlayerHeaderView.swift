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
    func playerHeaderViewDidDrag(sender: UIPanGestureRecognizer)
}

class PlayerHeaderView: UIView, UIGestureRecognizerDelegate {
    
    var collapseButton: UIButton!
    
    let playerHeaderViewHeight: CGFloat = 55
    let buttonX: CGFloat = 17
    let buttonY: CGFloat = 24.5
    let buttonSize: CGSize = CGSize(width: 17, height: 8.5)
    let buttonImageInsets: CGFloat = 10
    
    weak var delegate: PlayerHeaderViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame.size.height = playerHeaderViewHeight
        
        backgroundColor = .clear
        
        collapseButton = Button()
        collapseButton.setBackgroundImage(#imageLiteral(resourceName: "backArrow"), for: .normal)
        collapseButton.addTarget(self, action: #selector(collapseButtonTapped), for: .touchDown)
        addSubview(collapseButton)
        collapseButton.snp.makeConstraints { make in
            make.size.equalTo(buttonSize)
            make.leading.equalToSuperview().offset(buttonX)
            make.top.equalToSuperview().offset(buttonY)
        }

        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        panGestureRecognizer.delegate = self
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        tapGestureRecognizer.delegate = self
        addGestureRecognizer(panGestureRecognizer)
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func collapseButtonTapped() {
        delegate?.playerHeaderViewDidTapCollapseButton()
    }

    @objc func viewTapped(_ sender: UIGestureRecognizer) {
        if sender.isKind(of: UIPanGestureRecognizer.self) {
            delegate?.playerHeaderViewDidDrag(sender: sender as! UIPanGestureRecognizer)
        } else {
            delegate?.playerHeaderViewDidTapCollapseButton()
        }
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view != collapseButton 
    }
}
