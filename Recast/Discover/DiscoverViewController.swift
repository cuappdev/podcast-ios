//
//  DiscoverViewController.swift
//  Recast
//
//  Created by Jaewon Sim on 11/7/18.
//  Copyright © 2018 Cornell AppDev. All rights reserved.
//

import UIKit
import SnapKit

enum EpisodeDuration: String, CaseIterable {
    case asap = "Gotta Go ASAP"
    case moment = "A Moment to Spare"
    case relax = "Kick Back & Relax"
    case longRide = "In for a Long Ride"

    /// The range of the duration of the podcast, in minutes.
    ///
    /// - Returns: A tuple in the form of (inclusive lower bound, exclusive upper bound), i.e. [first,second).
    var durationRange: (Int, Int) {
        switch self {
        case .asap: return (10, 15)
        case .moment: return (20, 30)
        case .relax: return (40, 50)
        case .longRide: return (60, 90)
        }
    }

    var faceImage: UIImage {
        switch self {
        case .asap: return #imageLiteral(resourceName: "red")
        case .moment: return #imageLiteral(resourceName: "yellow")
        case .relax: return #imageLiteral(resourceName: "blue")
        case .longRide: return #imageLiteral(resourceName: "green")
        }
    }
}

class DiscoverViewController: UIViewController {

    // MARK: - Variables
    var titleLabel: UILabel!
    var durationSelectorCollectionView: UICollectionView!
    var durationSelectorPageControl: UIPageControl!

    let durationSelectorReuse = "durationSelectorReuse"

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black

        titleLabel = UILabel()
        titleLabel.text = "How much time do you have right now?"
        titleLabel.font = .systemFont(ofSize: 24, weight: .medium)
        titleLabel.textColor = .white
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.numberOfLines = 2
        view.addSubview(titleLabel)

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: view.frame.width, height: view.frame.width * 2/3)

        durationSelectorCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        durationSelectorCollectionView.delegate = self
        durationSelectorCollectionView.dataSource = self
        durationSelectorCollectionView.backgroundColor = .black
        durationSelectorCollectionView.showsVerticalScrollIndicator = false
        durationSelectorCollectionView.showsHorizontalScrollIndicator = false
        durationSelectorCollectionView.isPagingEnabled = true
        view.addSubview(durationSelectorCollectionView)

        durationSelectorCollectionView.register(DiscoverCollectionViewCell.self, forCellWithReuseIdentifier: durationSelectorReuse)

        durationSelectorPageControl = UIPageControl()
        durationSelectorPageControl.numberOfPages = durationSelectorCollectionView.numberOfItems(inSection: 0)
        view.addSubview(durationSelectorPageControl)

        setUpConstraints()
    }

    func setUpConstraints() {
        // MARK: Layout constants
        let searchBarTitleLabelHorizontalSpacing: CGFloat = 10.3
        let titleLabelCollectionViewHorizontalSpacing: CGFloat = 28.7
        let collectionViewPageControlVerticalSpacing: CGFloat = 12
        let titleLabelSideInset: CGFloat = 33
        let collectionViewHeight: CGFloat = 450

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(searchBarTitleLabelHorizontalSpacing)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(titleLabelSideInset)
        }

        durationSelectorCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(titleLabelCollectionViewHorizontalSpacing)
            make.height.equalTo(collectionViewHeight)
            make.leading.trailing.equalToSuperview()
        }

        durationSelectorPageControl.snp.makeConstraints { make in
            make.top.equalTo(durationSelectorCollectionView.snp.bottom).offset(collectionViewPageControlVerticalSpacing)
            make.centerX.equalTo(durationSelectorCollectionView)
        }
    }

}

// MARK: - CV Delegate
extension DiscoverViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollViewOffsetRatio = scrollView.contentOffset.x / scrollView.frame.width
        durationSelectorPageControl.currentPage = Int(scrollViewOffsetRatio)
    }

}

// MARK: - CV Data Source
extension DiscoverViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return EpisodeDuration.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // swiftlint:disable:next force_cast
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: durationSelectorReuse, for: indexPath) as! DiscoverCollectionViewCell
        cell.faceImageView.image = EpisodeDuration.allCases[indexPath.item].faceImage
        cell.durationDescriptionLabel.text = EpisodeDuration.allCases[indexPath.item].rawValue
        let durationRange = EpisodeDuration.allCases[indexPath.item].durationRange
        cell.minutesLabel.text = "\(durationRange.0) - \(durationRange.1) mins"
        return cell
    }
}
