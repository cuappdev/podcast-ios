//
//  PodcastTableViewCell.swift
//  
//
//  Created by Jack Thompson on 9/15/18.
//

import UIKit
import SnapKit
import Kingfisher

class PodcastTableViewCell: UITableViewCell {

    // MARK: - Variables
    var podcastImageView: UIImageView!
    var podcastNameLabel: UILabel!
    var podcastPublisherLabel: UILabel!

    // MARK: - Constants
    static let cellReuseId = "podcastCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .white
        selectionStyle = .none

        podcastImageView = UIImageView()
        podcastImageView.clipsToBounds = true

        podcastNameLabel = UILabel()
        podcastNameLabel.font = .systemFont(ofSize: 16)

        podcastPublisherLabel = UILabel()
        podcastPublisherLabel.font = .systemFont(ofSize: 12)

        addSubview(podcastImageView)
        addSubview(podcastNameLabel)
        addSubview(podcastPublisherLabel)

        setUpConstraints()
    }

    func setUpConstraints() {
        // MARK: - Constants
        let padding = 10
        let imageHeight = 75

        podcastImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(padding)
            make.height.width.equalTo(imageHeight)
            make.bottom.lessThanOrEqualToSuperview().inset(padding)
        }

        podcastNameLabel.snp.makeConstraints { make in
            make.top.equalTo(podcastImageView)
            make.leading.equalTo(podcastImageView.snp.trailing).offset(padding)
            make.trailing.equalToSuperview().inset(padding)
        }

        podcastPublisherLabel.snp.makeConstraints { make in
            make.top.equalTo(podcastNameLabel.snp.bottom)
            make.leading.trailing.equalTo(podcastNameLabel)
        }

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
