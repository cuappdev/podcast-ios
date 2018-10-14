//
//  PlayerViewController.swift
//  Recast
//
//  Created by Jack Thompson on 9/16/18.
//  Copyright © 2018 Cornell AppDev. All rights reserved.
//

import UIKit
import SnapKit
import AVFoundation

class PlayerViewController: UIViewController {

    // MARK: - Variables
    private var player: AVQueuePlayer!

    private var queue: [Episode]!

    var controlsView: PlayerControlsView!
    var playerHeaderView: PlayerHeaderView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        playerHeaderView = PlayerHeaderView(frame: .zero)
        playerHeaderView.frame.size.width = view.frame.width
        playerHeaderView.delegate = self
        view.addSubview(playerHeaderView)

        controlsView = PlayerControlsView(frame: .zero)
        view.addSubview(controlsView)

        setupConstraints()

        // TODO: setup player queue from saved queue
    }

    func setupConstraints() {
        // MARK: - Constants
        let topPadding: CGFloat = 100
        let controlsHeight: CGFloat = 100

        playerHeaderView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(topPadding)
        }

        controlsView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(topPadding)
            make.height.equalTo(controlsHeight)
        }
    }

    // MARK: - Player Controls

    func play(_ episode: Episode) {

    }

    func queue(_ episode: Episode, at index: Int? = nil) {

    }

    @objc func collapse() {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - PlayerHeaderViewDelegate
extension PlayerViewController: PlayerHeaderViewDelegate {

    func playerHeaderViewDidTapCollapseButton() {
        collapse()
    }
}
