//
//  HomeViewController.swift
//  Recast
//
//  Created by Jaewon Sim on 9/19/18.
//  Copyright © 2018 Cornell AppDev. All rights reserved.
//

import UIKit
import SnapKit

struct DummyPodcastSeries {
    let image: UIImage
    let title: String
    let date: String
    let duration: Int
    let timeLeft: Int

}

class HomeViewController: UIViewController {

    //dummy structs for testing
    let dummyContinue1 = DummyPodcastSeries(image: #imageLiteral(resourceName: "series_img_1"), title: "110: Asking All the Questions", date: "September 13, 2018", duration: 58, timeLeft: 10)
    let dummyContinue2 = DummyPodcastSeries(image: #imageLiteral(resourceName: "series_img_2"), title: "Dummy Podcast 2", date: "November 1st, 2018", duration: 10, timeLeft: 29)

    var homeTableView: UITableView!
    // Maps section/row index to the appropriate header type
    let headerTypes: [Int: HomeSectionType] = [
        0: .continueListening,
        1: .yourFavorites,
        2: .browseTopics
    ]

    /// Array of podcasts for the "continue listening" section
    var continuePodcasts: [DummyPodcastSeries] = [] {
        didSet {
            guard let cv = view.viewWithTag(100) as? UICollectionView else { return }
            cv.reloadData()
        }
    }

    /// Array of podcasts for the "your favorites" section
    var favoritePodcasts: [DummyPodcastSeries] = [] {
        didSet {
            guard let cv = view.viewWithTag(101) as? UICollectionView else { return }
            cv.reloadData()
        }
    }

    /// Array of podcasts for the "recommended for you" section
    var recommendedPodcasts: [DummyPodcastSeries] = [] {
        didSet {
            guard let cv = view.viewWithTag(102) as? UICollectionView else { return }
            cv.reloadData()
        }
    }

    // Table View reuse identifiers
    let continueTvReuse = "continueListeningTvReuse"
    let gridTvReuse = "gridTvReuse"

    // Collection View reuse identifiers
    let continueCvReuse = "continueListeningCvReuse"
    let gridCvReuse = "gridCvReuse"

    // MARK: - Lifecycle
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // VC settings
        title = "Home"
        view.backgroundColor = .black
        navigationController?.navigationBar.prefersLargeTitles = true

        // homeTableView
        homeTableView = UITableView(frame: .zero, style: .grouped)
        homeTableView.delegate = self
        homeTableView.dataSource = self
        homeTableView.allowsSelection = false
        homeTableView.backgroundColor = .black
        homeTableView.separatorColor = .black
        homeTableView.register(ContinueTableViewCell.self, forCellReuseIdentifier: continueTvReuse)
        homeTableView.register(SeriesGridTableViewCell.self, forCellReuseIdentifier: gridTvReuse)
        view.addSubview(homeTableView)

        prepareDummy()
        setUpConstraints()
    }

    func setUpConstraints() {
        homeTableView.snp.makeConstraints { (make) -> Void in
            make.edges.equalToSuperview()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func prepareDummy() {
        continuePodcasts.append(dummyContinue1)
        continuePodcasts.append(dummyContinue2)
        favoritePodcasts.append(dummyContinue1)
        favoritePodcasts.append(dummyContinue2)
        recommendedPodcasts.append(dummyContinue1)
        recommendedPodcasts.append(dummyContinue2)
    }
}

// MARK: - TV Delegate
extension HomeViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = HomeTableViewHeaderView()
        if let sectionType = headerTypes[section] {
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

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            // Set delegate and data source of the continue listening CV to this view controller
            guard let tvCell = cell as? ContinueTableViewCell else { return }
            tvCell.configure(withDelegate: self, dataSource: self, tag: 100 + indexPath.section)
        case 1, 2:
            guard let tvCell = cell as? SeriesGridTableViewCell else { return }
            tvCell.configure(withDelegate: self, dataSource: self, tag: 100 + indexPath.section)
        default:
            break
        }
    }
}

// MARK: - TV Data Source
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            // swiftlint:disable:next force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: continueTvReuse) as!
                ContinueTableViewCell
            return cell
        case 1:
            // swiftlint:disable:next force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: gridTvReuse) as!
                SeriesGridTableViewCell
            return cell
        case 2:
            // swiftlint:disable:next force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: gridTvReuse) as!
                SeriesGridTableViewCell
            return cell
        default:
            return UITableViewCell(frame: .zero)
        }
    }

}

// MARK: - CV Delegate
extension HomeViewController: UICollectionViewDelegate {
}

// MARK: - CV Data Source
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case 100: // continue listening
            return continuePodcasts.count
        case 101: // your favorites
            return favoritePodcasts.count
        case 102: // recommended for you
            return recommendedPodcasts.count
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView.tag {
        case 100: // continue listening
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: continueCvReuse, for: indexPath) as! ContinueCollectionViewCell
            cell.configure(withDummy: continuePodcasts[indexPath.item])
            return cell
        case 101: // your favorites
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: gridCvReuse, for: indexPath) as! SeriesGridCollectionViewCell
            cell.configure(withDummy: favoritePodcasts[indexPath.item])
            return cell
        case 102: // recommended for you
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: gridCvReuse, for: indexPath) as! SeriesGridCollectionViewCell
            cell.configure(withDummy: recommendedPodcasts[indexPath.item])
            return cell
        default:
            return UICollectionViewCell(frame: .zero)
        }
    }
}
