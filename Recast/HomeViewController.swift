//
//  HomeViewController.swift
//  Recast
//
//  Created by Jaewon Sim on 9/19/18.
//  Copyright © 2018 Cornell AppDev. All rights reserved.
//

import UIKit
import SnapKit

enum HomeSubsection: String, CaseIterable {
    enum IdentifierType {
        case tag
        case homeCollectionViewSection
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

    /// Returns for the row of `homeCollectionView` that corresponds to the `HomeSubsection`
    var homeCollectionViewSection: Int? {
        switch self {
        case .continueListening:
            return 0
        case .yourFavorites:
            return 1
        case .browseTopics:
            return 2
        }
    }

    /// The HomeSubsection for the corresponding tag or section value of the homeCollectionView.
    ///
    /// - Parameters:
    ///   - identifier: Indicates if `value` is the `tag` or `homeCollectionViewSection`
    ///   - value: The `tag` or `homeCollectionViewSection`
    /// - Returns: The HomeSubsection for the corresponding tag or section
    static func homeSubsection(for identifier: IdentifierType, value: Int) -> HomeSubsection? {
        var section: Int = value
        if identifier == .tag {
            section = value - 100
        }
        switch section {
        case 0:
            return .continueListening //100
        case 1:
            return .yourFavorites //102
        case 2:
            return .browseTopics //103
        default:
            return nil
        }
    }
}

class HomeViewController: ViewController {

    /// Returns if the given indexPath section is that of the last section in the homeCollectionView (i.e. subscriptions)
    ///
    /// - Parameter section: indexPath section to determine for
    /// - Returns: if the given indexPath section is that of the last section in the homeCollectionView
    func isLastSection(_ section: Int) -> Bool {
        return section == HomeSubsection.allCases.count
    }

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
        subscriptions.append(dummyContinue1)
        subscriptions.append(dummyContinue2)
        subscriptions.append(dummyContinue1)
        subscriptions.append(dummyContinue2)
        subscriptions.append(dummyContinue1)
        subscriptions.append(dummyContinue2)
    }

    /// Array of podcasts for the "continue listening" section
    var continuePodcasts: [DummyPodcastSeries] = [] {
        didSet {
            guard let cv = view.viewWithTag(HomeSubsection.continueListening.tag) as? UICollectionView else { return }
            cv.reloadData()
        }
    }

    /// Array of podcasts for the "your favorites" section
    var favoritePodcasts: [DummyPodcastSeries] = [] {
        didSet {
            guard let cv = view.viewWithTag(HomeSubsection.yourFavorites.tag) as? UICollectionView else { return }
            cv.reloadData()
        }
    }

    /// Array of podcasts for the "browse" section
    var browsePodcasts: [DummyPodcastSeries] = [] {
        didSet {
            guard let cv = view.viewWithTag(HomeSubsection.browseTopics.tag) as? UICollectionView else { return }
            cv.reloadData()
        }
    }

    /// Array of podcasts for the "subscriptions" at the bottom of the home cv
    var subscriptions: [DummyPodcastSeries] = []

    // MARK: View vars
    var homeCollectionView: UICollectionView!

    // MARK: TV and CV reuse identifiers
    /// Reuse identifier for the parent cv that contains the "continue listening" cells
    let homeContinueCvReuse = "homeContinueCvReuse"
    /// Reuse identifier for the individual "continue listening" cells
    let continueCvReuse = "continueListeningCvReuse"

    /// Reuse identifier for the parent cv that contains the grid cells
    let homeGridCvReuse = "homeGridCvReuse"
    /// Reuse identifier for the individual grid cells (e.g. for subscriptions)
    let gridCvReuse = "gridCvReuse"

    /// Reuse identifier for the supplementary views (cv header) for the HomeCollectionView
    let homeHeaderReuse = "homeHeaderReuse"

    // MARK: Collection View Sizes and Insets
    let minimumInteritemSpacing: CGFloat = 8
    let sideInset: CGFloat = 22

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // VC settings
        navigationItem.title = "Home"
        view.backgroundColor = .black

        let addBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didPressAdd))
        navigationItem.rightBarButtonItems = [addBarButtonItem]

        let headerSize = CGSize(width: view.frame.size.width, height: 61)

        //setup flow layout using layout constants above
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.headerReferenceSize = headerSize
        layout.minimumInteritemSpacing = minimumInteritemSpacing

        homeCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        homeCollectionView.delegate = self
        homeCollectionView.dataSource = self
        homeCollectionView.backgroundColor = .black
        homeCollectionView.showsVerticalScrollIndicator = false
        homeCollectionView.showsHorizontalScrollIndicator = false
        view.addSubview(homeCollectionView)

        homeCollectionView.register(HomePodcastGridCollectionViewCell.self, forCellWithReuseIdentifier: homeGridCvReuse)
        homeCollectionView.register(HomeContinueListeningCollectionViewCell.self, forCellWithReuseIdentifier: homeContinueCvReuse)
        homeCollectionView.register(PodcastGridCollectionViewCell.self, forCellWithReuseIdentifier: gridCvReuse)
        homeCollectionView.register(HomeCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: homeHeaderReuse)

        mainScrollView = homeCollectionView

        prepareDummy()
        setUpConstraints()
    }

    func setUpConstraints() {
        homeCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    @objc func didPressAdd() {
        self.navigationController?.pushViewController(MainSearchViewController(), animated: true)
    }
}

