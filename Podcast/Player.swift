//
//  Player.swift
//  Podcast
//
//  Created by Mark Bryan on 9/30/16.
//  Copyright © 2016 Cornell App Development. All rights reserved.
//

import UIKit
import AVFoundation

let PlayerDidChangeStateNotification = "PlayerDidChangeState"
let PlayerDidSeekNotification = "PlayerDidSeek"
let PlayerDidFinishPlayingNotification = "PlayerDidFinishPlaying"

class Player: NSObject {
    
    private var player: AVPlayer? {
        didSet {
            oldValue?.pause()
        }
    }
    private let url: URL
    private var playerContext: UnsafeMutableRawPointer?
    
    init(url: URL) {
        self.url = url
        super.init()
    }
    
    func isPlaying() -> Bool {
        if let player = player {
            return player.rate != 0.0
        }
        return false
    }
    
    func prepareToPlay() {
        if player == nil {
            player = AVPlayer(url: url)
            player?.addObserver(self, forKeyPath: #keyPath(AVPlayer.status), options: [.old, .new], context: &playerContext)
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
        isPlaying() ? pause() : play()
    }
    
    func skipForward(seconds: Int) {
        if let player = player {
            let newTime = CMTimeAdd(player.currentTime(), CMTimeMake(Int64(seconds),1))
            player.seek(to: newTime)
        }
    }
    
    func skipBackward(seconds: Int) {
        if let player = player {
            let newTime = CMTimeSubtract(player.currentTime(), CMTimeMake(Int64(seconds),1))
            player.seek(to: newTime)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        // only observe values for the playerContext
        guard context == &playerContext else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        
        if keyPath == #keyPath(AVPlayer.status) {
            let status: AVPlayerStatus
            
            if let statusNumber = change?[.newKey] as? NSNumber {
                status = AVPlayerStatus(rawValue: statusNumber.intValue)!
            } else {
                status = .unknown
            }
            
            switch status {
            case .readyToPlay:
                print("Ready to play")
                player?.play()
            case .failed:
                print("Failed")
            case .unknown:
                print("Unknown")
            }
        }
    }
}
