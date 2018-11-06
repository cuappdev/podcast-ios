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

class PodcastDetailViewController: UIViewController, EpisodeFilterDelegate {

    // MARK: - Variables
    var partialPodcast: PartialPodcast!
    var podcast: Podcast?

    var stickyNavBar: CustomNavigationBar!

    var backgroundImage: UIImageView!
    var gradientLayer: CAGradientLayer!

    var headerView: PodcastDetailHeaderView!
    var episodeTableView: UITableView!

    // MARK: - Constants
    let episodeCellReuseIdentifer = "episodeCell"

    init(partialPodcast: PartialPodcast) {
        super.init(nibName: nil, bundle: nil)

        self.partialPodcast = partialPodcast
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black

        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true

        stickyNavBar = CustomNavigationBar()
        stickyNavBar.isHidden = true
        stickyNavBar.titleLabel.text = partialPodcast.collectionName
        stickyNavBar.publisherLabel.text = partialPodcast.artistName

        backgroundImage = UIImageView()
        backgroundImage.clipsToBounds = true
        backgroundImage.contentMode = .scaleAspectFill

        gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 0.9).cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.0, 0.9]
        backgroundImage.layer.insertSublayer(gradientLayer, at: 0)

        headerView = PodcastDetailHeaderView(frame: .zero)
        backgroundImage.kf.setImage(with: partialPodcast.artworkUrl600 ?? partialPodcast.artworkUrl100) { (image, _, _, _) in
            self.stickyNavBar.backgroundImage.image = image
            self.headerView.imageView.image = image
        }
        headerView.titleLabel.text = partialPodcast.collectionName
        headerView.publisherLabel.text = partialPodcast.artistName
        headerView.podcastGenres = partialPodcast.genres
        headerView.filterView.delegate = self

        episodeTableView = UITableView()
        episodeTableView.backgroundColor = .clear
        episodeTableView.insetsContentViewsToSafeArea = false
        episodeTableView.contentInsetAdjustmentBehavior = .never
        episodeTableView.showsVerticalScrollIndicator = false
        episodeTableView.delegate = self
        episodeTableView.dataSource = self
        episodeTableView.rowHeight = UITableView.automaticDimension
        episodeTableView.tableHeaderView = headerView
        episodeTableView.register(EpisodeTableViewCell.self, forCellReuseIdentifier: episodeCellReuseIdentifer)

        view.addSubview(backgroundImage)
        view.addSubview(episodeTableView)
        view.addSubview(stickyNavBar)

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
        }, failure: { error in
            print(error)
        })
    }

    func setUpConstraints() {
        // MARK: - Constants
        let headerViewHeight: CGFloat = 375 + UIApplication.shared.statusBarFrame.height

        stickyNavBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(CustomNavigationBar.height)
        }

        backgroundImage.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(headerViewHeight)
        }

        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(headerViewHeight)
            make.width.equalTo(view.safeAreaLayoutGuide)
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

        stickyNavBar.gradientLayer.frame = stickyNavBar.backgroundImage.bounds
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func filterEpisodes(by filterType: FilterType) {
        switch filterType {
        case .newest: podcast?.items.sort { (e1, e2) -> Bool in
            return e1.pubDate?.compare(e2.pubDate ?? Date()) == .orderedDescending
            }
        case .oldest: podcast?.items.sort { (e1, e2) -> Bool in
            return e1.pubDate?.compare(e2.pubDate ?? Date()) == .orderedAscending
            }
        case .popular, .unlistened: break
        }
        episodeTableView.reloadData()
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

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, YYYY"
        if let date = episode.pubDate {
            cell.dateTimeLabel.text = dateFormatter.string(from: date)
        } else {
            cell.dateTimeLabel.text = ""
        }

        cell.episodeDescriptionLabel.text = episode.description ?? ""
        return cell
    }
}

// MARK: - episodeTableView Delegate
extension PodcastDetailViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let barScrollOffset: CGFloat = 115
        let shadowScrollOffset: CGFloat = 257

        if scrollView.contentOffset.y > barScrollOffset {
            stickyNavBar.isHidden = false
        } else {
            stickyNavBar.isHidden = true
        }

        if scrollView.contentOffset.y > shadowScrollOffset {
            stickyNavBar.layer.shadowOpacity = 0.8
        } else {
            stickyNavBar.layer.shadowOpacity = 0.0
        }
    }
}
