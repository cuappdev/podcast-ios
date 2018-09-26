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
    static let cellReuseIdentifier = "podcastCell"

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .white

        podcastImageView = UIImageView()
        podcastImageView.clipsToBounds = true

        podcastNameLabel = UILabel()
        podcastNameLabel.font = .systemFont(ofSize: 16)

        podcastPublisherLabel = UILabel()
        podcastPublisherLabel.font = .systemFont(ofSize: 12)

        addSubview(podcastImageView)
        addSubview(podcastNameLabel)
        addSubview(podcastPublisherLabel)

        layoutSubviews()
    }

    override func layoutSubviews() {
        // MARK: - Constants
        let padding = 10
        let imageHeight = 75

        super.layoutSubviews()

        podcastImageView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(padding)
            make.height.width.equalTo(imageHeight)
            make.bottom.lessThanOrEqualToSuperview().inset(padding)
        }

        podcastNameLabel.snp.makeConstraints { make in
            make.top.equalTo(podcastImageView)
            make.left.equalTo(podcastImageView.snp.right).offset(padding)
            make.right.equalToSuperview().inset(padding)
        }

        podcastPublisherLabel.snp.makeConstraints { make in
            make.top.equalTo(podcastNameLabel.snp.bottom)
            make.left.right.equalTo(podcastNameLabel)
        }

    }

    func setUp(podcast: PartialPodcast) {

        let artworkURL = podcast.artworkUrl100 ?? podcast.artworkUrl60 ?? podcast.artworkUrl30
        podcastImageView.kf.setImage(with: artworkURL)

        podcastNameLabel.text = podcast.collectionName
        podcastPublisherLabel.text = podcast.artistName
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
