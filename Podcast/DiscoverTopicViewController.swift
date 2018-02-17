//
//  DiscoverTopicViewController.swift
//  Podcast
//
//  Created by Mindy Lou on 2/17/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import UIKit

class DiscoverTopicViewController: DiscoverComponentViewController {

    var topicImageView: UIImageView!
    var relatedTopicsView: TrendingTopicsView!
    var newEpisodesCollectionView: UICollectionView!
    var topSeriesCollectionView: UICollectionView!

    let episodesReuseIdentifier = "episodes"
    let seriesReuseIdentifier = "series"
    let headerReuseIdentifier = "header"
    let episodesHeaderTag = 1
    let seriesHeaderTag = 2
    let collectionViewHeight: CGFloat = 200
    let imageViewHeight: CGFloat = 72
    let relatedTopicsHeight: CGFloat = 150

    var relatedTopics = [Topic]()
    var newEpisodes = [Episode]()
    var topSeries = [Series]()

    var topic: Topic!

    convenience init(topic: Topic) {
        self.init()
        self.topic = topic
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        topicImageView = UIImageView(frame: .zero)
        topicImageView.contentMode = .scaleAspectFill
        contentView.addSubview(topicImageView)
        topicImageView.snp.makeConstraints { make in
            make.top.leading.trailing.width.equalToSuperview()
            make.height.equalTo(imageViewHeight)
        }

        relatedTopicsView = TrendingTopicsView(frame: .zero, type: .related)
        relatedTopicsView.isUserInteractionEnabled = true
        relatedTopicsView.dataSource = self
        relatedTopicsView.delegate = self
        contentView.addSubview(relatedTopicsView)
        relatedTopicsView.snp.makeConstraints { make in
            make.top.equalTo(topicImageView.snp.bottom)
            make.width.leading.trailing.equalToSuperview()
            make.height.greaterThanOrEqualTo(relatedTopicsHeight)
        }

        newEpisodesCollectionView = createCollectionView(with: .discover)
        newEpisodesCollectionView.register(DiscoverCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier)
        newEpisodesCollectionView.register(SeriesGridCollectionViewCell.self, forCellWithReuseIdentifier: episodesReuseIdentifier)
        newEpisodesCollectionView.delegate = self
        newEpisodesCollectionView.dataSource = self
        newEpisodesCollectionView.snp.makeConstraints { make in
            make.width.leading.trailing.equalToSuperview()
            make.height.equalTo(collectionViewHeight)
            make.top.equalTo(relatedTopicsView.snp.bottom)
        }

        topSeriesCollectionView = createCollectionView(with: .discover)
        topSeriesCollectionView.register(DiscoverCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier)
        topSeriesCollectionView.register(SeriesGridCollectionViewCell.self, forCellWithReuseIdentifier: episodesReuseIdentifier)
        topSeriesCollectionView.delegate = self
        topSeriesCollectionView.dataSource = self
        topSeriesCollectionView.snp.makeConstraints { make in
            make.width.leading.trailing.equalToSuperview()
            make.height.equalTo(collectionViewHeight)
            make.top.equalTo(newEpisodesCollectionView.snp.bottom)
            make.bottom.equalToSuperview()
        }
        configureTopic()
    }

    func configureTopic() {
        relatedTopics = [Topic(name: "Arts"), Topic(name:"Business"), Topic(name:"Government & Organizations"), Topic(name:"Religion & Spirituality"), Topic(name: "Kids & Family"), Topic(name: "Technology")]
        let s = Series()
        s.title = "Design Details"
        topSeries = [s, s, s, s, s]
        let e = Episode()
        e.seriesTitle = s.title
        e.title = "Episode"
        newEpisodes = [e, e, e, e, e]
        guard let id = topic.id else { return }

        let topEpisodesForTopicEndpointRequest = DiscoverTopicEndpointRequest(requestType: .episodes, topicID: id)
        topEpisodesForTopicEndpointRequest.success = { response in
            guard let episodes = response.processedResponseValue as? [Episode] else { return }
            self.newEpisodes = episodes
            self.newEpisodesCollectionView.reloadData()
        }

        let topSeriesForTopicEndpointRequest = DiscoverTopicEndpointRequest(requestType: .series, topicID: id)
        topSeriesForTopicEndpointRequest.success = { response in
            guard let series = response.processedResponseValue as? [Series] else { return }
            self.topSeries = series
            self.topSeriesCollectionView.reloadData()
        }

        System.endpointRequestQueue.addOperation(topEpisodesForTopicEndpointRequest)
        System.endpointRequestQueue.addOperation(topSeriesForTopicEndpointRequest)

        if let topicType = TopicType(rawValue: topic.name) {
            topicImageView.image = topicType.headerImage // todo: update this with assets
        }
    }
}

// MARK: - RelatedTopicsHeader
extension DiscoverTopicViewController: TopicsCollectionViewDataSource, TrendingTopicsViewDelegate {
    func topicForCollectionViewCell(collectionView: UICollectionView, dataForItemAt index: Int) -> Topic {
        return relatedTopics[index]
    }

    func numberOfTopics(collectionView: UICollectionView) -> Int {
        return relatedTopics.count
    }

    func trendingTopicsView(trendingTopicsView: TrendingTopicsView, didSelectItemAt indexPath: IndexPath) {
        let discoverTopicViewController = DiscoverTopicViewController(topic: relatedTopics[indexPath.row])
        navigationController?.pushViewController(discoverTopicViewController, animated: true)
    }
}

// MARK: - Collection View
extension DiscoverTopicViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case newEpisodesCollectionView:
            return newEpisodes.count
        case topSeriesCollectionView:
            return topSeries.count
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: episodesReuseIdentifier, for: indexPath) as? SeriesGridCollectionViewCell else { return UICollectionViewCell() }
        switch collectionView {
        case newEpisodesCollectionView:
            cell.configureForEpisode(episode: newEpisodes[indexPath.row])
        case topSeriesCollectionView:
            cell.configureForSeries(series: topSeries[indexPath.row])
        default:
            break
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case newEpisodesCollectionView:
            let episodeDetailViewController = EpisodeDetailViewController()
            episodeDetailViewController.episode = newEpisodes[indexPath.row]
            navigationController?.pushViewController(episodeDetailViewController, animated: true)
        case topSeriesCollectionView:
            let seriesDetailViewController = SeriesDetailViewController()
            seriesDetailViewController.series = topSeries[indexPath.row]
            navigationController?.pushViewController(seriesDetailViewController, animated: true)
        default:
            break
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier, for: indexPath) as? DiscoverCollectionViewHeader else { return DiscoverCollectionViewHeader() }
        header.delegate = self
        switch collectionView {
        case newEpisodesCollectionView:
            header.tag = episodesHeaderTag
            header.configure(sectionType: .episodes)
        case topSeriesCollectionView:
            header.tag = seriesHeaderTag
            header.configure(sectionType: .series)
        default:
            break
        }
        return header
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 0)
    }

}

extension DiscoverTopicViewController: DiscoverTableViewHeaderDelegate {
    func discoverTableViewHeaderDidPressBrowse(sender: DiscoverCollectionViewHeader) {
        switch sender.tag {
        case seriesHeaderTag:
            let vc = BrowseSeriesViewController()
            vc.series = topSeries
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }


}
