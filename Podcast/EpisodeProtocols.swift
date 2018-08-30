//
//  EpisodeDataSource.swift
//  Podcast
//
//  Created by Drew Dunne on 7/16/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import UIKit

protocol EpisodeCellDelegate {
    func handle(action: EpisodeAction, for episode: Episode)
}

class EpisodeDisplayCell: UITableViewCell {
    // can be itself
    weak var displayView: EpisodeDisplayView!
}

protocol EpisodeDisplayView: class {
    func set(title: String)
    func set(description: String)
    func set(dateCreated: String)
    func set(seriesTitle: String)
    func set(smallImageUrl: URL)
    func set(largeImageUrl: URL)
    func set(topics: [String])
    func set(duration: String)
    
    func set(isPlaying: Bool)
    func set(isPlayable: Bool)
    
    func set(isBookmarked: Bool)
    
    func set(isRecasted: Bool)
    func set(recastBlurb: String)
    func set(numberOfRecasts: Int)
    
    func set(downloadStatus: DownloadStatus)
}

class EpisodeTableDataSource: NSObject {
    
    // Can later adapt this to multiple cell types (like series and episodes)
    private var sections: Int = 1
    var identifier: String = "my_cell"
    private var data: [Episode]
    
    init(_ episodes: [Episode]) {
        data = episodes
        super.init()
    }
}

extension EpisodeTableDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! EpisodeDisplayCell
        let episode = data[indexPath.row]
        cell.displayView.set(title: episode.title)
        cell.displayView.set(description: episode.descriptionText)
        cell.displayView.set(dateCreated: episode.dateString())
        cell.displayView.set(seriesTitle: episode.seriesTitle)
        cell.displayView.set(title: episode.title)
        if let url = episode.smallArtworkImageURL {
            cell.displayView.set(smallImageUrl: url)
        }
        if let url = episode.largeArtworkImageURL {
            cell.displayView.set(largeImageUrl: url)
        }
        
        cell.displayView.set(topics: episode.topics.map { topic in topic.name })
        cell.displayView.set(duration: episode.duration)
        
        cell.displayView.set(isBookmarked: episode.isBookmarked)
        cell.displayView.set(isRecasted: episode.isRecommended)
        if let blurb = UserEpisodeData.shared.getBlurbForCurrentUser(and: episode) {
            cell.displayView.set(recastBlurb: blurb)
        }
        let downloadStatus = DownloadManager.shared.status(for: episode.id)
        cell.displayView.set(downloadStatus: downloadStatus)
        cell.displayView.set(numberOfRecasts: episode.numberOfRecommendations)
        return cell
    }
}
