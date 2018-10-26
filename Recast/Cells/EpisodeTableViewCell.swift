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

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .black

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

        utilityView = EpisodeUtilityView(frame: .zero, isDownloaded: false)

        addSubview(episodeNameLabel)
        addSubview(episodeDescriptionLabel)
        addSubview(dateTimeLabel)
        addSubview(utilityView)

        // MARK: - Test data:
        episodeNameLabel.text = "Episode Title"
        dateTimeLabel.text = "Jan. 1, 2018 • 23:00"
        // swiftlint:disable:next line_length
        episodeDescriptionLabel.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."

        setUpConstraints()
    }

    func setUpConstraints() {
        // MARK: - Constants
        let edgePadding = 18
        let nameRightPadding = 90
        let nameTopPadding = 18.5
        let dateTimeTopPadding = 4
        let descriptionTopPadding = 12
        let descriptionBottomPadding = 12.5
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
}
