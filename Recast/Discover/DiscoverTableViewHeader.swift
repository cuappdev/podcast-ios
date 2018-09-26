//
//  DiscoverTableViewHeader.swift
//  Recast
//
//  Created by Jack Thompson on 9/19/18.
//  Copyright © 2018 Cornell AppDev. All rights reserved.
//

import UIKit
import SnapKit

class DiscoverTableViewHeader: UIView {

    // MARK: - Variables
    var episodePreviewHeaderImage: UIImageView!
    var episodePreviewPlayer: PreviewPlayerView!
    var episodeDescriptionView: UIView!

    var podcastTitleLabel: UILabel!
    var episodeTitleLabel: UILabel!
    var episodeDescriptionLabel: UILabel!
    var subscribeButton: UIButton!
    var seeMoreButton: UIButton!

    var isDescriptionExpanded: Bool = false

    //swiftlint:disable:next function_body_length
    override init(frame: CGRect) {
        super.init(frame: frame)

        episodePreviewHeaderImage = UIImageView()
        episodePreviewHeaderImage.image = #imageLiteral(resourceName: "davechang")
        episodePreviewHeaderImage.clipsToBounds = true
        episodePreviewHeaderImage.contentMode = .scaleAspectFill
        addSubview(episodePreviewHeaderImage)

        episodePreviewPlayer = PreviewPlayerView()
        addSubview(episodePreviewPlayer)

        episodeDescriptionView = UIView()
        episodeDescriptionView.isUserInteractionEnabled = true
        episodeDescriptionView.backgroundColor = .black
        addSubview(episodeDescriptionView)

        podcastTitleLabel = UILabel()
        podcastTitleLabel.font = .boldSystemFont(ofSize: 18)
        podcastTitleLabel.textColor = .white
        episodeDescriptionView.addSubview(podcastTitleLabel)

        episodeTitleLabel = UILabel()
        episodeTitleLabel.font = .systemFont(ofSize: 16)
        episodeTitleLabel.textColor = .gray
        episodeDescriptionView.addSubview(episodeTitleLabel)

        subscribeButton = UIButton()
        subscribeButton.backgroundColor = #colorLiteral(red: 0.2823529412, green: 0.6117647059, blue: 0.5960784314, alpha: 1)
        subscribeButton.setTitle("Subscribe", for: .normal)
        subscribeButton.setTitleColor(.white, for: .normal)
        subscribeButton.layer.cornerRadius = 0.5
        subscribeButton.addTarget(self, action: #selector(subscribeButtonPressed), for: .touchUpInside)
        episodeDescriptionView.addSubview(subscribeButton)

        episodeDescriptionLabel = UILabel()
        episodeDescriptionLabel.numberOfLines = 3
        episodeDescriptionLabel.font = .systemFont(ofSize: 16)
        episodeDescriptionLabel.textColor = .white
        episodeDescriptionView.addSubview(episodeDescriptionLabel)

        seeMoreButton = UIButton()
        seeMoreButton.setTitle("see more", for: .normal)
        seeMoreButton.setTitleColor(.gray, for: .normal)
        seeMoreButton.titleLabel!.font = .systemFont(ofSize: 16)
        seeMoreButton.addTarget(self, action: #selector(expandDescription), for: .touchUpInside)
        episodeDescriptionView.addSubview(seeMoreButton)

        makeConstraints()

        // MARK: - Test Data
        podcastTitleLabel.text = "The Dave Chang Show"
        episodeTitleLabel.text = "The Ringer"
        // swiftlint:disable:next line_length
        episodeDescriptionLabel.text = "Dave Chang has a few questions. Besides being the chef of the Momofuku restaurants and the creator and host of Netflix’s ‘Ugly Delicious,’ Dave is an avid student and fan of sports, music, art, film, and of course, food. In ranging conversations that cover everything from the creative process to his guest’s guiltiest pleasures, Dave and a rotating cast of smart, thought-provoking guests talk about their inspirations, failures, successes, fame ,and identities."
    }

    func makeConstraints() {
        // MARK: - Constants
        let headerImageHeight: CGFloat = 250
        let episodeTitleTopPadding: CGFloat = 5
        let subscribeButtonSize: CGSize = CGSize(width: 90, height: 34)
        let padding: CGFloat = 10

        episodePreviewHeaderImage.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(headerImageHeight)
        }

        episodePreviewPlayer.snp.makeConstraints { make in
            make.left.trailing.equalTo(episodePreviewHeaderImage)
            make.top.equalTo(episodePreviewHeaderImage.snp.bottom).inset(PreviewPlayerView.upNextViewHeight)
        }

        episodeDescriptionView.snp.makeConstraints { make in
            make.top.equalTo(episodePreviewPlayer.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(seeMoreButton.snp.bottom).offset(padding)
        }

        podcastTitleLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(padding)
        }

        episodeTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(podcastTitleLabel)
            make.top.equalTo(podcastTitleLabel.snp.bottom).offset(episodeTitleTopPadding)
        }

        subscribeButton.snp.makeConstraints { make in
            make.top.equalTo(podcastTitleLabel)
            make.trailing.equalToSuperview().inset(padding)
            make.size.equalTo(subscribeButtonSize)
        }

        episodeDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(episodeTitleLabel.snp.bottom).offset(padding)
            make.leading.trailing.equalToSuperview().inset(padding)
        }

        seeMoreButton.snp.makeConstraints { make in
            make.trailing.equalTo(episodeDescriptionLabel.snp.trailing)
            make.top.equalTo(episodeDescriptionLabel.snp.bottom).offset(episodeTitleTopPadding)
        }
    }

    @objc func expandDescription() {
        isDescriptionExpanded.toggle()
        self.episodeDescriptionLabel.numberOfLines = isDescriptionExpanded ? 0 : 3

    }

    @objc func subscribeButtonPressed() {
        print("subscribe")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
