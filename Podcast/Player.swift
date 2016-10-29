//
//  Player.swift
//  Podcast
//
//  Created by Mark Bryan on 9/30/16.
//  Copyright © 2016 Cornell App Development. All rights reserved.
//

import UIKit
import AVFoundation

enum PlayerStatus {
    case empty 
    case preparingToPlay
    case playing
    case paused
    case failed
}

protocol PlayerDelegate {
    func playerDidChangeState() -> Void // called when player start playing or is paused
    func playerDidUpdateTime() -> Void // called when player makes progress or seeks
}

class Player: NSObject {
    
    // Singleton and initializer
    static let sharedInstance = Player()
    private override init() {
        playerStatus = .empty
        shouldAutoPlay = false
        super.init()
    }
    
    var playerStatus: PlayerStatus {
        didSet {
            if oldValue != playerStatus {
                self.delegate?.playerDidChangeState()
            }
        }
    }
    var delegate: PlayerDelegate?
    private var shouldAutoPlay: Bool
    private var playerContext: UnsafeMutableRawPointer?
    private var currentAVPlayer: AVPlayer? {
        didSet {
            oldValue?.pause()
        }
    }
    private var currentURL: URL? {
        didSet {
            if oldValue != currentURL {
                prepareToPlay(url: currentURL!)
            }
        }
    }
    
    // Playback control methods
    
    func prepareToPlay(url: URL) {
        if currentURL != url || playerStatus != .preparingToPlay {
            // create a new player if this is a new URL or we aren't currently preparing a URL
            playerStatus = .preparingToPlay
            currentAVPlayer = AVPlayer(url: url)
            currentAVPlayer?.addObserver(self, forKeyPath: #keyPath(AVPlayer.status), options: [.old, .new], context: &playerContext)
        }
    }
    
    func play() {
        if let player = currentAVPlayer {
            player.play()
            playerStatus = .playing
            player.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1.0, Int32(NSEC_PER_SEC)), queue: DispatchQueue.main, using: { [weak self] time in
                self?.delegate?.playerDidUpdateTime()
            })
        }
    }
    
    func pause() {
        if let player = currentAVPlayer {
            player.pause()
            playerStatus = .paused
        }
    }
    
    func togglePlaying() {
        switch playerStatus {
        case .empty:
            break
        case .preparingToPlay:
            shouldAutoPlay = !shouldAutoPlay
        case .playing:
            pause()
        case .paused:
            play()
        case .failed:
            break
        }
    }
    
    func skipForward(seconds: Float64) {
        if let player = currentAVPlayer {
            let newTime = CMTimeAdd(player.currentTime(), CMTimeMakeWithSeconds(seconds, Int32(NSEC_PER_SEC)))
            player.seek(to: newTime)
            self.delegate?.playerDidUpdateTime()
        }
    }
    
    func skipBackward(seconds: Float64) {
        if let player = currentAVPlayer {
            let newTime = CMTimeSubtract(player.currentTime(), CMTimeMakeWithSeconds(seconds, Int32(NSEC_PER_SEC)))
            player.seek(to: newTime)
            self.delegate?.playerDidUpdateTime()
        }
    }
    
    func getProgress() -> Float {
        if playerStatus == .empty || playerStatus == .failed || currentAVPlayer == nil || currentAVPlayer?.currentItem == nil {
            return 0.0
        }
        return Float((currentAVPlayer?.currentItem?.currentTime().seconds)!) / Float((currentAVPlayer?.currentItem?.duration.seconds)!)
    }
    
    func setProgress(progress: Float) {
        if playerStatus == .empty || playerStatus == .failed {
            return
        }
        
        if progress < 0.0 {
            setProgress(progress: 0.0)
        } else if progress > 1.0 {
            setProgress(progress: 1.0)
        }
        
        let duration = currentAVPlayer?.currentItem?.duration
        let newTime = progress * Float((duration?.seconds)!)
        currentAVPlayer?.seek(to: CMTimeMakeWithSeconds(Float64(newTime), Int32(NSEC_PER_SEC)))
    }
    
    func getTimePassed() -> CMTime? {
        if let currentItem = currentAVPlayer?.currentItem {
            return currentItem.currentTime()
        }
        return nil
    }
    
    func getTimeLeft() -> CMTime? {
        if let currentItem = currentAVPlayer?.currentItem {
            return currentItem.duration
        }
        return nil
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
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
                print("Player is ready to play")
                playerStatus = .paused
                if shouldAutoPlay {
                    togglePlaying()
                }
            case .failed:
                print("Player failed to ")
                playerStatus = .failed
            case .unknown:
                print("Unknown")
            }
        }
    }
}
