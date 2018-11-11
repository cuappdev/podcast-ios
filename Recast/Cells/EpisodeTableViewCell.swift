//
//  EpisodeTableViewCell.swift
//  
//
//  Created by Jack Thompson on 9/15/18.
//

import UIKit
import SnapKit

class EpisodeTableViewCell: UITableViewCell {

    // MARK: - Variables
    var episodeNameLabel: UILabel!
    var dateTimeLabel: UILabel!
    var episodeDescriptionLabel: UILabel!
    var utilityView: EpisodeUtilityView!

    weak var delegate: DownloadDelegate?

    // Episode progress KVO
    fileprivate var observer: NSKeyValueObservation?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .black
        selectionStyle = .none

        episodeNameLabel = UILabel()
        episodeNameLabel.font = .systemFont(ofSize: 18)
        episodeNameLabel.textColor = .white

        dateTimeLabel = UILabel()
        dateTimeLabel.font = .systemFont(ofSize: 12)
        dateTimeLabel.textColor = .gray

        episodeDescriptionLabel = UILabel()
        episodeDescriptionLabel.font = .systemFont(ofSize: 14)
        episodeDescriptionLabel.textColor = .white
        episodeDescriptionLabel.textAlignment = .left
        episodeDescriptionLabel.numberOfLines = 3

        utilityView = EpisodeUtilityView(frame: .zero)
        utilityView.downloadButton.addTarget(self, action: #selector(downloadButtonPressed), for: .touchUpInside)

        addSubview(episodeNameLabel)
        addSubview(episodeDescriptionLabel)
        addSubview(dateTimeLabel)
        addSubview(utilityView)

        setUpConstraints()
    }

    func setUpConstraints() {
        // MARK: - Constants
        let edgePadding = 18
        let nameRightPadding = 90
        let nameTopPadding = 18.5
        let dateTimeTopPadding = 4
        let descriptionTopPadding = 12
        let controlViewHeight = 54.5

        episodeNameLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(nameRightPadding)
            make.top.equalToSuperview().offset(nameTopPadding)
            make.leading.equalTo(edgePadding)
        }

        dateTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(episodeNameLabel.snp.bottom).offset(dateTimeTopPadding)
            make.leading.trailing.equalTo(episodeNameLabel)
        }

        episodeDescriptionLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(edgePadding)
            make.bottom.equalTo(utilityView.snp.top)
            make.top.equalTo(dateTimeLabel.snp.bottom).offset(descriptionTopPadding)
        }

        utilityView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(controlViewHeight)
        }

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        observer?.invalidate()
    }

    @objc func downloadButtonPressed() {
        delegate?.changeDownloadStatus(for: self)
    }

    func observeDownloadProgress(for episode: Episode) {
        observer = episode.downloadInfo?.observe(\.progress, options: [.new, .initial], changeHandler: { (downloadInfo, change) in
            if let newValue = change.newValue {
                self.utilityView.setDownloadStatus(downloadInfo.status, progress: newValue)
            }
        })
    }

}
