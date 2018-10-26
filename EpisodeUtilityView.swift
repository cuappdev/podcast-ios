//
//  EpisodeCellControlView.swift
//  Recast
//
//  Created by Jack Thompson on 10/21/18.
//  Copyright © 2018 Cornell AppDev. All rights reserved.
//

import UIKit

class EpisodeUtilityView: UIView {

    // MARK: - Variables
    var playButton: UIButton!
    var downloadButton: UIButton!

    // TODO: later change to download status to indicate episode is downloading
    var isDownloaded: Bool = false

    init(frame: CGRect, isDownloaded: Bool) {
        super.init(frame: frame)

        playButton = UIButton()
        playButton.setTitle("Play", for: .normal)
        playButton.titleLabel?.font = .systemFont(ofSize: 14)
        playButton.setTitleColor(.gray, for: .normal)
        playButton.setImage(#imageLiteral(resourceName: "play_icon"), for: .normal)

        downloadButton = UIButton()
        downloadButton.titleLabel?.font = .systemFont(ofSize: 14)
        downloadButton.setTitleColor(.gray, for: .normal)

        if isDownloaded {
            downloadButton.setTitle("Downloaded", for: .normal)
            downloadButton.setImage(#imageLiteral(resourceName: "downloaded_icon"), for: .normal)
        } else {
            downloadButton.setTitle("Download", for: .normal)
            downloadButton.setImage(#imageLiteral(resourceName: "download_icon"), for: .normal)
        }

        addSubview(playButton)
        addSubview(downloadButton)

        setUpConstraints()
    }

    func setUpConstraints() {
        // MARK: - Constants
        let sidePadding = 18
        let playButtonSize = CGSize(width: 16, height: 18)
        let downloadButtonSize = CGSize(width: 16, height: 16)

        playButton.snp.makeConstraints { make in
//            make.height.equalTo(buttonHeight)
            make.leading.equalToSuperview().offset(sidePadding)
            make.top.bottom.equalToSuperview()
        }

        playButton.imageView?.snp.makeConstraints { make in
            make.size.equalTo(playButtonSize)
            make.leading.centerY.equalToSuperview()
        }

        downloadButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(sidePadding)
            make.top.bottom.equalToSuperview()
        }

        downloadButton.imageView?.snp.makeConstraints { make in
            make.size.equalTo(downloadButtonSize)
            make.leading.centerY.equalToSuperview()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