// MARK: - CV Delegate
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let type = HomeSubsection.homeSubsection(for: .tag, value: collectionView.tag)!
        switch type {
        case .continueListening:
            break
        case .yourFavorites:
            break
        case .browseTopics:
            break
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let totalMargins = view.safeAreaInsets.left + view.safeAreaInsets.right + sideInset * 2
        let width = (view.frame.width - totalMargins -  minimumInteritemSpacing*2)/3

        let gridItemSize = CGSize(width: width, height: width)
        let continueListeningItemSize = CGSize(width: 310, height: 108)
        let fullWidthCvItemSize = CGSize(width: view.frame.size.width, height: 108)

        if collectionView == homeCollectionView {
            if isLastSection(indexPath.section) {
                return gridItemSize
            } else {
                return fullWidthCvItemSize
            }
        }

        if let subsection = HomeSubsection.homeSubsection(for: .tag, value: collectionView.tag) {
            switch subsection {
            case .yourFavorites, .browseTopics:
                return gridItemSize
            case .continueListening:
                return continueListeningItemSize
            }
        }
        return .zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        let collectionViewSideInset = UIEdgeInsets(top: 0, left: sideInset, bottom: 0, right: sideInset)

        if collectionView == homeCollectionView && isLastSection(section) || HomeSubsection.homeSubsection(for: .tag, value: collectionView.tag) != nil {
            return collectionViewSideInset
        }
        return .zero
    }
}

// MARK: - CV Data Source
extension HomeViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == homeCollectionView {
            return HomeSubsection.allCases.count + 1 //+1 accounts for the last section for subscriptions
        }
        return 1 //All of the sub-collection-views have a single section
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == homeCollectionView {
            if isLastSection(section) {
                return subscriptions.count
            }
            return 1 //sub-collection-views should have a single item (the corresponding cv-containing cell) inside them
        }
        let type = HomeSubsection.homeSubsection(for: .tag, value: collectionView.tag)!
        switch type {
        case .continueListening:
            return continuePodcasts.count
        case .yourFavorites:
            return favoritePodcasts.count
        case .browseTopics:
            return browsePodcasts.count
        }
    }

    // swiftlint:disable:next function_body_length
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        // Setup for top-level homeCollectionView - this sets the corresponding cv's tag, delegate, and dataSource
        if collectionView == homeCollectionView {

            guard let sectionType = HomeSubsection.homeSubsection(for: .homeCollectionViewSection, value: indexPath.section) else {
                //subscriptions
                // swiftlint:disable:next force_cast
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: gridCvReuse, for: indexPath) as! PodcastGridCollectionViewCell
                let subscriptionsDummy = subscriptions[indexPath.item]
                cell.seriesImageView.image = subscriptionsDummy.image
                cell.newStickerView.isHidden = !subscriptionsDummy.isNew
                return cell
            }
            let cvTag = sectionType.tag

            switch sectionType {
            //continue listening
            case .continueListening:
                // swiftlint:disable:next force_cast
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: homeContinueCvReuse, for: indexPath) as! HomeContinueListeningCollectionViewCell
                cell.collectionView.delegate = self
                cell.collectionView.dataSource = self
                cell.collectionView.tag = cvTag
                cell.collectionView.reloadData()
                return cell

            //your favorites and browse topics
            case .yourFavorites, .browseTopics:
                // swiftlint:disable:next force_cast
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: homeGridCvReuse, for: indexPath) as! HomePodcastGridCollectionViewCell
                cell.collectionView.delegate = self
                cell.collectionView.dataSource = self
                cell.collectionView.tag = cvTag
                cell.collectionView.reloadData()
                return cell
            }
        }

        let type = HomeSubsection.homeSubsection(for: .tag, value: collectionView.tag)!

        switch type {
        // Setup for sub-collection-views
        case .continueListening:
            let continueDummy = continuePodcasts[indexPath.item]
            // swiftlint:disable:next force_cast
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: continueCvReuse, for: indexPath) as! ContinueListeningCollectionViewCell
            // setup CV cell
            cell.podcastImageView.image = continueDummy.image
            cell.podcastLabel.text = continueDummy.podcastTitle
            cell.titleLabel.text = continueDummy.episodeTitle
            cell.detailLabel.text = "\(continueDummy.date) · \(continueDummy.duration) min"
            cell.timeLeftLabel.text = "\(continueDummy.timeLeft) minutes left"
            return cell

        case .yourFavorites:
            let favoritesDummy = favoritePodcasts[indexPath.item]
            // swiftlint:disable:next force_cast
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: gridCvReuse, for: indexPath) as! PodcastGridCollectionViewCell
            cell.seriesImageView.image = favoritesDummy.image
            cell.newStickerView.isHidden = !favoritesDummy.isNew
            return cell

        case .browseTopics:
            let browseDummy = browsePodcasts[indexPath.item]
            // swiftlint:disable:next force_cast
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: gridCvReuse, for: indexPath) as! PodcastGridCollectionViewCell
            cell.seriesImageView.image = browseDummy.image
            cell.newStickerView.isHidden = !browseDummy.isNew
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            // swiftlint:disable:next force_cast
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: homeHeaderReuse, for: indexPath) as! HomeCollectionViewHeader
            if isLastSection(indexPath.section) {
                header.headerTitleLabel.text = "Subscriptions"
            } else {
                header.headerTitleLabel.text = HomeSubsection.allCases[indexPath.section].rawValue
            }
            return header

        default:
            return UICollectionReusableView()
        }

    }

}
