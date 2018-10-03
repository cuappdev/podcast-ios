//
//  EpisodeTableViewCell.swift
//  
//
//  Created by Jack Thompson on 9/15/18.
//

import UIKit
import SnapKit
import AHDownloadButton

protocol EpisodeActionDelegate: class {
    func startDownload(for cell: EpisodeTableViewCell)
    func cancelDownload(for cell: EpisodeTableViewCell)
    func resumeDownload(for cell: EpisodeTableViewCell)
}

class EpisodeTableViewCell: UITableViewCell {

    // MARK: - Variables
    var episodeImageView: UIImageView!
    var episodeNameLabel: UILabel!
    var episodeDescriptionView: UILabel!
    var dateTimeLabel: UILabel!
    var downloadButton: AHDownloadButton!
    weak var delegate: EpisodeActionDelegate?

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .white

        episodeImageView = UIImageView()

        episodeNameLabel = UILabel()
        episodeNameLabel.font = .systemFont(ofSize: 16)

        dateTimeLabel = UILabel()
        dateTimeLabel.font = .systemFont(ofSize: 12)

        episodeDescriptionView = UILabel()
        episodeDescriptionView.font = .systemFont(ofSize: 14)
        episodeDescriptionView.textAlignment = .left
        episodeDescriptionView.numberOfLines = 3

        downloadButton = AHDownloadButton(frame: .zero)
        downloadButton.delegate = self

        addSubview(episodeImageView)
        addSubview(episodeNameLabel)
        addSubview(episodeDescriptionView)
        addSubview(dateTimeLabel)
        addSubview(downloadButton)

        // MARK: - Test data:
        episodeImageView.backgroundColor = .blue
        episodeNameLabel.text = "Episode Title"
        dateTimeLabel.text = "Jan. 1, 2018 • 23:00"
        // swiftlint:disable:next line_length
        episodeDescriptionView.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."

        setUpConstraints()
    }

    func setUpConstraints() {
        // MARK: - Constants
        let padding = 5
        let imageHeight = 50
        let buttonWidth = 50

        episodeImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(padding)
            make.height.width.equalTo(imageHeight)
        }

        episodeNameLabel.snp.makeConstraints { make in
            make.top.equalTo(episodeImageView)
            make.leading.equalTo(episodeImageView.snp.trailing).offset(padding)
            make.trailing.equalToSuperview().inset(padding)
        }

        dateTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(episodeNameLabel.snp.bottom)
            make.leading.trailing.equalTo(episodeNameLabel)
        }

        episodeDescriptionView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(padding)
            make.trailing.bottom.equalToSuperview().inset(padding)
            make.top.equalTo(episodeImageView.snp.bottom).offset(padding)
        }

        downloadButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(padding)
            make.top.bottom.equalTo(dateTimeLabel)
            make.width.equalTo(buttonWidth)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Download Button Delegate
extension EpisodeTableViewCell: AHDownloadButtonDelegate {
    func didTapDownloadButton(withState state: AHDownloadButton.State) {
        switch state {
        case .startDownload:
            downloadButton.progress = 0
            downloadButton.state = .pending
            delegate?.startDownload(for: self) // versus resuming??
        case .pending:
            break
        case .downloading:
            delegate?.cancelDownload(for: self)
            break
        case .downloaded:
            // maybe delete download? change text to play instead of "open"
            break
        }
    }
}
