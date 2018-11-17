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
import CoreData

protocol DownloadDelegate: class {
    func changeDownloadStatus(for cell: EpisodeTableViewCell)
}

class PodcastDetailViewController: UIViewController, EpisodeFilterDelegate {

    // MARK: - Variables
    var partialPodcast: PartialPodcast!
    var podcast: Podcast?

    var stickyNavBar: CustomNavigationBar!

    var backgroundImage: UIImageView!
    var gradientLayer: CAGradientLayer!

    var headerView: PodcastDetailHeaderView!
    var episodeTableView: UITableView!

    var episodesToDisplay: [Episode]?
    var downloadIdentifiers: [String] = []

    private var observer: NSObjectProtocol!

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

    deinit {
        NotificationCenter.default.removeObserver(observer)
    }

    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true

        Podcast.loadFull(from: self.partialPodcast, success: { podcast in
            self.podcast = podcast
            self.diffEpisodes(for: podcast)
            // swiftlint:disable:next opening_brace
            self.downloadIdentifiers = self.episodesToDisplay?.map{ $0.enclosure?.url?.absoluteString ?? "" } ?? []
            self.episodeTableView.reloadData()
            // swiftlint:disable:next multiple_closures_with_trailing_closure
        }) { error in
            print(error)
        }
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
        case .newest: episodesToDisplay?.sort { (e1, e2) -> Bool in
            return e1.pubDate?.compare(e2.pubDate as Date? ?? Date()) == .orderedDescending
            }
        case .oldest: episodesToDisplay?.sort { (e1, e2) -> Bool in
            return e1.pubDate?.compare(e2.pubDate as Date? ?? Date()) == .orderedAscending
            }
        case .popular, .unlistened: break
        }
        episodeTableView.reloadData()
    }

    func diffEpisodes(for podcast: Podcast) {
        let loadedEpisodes = Episode.fetchEpisodes(for: podcast, in: AppDelegate.appDelegate.dataController.managedObjectContext)
        var episodes = podcast.items?.array as? [Episode] ?? []
        for i in 0..<episodes.count {
            if let index = loadedEpisodes.firstIndex(of: episodes[i]) {
                episodes[i] = loadedEpisodes[index]
            }
        }
        episodesToDisplay = episodes
    }
}

// MARK: - episodeTableView DataSource
extension PodcastDetailViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodesToDisplay?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let episode = episodesToDisplay?[indexPath.row] else { return UITableViewCell() }
        // swiftlint:disable:next force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: episodeCellReuseIdentifer, for: indexPath) as! EpisodeTableViewCell
        cell.episodeNameLabel.text = episode.title ?? ""

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, YYYY"
        if let date = episode.pubDate as Date? {
            cell.dateTimeLabel.text = dateFormatter.string(from: date)
        } else {
            cell.dateTimeLabel.text = ""
        }

        cell.episodeDescriptionLabel.text = episode.descriptionText
        cell.delegate = self
        cell.utilityView.setDownloadStatus(episode.downloadInfo?.status, progress: episode.downloadInfo?.progress)
        cell.observeDownloadProgress(for: episode)
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

extension PodcastDetailViewController: DownloadDelegate {
    func changeDownloadStatus(for cell: EpisodeTableViewCell) {
        guard let indexPath = episodeTableView.indexPath(for: cell), let episodes = episodesToDisplay else { return }
        let episode = episodes[indexPath.row]
        episode.downloadInfo?.setValue(DownloadInfoStatus.downloading, for: .status)
        // need to figure out a way to store download status
        observer = NotificationCenter.default.addObserver(forName: .didUpdateDownloadProgress, object: nil, queue: .main) { [weak self] notification in
            self?.progressChanged(sender: notification)
        }

        observer = NotificationCenter.default.addObserver(forName: .didCompleteDownload, object: nil, queue: .main) { [weak self] notification in
            self?.downloadSucceeded(sender: notification)
        }

        observer = NotificationCenter.default.addObserver(forName: .didFailDownload, object: nil, queue: .main) { [weak self] notification in
            self?.downloadFailed(sender: notification)
        }

        DownloadManager.shared.download(episode: episode) {
            cell.observeDownloadProgress(for: episode)
        }
    }

    private func indexPath(for identifier: String) -> IndexPath? {
        if let index = downloadIdentifiers.firstIndex(of: identifier) {
            return IndexPath(row: index, section: 0)
        }
        return nil
    }

    @objc func progressChanged(sender: Notification) {
        guard let dict = sender.userInfo,
            let progress = dict["progress"] as? Float,
            let url = dict["url"] as? URL,
            let indexPath = indexPath(for: url.absoluteString),
            let episode = episodesToDisplay?[indexPath.row]
            else { return }

        episode.downloadInfo?.setValue(progress, for: .progress)
    }

    @objc func downloadSucceeded(sender: Notification) {
        guard let dict = sender.userInfo,
            let url = dict["url"] as? URL,
            let indexPath = indexPath(for: url.absoluteString),
            let cell = episodeTableView.cellForRow(at: indexPath) as? EpisodeTableViewCell
            else { return }
        cell.utilityView.setDownloadStatus(DownloadInfoStatus.succeeded)
    }

    @objc func downloadFailed(sender: Notification) {
        guard let dict = sender.userInfo,
            let url = dict["url"] as? URL,
            let indexPath = indexPath(for: url.absoluteString),
            let cell = episodeTableView.cellForRow(at: indexPath) as? EpisodeTableViewCell
            else { return }
        cell.utilityView.setDownloadStatus(DownloadInfoStatus.failed)
    }

}
