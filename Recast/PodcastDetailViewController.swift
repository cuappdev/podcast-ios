//
//  PodcastDetailViewController.swift
//  Recast
//
//  Created by Jack Thompson on 10/16/18.
//  Copyright © 2018 Cornell AppDev. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class PodcastDetailViewController: UIViewController {

    // MARK: - Variables
    var partialPodcast: PartialPodcast!
    var podcast: Podcast?

    var backgroundContainerView: UIView!
    var backgroundImage: UIImageView!
    var gradientLayer: CAGradientLayer!

    var headerView: PodcastDetailHeaderView!
    var episodeTableView: UITableView!

    // MARK: - Constants
    let episodeCellReuseIdentifer = "episodeCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black

        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true

        backgroundContainerView = UIView()

        backgroundImage = UIImageView()
        backgroundImage.clipsToBounds = true
        backgroundImage.contentMode = .scaleAspectFill
        backgroundContainerView.addSubview(backgroundImage)

        gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 0.9).cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        backgroundImage.layer.insertSublayer(gradientLayer, at: 0)

        headerView = PodcastDetailHeaderView(frame: .zero)
        headerView.imageView.kf.setImage(with: partialPodcast.artworkUrl600 ?? partialPodcast.artworkUrl100) { (image, _, _, _) in
            self.backgroundImage.image = image
        }
        headerView.titleLabel.text = partialPodcast.collectionName
        headerView.publisherLabel.text = partialPodcast.artistName
        headerView.podcastGenres = partialPodcast.genres

        episodeTableView = UITableView()
        episodeTableView.backgroundColor = .clear
        episodeTableView.insetsContentViewsToSafeArea = false
        episodeTableView.contentInsetAdjustmentBehavior = .never
        episodeTableView.delegate = self
        episodeTableView.dataSource = self
        episodeTableView.rowHeight = UITableView.automaticDimension
        episodeTableView.tableHeaderView = headerView
        episodeTableView.register(EpisodeTableViewCell.self, forCellReuseIdentifier: episodeCellReuseIdentifer)

        view.addSubview(backgroundContainerView)
        view.addSubview(episodeTableView)

        setUpConstraints()
    }

    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        Podcast.loadFull(from: self.partialPodcast, success: { podcast in
            self.podcast = podcast
            self.episodeTableView.reloadData()
        }) { error in
            print(error)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.backgroundColor = .black
        navigationController?.navigationBar.isTranslucent = false
    }

    func setUpConstraints() {
        // MARK: - Constants
        let headerViewHeight: CGFloat = 374.5 + UIApplication.shared.statusBarFrame.height

        backgroundContainerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(episodeTableView)
            make.height.equalTo(headerViewHeight)
        }

        backgroundImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(headerViewHeight)
            make.width.equalTo(view.safeAreaLayoutGuide)
            make.bottom.greaterThanOrEqualToSuperview().offset(100)
        }

        episodeTableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(view.snp.top)
        }

        episodeTableView.tableHeaderView?.layoutIfNeeded()

        viewDidLayoutSubviews()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        gradientLayer.frame = backgroundImage.bounds
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK: - episodeTableView DataSource
extension PodcastDetailViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return podcast?.items.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let episode = podcast?.items[indexPath.row] else { return UITableViewCell() }
        // swiftlint:disable:next force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: episodeCellReuseIdentifer, for: indexPath) as! EpisodeTableViewCell
        cell.episodeNameLabel.text = episode.title ?? ""
        cell.dateTimeLabel.text = episode.pubDate?.description ?? ""
        cell.episodeDescriptionLabel.text = episode.description ?? ""
        return cell
    }
}

// MARK: - episodeTableView Delegate
extension PodcastDetailViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let player = PlayerViewController()
        self.present(player, animated: true, completion: nil)
    }
}
