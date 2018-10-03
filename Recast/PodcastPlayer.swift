//
//  PodcastPlayer.swift
//  Recast
//
//  Created by Drew Dunne on 9/27/18.
//  Copyright © 2018 Cornell AppDev. All rights reserved.
//

import UIKit
import AVFoundation

class PodcastPlayer: AVQueuePlayer {

    private var downloadPlayer: AVAudioPlayer?

    private var itemQueue: [(URL, Bool)] = []

    override init(playerItem: AVPlayerItem?) {
        super.init(playerItem: playerItem)
        // TODO: load previous queue?
    }

    override func advanceToNextItem() {

        super.advanceToNextItem()
    }

    func add(_ item: URL, downloaded: Bool = false) {
        if downloaded {
            // Keep on itemQueue for AudioPlayer
            itemQueue.append((item, downloaded))
        } else if !itemQueue.isEmpty {
            itemQueue.append((item, downloaded))
        } else if items().isEmpty {
            // Play immediately
            let avItem = AVPlayerItem(url: item)
            replaceCurrentItem(with: avItem)
            play() // TODO: check to make sure we want to play here
        } else {
            // Add to internal queue
            let avItem = AVPlayerItem(url: item)
            insert(avItem, after: nil)
        }
    }

    func insert(_ item: URL, downloaded: Bool = false, after: URL) {
        
    }

    func play(_ item: Episode?) {

    }
}
