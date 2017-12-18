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
    var trendingTopicsView: TrendingTopicsView!
    var recommendedSeriesCollectionView: SeriesCollectionView!

    let trendingTopicsViewHeight: CGFloat = 134
    let recommendedSeriesViewHeight: CGFloat = 150

    // todo: top topics
    var trendingTopics = [Topic]()
    var topSeries = [Series]()
    var topEpisodes = [Episode]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .paleGrey
        title = "Discover"

        scrollView = ScrollView(frame: view.frame)
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.width.height.equalToSuperview()
        }
        mainScrollView = scrollView

        trendingTopicsView = TrendingTopicsView(frame: .zero)
        trendingTopicsView.delegate = self
        scrollView.add(customView: trendingTopicsView, height: trendingTopicsViewHeight)
        trendingTopicsView.snp.makeConstraints { make in
            make.width.top.equalToSuperview()
            make.height.equalTo(trendingTopicsViewHeight)
        }

        recommendedSeriesCollectionView = SeriesCollectionView(frame: .zero)
        recommendedSeriesCollectionView.collectionViewDelegate = self
        recommendedSeriesCollectionView.collectionViewDataSource = self
        scrollView.add(collectionView: recommendedSeriesCollectionView, height: recommendedSeriesViewHeight)
        recommendedSeriesCollectionView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(recommendedSeriesViewHeight)
            make.top.equalTo(trendingTopicsView.snp.bottom)
        }

    }

}

extension DiscoverViewController: TrendingTopicsViewDelegate, TopicsCollectionViewDataSource {
    func topicForCollectionViewCell(collectionView: UICollectionView, dataForItemAt index: Int) -> Topic {
        return Topic(name: "placeholder topic")
    }

    func numberOfTopics(collectionView: UICollectionView) -> Int {
        return trendingTopics.count
    }

    func trendingTopicsView(trendingTopicsView: TrendingTopicsView, didSelectItemAt indexPath: IndexPath) {
        
    }

}

extension DiscoverViewController: SeriesCollectionViewDelegate, SeriesCollectionViewDataSource {
    func seriesCollectionView(collectionView: SeriesCollectionView, didSelectItemAt indexPath: IndexPath) {

    }

    func seriesCollectionView(seriesCollectionView: SeriesCollectionView, dataForItemAt indexPath: IndexPath) -> Series {
        return Series()
    }

    func numberOfRecommendedSeries(forSeriesCollectionView: SeriesCollectionView) -> Int {
        return topSeries.count
    }
}
