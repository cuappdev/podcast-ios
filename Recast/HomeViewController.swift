//
//  HomeViewController.swift
//  Recast
//
//  Created by Jaewon Sim on 9/19/18.
//  Copyright © 2018 Cornell AppDev. All rights reserved.
//

import UIKit
import SnapKit

enum HomeSectionType: String, CaseIterable {
    enum IdentifierType {
        case section
        case tag
    }

    case continueListening = "Continue Listening"
    case yourFavorites = "Your Favorites"
    case browseTopics = "Browse Topics"

    var tag: Int {
        switch self {
        case .continueListening:
            return 100
        case .yourFavorites:
            return 101
        case .browseTopics:
            return 102
        }
    }

    /// The HomeSectionType for the corresponding tag or section value of the HomeTableView.
    ///
    /// - Parameters:
    ///   - identifier: Indicates if `value` is the `int` for `section` or `tag`
    ///   - value: The `int` value of the `section` or `tag`
    /// - Returns: The HomeSectionType for the corresponding tag or section value of the HomeTableView
    static func type(for identifier: IdentifierType, value: Int) -> HomeSectionType? {
        var section: Int? = value
        if identifier == .tag {
            section = value - 100
        }
        switch section {
        case 0:
            return .continueListening
        case 1:
            return .yourFavorites
        case 2:
            return .browseTopics
        default:
            return nil
        }
    }
}

class HomeViewController: UIViewController {

    // MARK: Create dummy structs for testing
    let dummyContinue1 = DummyPodcastSeries(
            image: #imageLiteral(resourceName: "series_img_1"),
            podcastTitle: "Spec",
            episodeTitle: "110: Asking All the Questions",
            date: "September 13, 2018",
            duration: 58,
            timeLeft: 10,
            isNew: true)

    let dummyContinue2 = DummyPodcastSeries(
        image: #imageLiteral(resourceName: "series_img_2"),
        podcastTitle: "Spec",
        episodeTitle: "Dummy Podcast 2",
        date: "November 1st, 2018",
        duration: 10,
        timeLeft: 29)

    func prepareDummy() {
        continuePodcasts.append(dummyContinue1)
        continuePodcasts.append(dummyContinue2)
        favoritePodcasts.append(dummyContinue1)
        favoritePodcasts.append(dummyContinue2)
        browsePodcasts.append(dummyContinue1)
        browsePodcasts.append(dummyContinue2)
        browsePodcasts.append(dummyContinue1)
        browsePodcasts.append(dummyContinue2)
        browsePodcasts.append(dummyContinue1)
        browsePodcasts.append(dummyContinue2)
    }

    /// Array of podcasts for the "continue listening" section
    var continuePodcasts: [DummyPodcastSeries] = [] {
        didSet {
            guard let cv = view.viewWithTag(HomeSectionType.continueListening.tag) as? UICollectionView else { return }
            cv.reloadData()
        }
    }

    /// Array of podcasts for the "your favorites" section
    var favoritePodcasts: [DummyPodcastSeries] = [] {
        didSet {
            guard let cv = view.viewWithTag(HomeSectionType.yourFavorites.tag) as? UICollectionView else { return }
            cv.reloadData()
        }
    }

    /// Array of podcasts for the "browse" section
    var browsePodcasts: [DummyPodcastSeries] = [] {
        didSet {
            guard let cv = view.viewWithTag(HomeSectionType.browseTopics.tag) as? UICollectionView else { return }
            cv.reloadData()
        }
    }

    // MARK: View vars
    var homeTableView: UITableView!
    var headerView: HomeTableViewHeaderView?

    // MARK: TV and CV reuse identifiers
    let continueTvReuse = "continueListeningTvReuse"
    let gridTvReuse = "gridTvReuse"
    let continueCvReuse = "continueListeningCvReuse"
    let gridCvReuse = "gridCvReuse"

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // VC settings
        title = "Home"
        view.backgroundColor = .black

