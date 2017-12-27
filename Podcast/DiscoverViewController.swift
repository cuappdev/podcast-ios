//
//  DiscoverViewController.swift
//  Podcast
//
//  Created by Mindy Lou on 11/20/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class DiscoverViewController: ViewController {

    var scrollView: ScrollView!
    var stackView: UIStackView!
    var trendingTopicsView: TrendingTopicsView!
    var topTopicsCollectionView: UICollectionView!
    var topSeriesCollectionView: UICollectionView!

    let trendingTopicsViewHeight: CGFloat = 150
    let topSeriesViewHeight: CGFloat = 168

    let topTopicsReuseIdentifier = "topTopics"
    let topSeriesReuseIdentifier = "topSeries"
    let topSeriesHeaderReuseIdentifier = "topSeriesHeader"
    let topicsHeaderTag = 1
    let seriesHeaderTag = 2

    // todo: top topics
    var trendingTopics = [Topic]()
    var topSeries = [Series]()
    var topEpisodes = [Episode]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .paleGrey
        title = "Discover"
        edgesForExtendedLayout = []

        scrollView = ScrollView(frame: view.frame)

        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.width.height.leading.trailing.equalToSuperview()
        }
        mainScrollView = scrollView

        trendingTopicsView = TrendingTopicsView()
        trendingTopicsView.delegate = self
        trendingTopicsView.dataSource = self

        topTopicsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: RecommendedSeriesCollectionViewFlowLayout())
        topTopicsCollectionView.backgroundColor = .paleGrey
        topTopicsCollectionView.delegate = self
        topTopicsCollectionView.dataSource = self
        topTopicsCollectionView.showsHorizontalScrollIndicator = false
        topTopicsCollectionView.register(DiscoverCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: topSeriesHeaderReuseIdentifier)
        topTopicsCollectionView.register(TopicsGridCollectionViewCell.self, forCellWithReuseIdentifier: topTopicsReuseIdentifier)

        topSeriesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: RecommendedSeriesCollectionViewFlowLayout())
        topSeriesCollectionView.backgroundColor = .paleGrey
        topSeriesCollectionView.delegate = self
        topSeriesCollectionView.dataSource = self
        topSeriesCollectionView.showsHorizontalScrollIndicator = false
        topSeriesCollectionView.register(DiscoverCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: topSeriesHeaderReuseIdentifier)
        topSeriesCollectionView.register(SeriesGridCollectionViewCell.self, forCellWithReuseIdentifier: topSeriesReuseIdentifier)

        stackView = UIStackView(arrangedSubviews: [trendingTopicsView, topTopicsCollectionView, topSeriesCollectionView])
        stackView.distribution = .fillProportionally
        stackView.axis = .vertical
        scrollView.addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.height.equalToSuperview()
        }

        trendingTopicsView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(trendingTopicsViewHeight)
        }

        topTopicsCollectionView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.greaterThanOrEqualTo(trendingTopicsViewHeight)
        }

        topSeriesCollectionView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.greaterThanOrEqualTo(topSeriesViewHeight)
        }

        trendingTopics = [Topic(name: "Arts"), Topic(name:"Business"), Topic(name:"Comedy"), Topic(name:"Religion & Spirituality")]
        let s = Series()
        s.title = "Design Details"
        topSeries = [s, s, s, s, s]
    }

}

extension DiscoverViewController: TrendingTopicsViewDelegate, TopicsCollectionViewDataSource {
    func topicForCollectionViewCell(collectionView: UICollectionView, dataForItemAt index: Int) -> Topic {
        return trendingTopics[index]
    }

    func numberOfTopics(collectionView: UICollectionView) -> Int {
        return trendingTopics.count
    }

    func trendingTopicsView(trendingTopicsView: TrendingTopicsView, didSelectItemAt indexPath: IndexPath) {
        
    }

}

extension DiscoverViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case topTopicsCollectionView:
            return trendingTopics.count
        case topSeriesCollectionView:
            return topSeries.count
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case topTopicsCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: topTopicsReuseIdentifier, for: indexPath) as? TopicsGridCollectionViewCell else { return TopicsGridCollectionViewCell() }
            cell.configure(for: trendingTopics[indexPath.row])
            return cell
        case topSeriesCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: topSeriesReuseIdentifier, for: indexPath) as? SeriesGridCollectionViewCell else { return SeriesGridCollectionViewCell() }
            cell.configureForSeries(series: topSeries[indexPath.row])
            return cell
        default:
            return UICollectionViewCell()
        }

    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: topSeriesHeaderReuseIdentifier, for: indexPath) as? DiscoverCollectionViewHeader else { return DiscoverCollectionViewHeader() }
        header.delegate = self
        switch collectionView {
        case topTopicsCollectionView:
            header.tag = topicsHeaderTag
            header.configure(sectionName: "Topics")
            return header
        case topSeriesCollectionView:
            header.tag = seriesHeaderTag
            header.configure(sectionName: "Series")
            return header
        default:
            return header
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 0)
    }

}

extension DiscoverViewController: DiscoverTableViewHeaderDelegate {

    func discoverTableViewHeaderDidPressBrowse(sender: DiscoverCollectionViewHeader) {
        switch sender.tag {
        case topicsHeaderTag:
            let vc = TopicsViewController()
            vc.topics = trendingTopics
            navigationController?.pushViewController(vc, animated: true)
        case seriesHeaderTag:
            print("Browse series")
        default:
            print("error")
        }
    }

}
