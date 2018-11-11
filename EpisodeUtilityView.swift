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

    override init(frame: CGRect) {
        super.init(frame: frame)

        playButton = UIButton()
        playButton.setTitle("Play", for: .normal)
        playButton.titleLabel?.font = .systemFont(ofSize: 14)
        playButton.setTitleColor(.gray, for: .normal)
        playButton.setImage(#imageLiteral(resourceName: "play_icon"), for: .normal)

        downloadButton = UIButton()
        downloadButton.titleLabel?.font = .systemFont(ofSize: 14)
        downloadButton.setTitleColor(.gray, for: .normal)

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

    func setDownloadStatus(_ downloadStatus: String? = nil, progress: Float? = nil) {
        if let status = downloadStatus {
            if status == DownloadInfoStatus.downloading {
                let progress = Int(round(progress! * 100))
                downloadButton.setTitle("\(progress)%", for: .normal)
                downloadButton.setImage(#imageLiteral(resourceName: "download_icon"), for: .normal)
            } else if status == DownloadInfoStatus.succeeded {
                downloadButton.setTitle("Downloaded", for: .normal)
                downloadButton.setImage(#imageLiteral(resourceName: "downloaded_icon"), for: .normal)
            } else if status == DownloadInfoStatus.canceled {
                downloadButton.setTitle("Canceled", for: .normal)
                downloadButton.setImage(#imageLiteral(resourceName: "download_icon"), for: .normal)
            } else if status == DownloadInfoStatus.failed {
                downloadButton.setTitle("Failed", for: .normal)
                downloadButton.setImage(#imageLiteral(resourceName: "download_icon"), for: .normal)
            }
        } else {
            // not downloaded
            downloadButton.setTitle("Download", for: .normal)
            downloadButton.setImage(#imageLiteral(resourceName: "download_icon"), for: .normal)
        }
    }

}