        let addBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didPressAdd))
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItems = [addBarButtonItem]

        // homeTableView
        homeTableView = UITableView(frame: .zero, style: .grouped)
        homeTableView.delegate = self
        homeTableView.dataSource = self
        homeTableView.allowsSelection = false
        homeTableView.backgroundColor = .black
        homeTableView.separatorColor = .black
        homeTableView.register(ContinueListeningTableViewCell.self, forCellReuseIdentifier: continueTvReuse)
        homeTableView.register(PodcastGridTableViewCell.self, forCellReuseIdentifier: gridTvReuse)
        view.addSubview(homeTableView)

        prepareDummy()
        setUpConstraints()
    }

    func setUpConstraints() {
        homeTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    @objc func didPressAdd() {
        self.navigationController?.pushViewController(MainSearchViewController(), animated: true)
    }
}

// MARK: - HomeTableViewHeaderViewDelegate
extension HomeViewController: HomeTableViewHeaderViewDelegate {
    func homeTableViewHeaderView(_ tableHeader: HomeTableViewHeaderView, didPress: Action) {
        if tableHeader == headerView {
            switch didPress {
            case .seeAll:
                print("Pressed see all")
            }
        }
    }
}

// MARK: - TV Delegate
extension HomeViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return HomeSectionType.allCases.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = HomeTableViewHeaderView()
        if let sectionType = HomeSectionType.type(for: .section, value: section) {
            headerView.configure(for: sectionType)
        }
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 108
    }
}

// MARK: - TV Data Source
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewTag = HomeSectionType.type(for: .section, value: indexPath.section)!.tag
        switch indexPath.section {
        case 0:
            // swiftlint:disable:next force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: continueTvReuse) as! ContinueListeningTableViewCell
            cell.collectionView.delegate = self
            cell.collectionView.dataSource = self
            cell.collectionView.tag = viewTag
            cell.collectionView.reloadData()
            return cell
        case 1, 2:
            // swiftlint:disable:next force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: gridTvReuse) as! PodcastGridTableViewCell
            cell.collectionView.delegate = self
            cell.collectionView.dataSource = self
            cell.collectionView.tag = viewTag
            cell.collectionView.reloadData()
            return cell
        default:
            return UITableViewCell(frame: .zero)
        }
    }

}

// MARK: - CV Delegate
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let type = HomeSectionType.type(for: .tag, value: collectionView.tag)!
        switch type {
        case .continueListening:
            break
        case .yourFavorites:
            break
        case .browseTopics:
            break
        }
    }
}

// MARK: - CV Data Source
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let type = HomeSectionType.type(for: .tag, value: collectionView.tag)!
        switch type {
        case .continueListening:
            return continuePodcasts.count
        case .yourFavorites:
            return favoritePodcasts.count
        case .browseTopics:
            return browsePodcasts.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type = HomeSectionType.type(for: .tag, value: collectionView.tag)!
        switch type {
        case .continueListening:
            let continueDummy = continuePodcasts[indexPath.item]
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: continueCvReuse,
                // swiftlint:disable:next force_cast
                for: indexPath) as!
                ContinueListeningCollectionViewCell
            // setup CV cell
            cell.podcastImageView.image = continueDummy.image
            cell.podcastLabel.text = continueDummy.podcastTitle
            cell.titleLabel.text = continueDummy.episodeTitle
            cell.detailLabel.text = "\(continueDummy.date) · \(continueDummy.duration) min"
            cell.timeLeftLabel.text = "\(continueDummy.timeLeft) minutes left"
            return cell
        case .yourFavorites:
            let favoritesDummy = favoritePodcasts[indexPath.item]
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: gridCvReuse,
                // swiftlint:disable:next force_cast
                for: indexPath) as!
                PodcastGridCollectionViewCell
            cell.seriesImageView.image = favoritesDummy.image
            cell.newStickerView.isHidden = !favoritesDummy.isNew
            return cell
        case .browseTopics:
            let browseDummy = browsePodcasts[indexPath.item]
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: gridCvReuse,
                // swiftlint:disable:next force_cast
                for: indexPath) as!
                PodcastGridCollectionViewCell
            cell.seriesImageView.image = browseDummy.image
            cell.newStickerView.isHidden = !browseDummy.isNew
            return cell
        }
    }
}
