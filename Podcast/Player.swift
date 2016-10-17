//
//  Player.swift
//  Podcast
//
//  Created by Mark Bryan on 9/30/16.
//  Copyright © 2016 Cornell App Development. All rights reserved.
//

import UIKit
import AVFoundation

class Player: NSObject, AVAudioPlayerDelegate {
    
    private var currentTask: URLSessionDataTask?
    private var player: AVAudioPlayer?
    private let fileURL: URL
    
    init(fileURL: URL) {
        self.fileURL = fileURL
        super.init()
    }
    
    var isPlaying: Bool {
        return player?.isPlaying ?? false
    }
    
    func prepareToPlay() {
        if player == nil {
            if fileURL.isFileURL {
                player = try? AVAudioPlayer(contentsOf: fileURL as URL)
                player?.prepareToPlay()
            } else if currentTask == nil {
                let request = URLRequest(url: fileURL as URL, cachePolicy:  .returnCacheDataElseLoad, timeoutInterval: 15)
                currentTask = URLSession.shared.dataTask(with: request) { [weak self] data, response, _ -> Void in
                    guard let s = self else { return }
                    guard let data = data else { return }
                    
                    s.player = try? AVAudioPlayer(data: data)
                    s.player?.prepareToPlay()
                    s.currentTask = nil
                    s.player?.play()
                }
                currentTask?.resume()
            }
        }
    }
    
    func play() {
        prepareToPlay()
        player?.play()
    }
    
    func pause() {
        player?.pause()
    }
    
    func togglePlaying() {
        isPlaying ? pause() : play()
    }
    
    // MARK: - AVAudioPlayerDelegate
    
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        pause()
    }
}
