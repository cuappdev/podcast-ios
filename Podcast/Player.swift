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

/// Protocol for the singleton Player to observe changes in the Player's state and time changes
protocol PlayerDelegate: class {
    /// Called when the Player's state changes. Override to observe when the state is changed.
    func playerDidChangeState()
    /// Called when the Player has made playback progress. Override to observe when the Player makes progress on playback.
    func playerDidUpdateTime()
}

/// Handles playback of podcasts from URLs
class Player: NSObject {
    
    static let sharedInstance = Player()
    private override init() {
        playerStatus = .empty
        shouldAutoPlay = false
        super.init()
    }
    
    var playerStatus: PlayerStatus {
        didSet {
            if oldValue != playerStatus {
                delegate?.playerDidChangeState()
            }
        }
    }
    
    weak var delegate: PlayerDelegate?
    private var shouldAutoPlay: Bool
    private var playerContext: UnsafeMutableRawPointer?
    private var timeObserverToken: Any?
    private var currentAVPlayer: AVPlayer? {
        didSet {
            oldValue?.pause()
        }
    }
    private var currentURL: URL? {
        didSet {
            if oldValue != currentURL {
                prepareToPlay(url: currentURL)
            }
        }
    }
    
    deinit {
        do {
            try currentAVPlayer?.removeObserver(self, forKeyPath: #keyPath(AVPlayer.status), context: &playerContext)
        } catch {}
        removeTimeObserver()
    }
    
    /// Prepares the player to play a new track from a URL. If the Player is in the .preparingToPlay state, this has no effect on current playback.
    /// - Parameters:
    ///   - url: The url to fetch and play from.
    func prepareToPlay(url: URL?) {
        if let url = url {
            if currentURL != url || playerStatus != .preparingToPlay {
                // create a new player if this is a new URL or we aren't currently preparing a URL
                playerStatus = .preparingToPlay
                currentAVPlayer = AVPlayer(url: url)
                currentAVPlayer?.addObserver(self, forKeyPath: #keyPath(AVPlayer.status), options: [.old, .new], context: &playerContext)
            }
        }
    }
    
    /// Plays the current track and sets the Player status to .playing if successful
    func play() {
        if let player = currentAVPlayer {
            player.play()
            playerStatus = .playing
            timeObserverToken = player.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1.0, Int32(NSEC_PER_SEC)), queue: DispatchQueue.main, using: { [weak self] _ in
                self?.delegate?.playerDidUpdateTime()
            })
        }
    }
    
    /// Pauses playback of the current track and sets the Player status to .paused if successful
    func pause() {
        if let player = currentAVPlayer {
            player.pause()
            playerStatus = .paused
            removeTimeObserver()
        }
    }
    
    /// Removes time observer if there currently is one
    func removeTimeObserver() {
        if let token = timeObserverToken {
            guard let player = currentAVPlayer else {
                return
            }
            player.removeTimeObserver(token)
            timeObserverToken = nil
        }
    }
    
    /// Toggles playback of the Player. If the player is in the preparingToPlay state and cannot yet play,
    /// this toggles whether the player will autoplay once it is ready.
    func togglePlaying() {
        switch playerStatus {
        case .preparingToPlay:
            shouldAutoPlay = !shouldAutoPlay
        case .playing:
            pause()
        case .paused:
            play()
        default:
            break
        }
    }
    
    /// Skips a variable amount of seconds in the current audio track. Skips forward or backward based on a positive or negative seconds value.
    /// - Parameters:
    ///   - seconds: the amount of time in seconds to skip. If negative, skips backward.
    func skip(seconds: Float64) {
        if let player = currentAVPlayer {
            let newTime = CMTimeAdd(player.currentTime(), CMTimeMakeWithSeconds(seconds, Int32(NSEC_PER_SEC)))
            player.seek(to: newTime)
            delegate?.playerDidUpdateTime()
        }
    }
    
    
    /// Returns the progress for the Player's current track.
    /// - Returns: a Float in the range [0.0,1.0] specifying what the current location of playback is relative to the entire track.
    func getProgress() -> Float {
        if playerStatus == .empty || playerStatus == .failed || currentAVPlayer?.currentItem == nil {
            return 0.0
        }
        return Float((currentAVPlayer?.currentItem?.currentTime().seconds)!) / Float((currentAVPlayer?.currentItem?.duration.seconds)!)
    }
    
    /// Sets the progress of the Player's current track
    /// - Parameters:
    ///   - progress: the value to set where the Player should begin playback. Should be in range [0.0,1.0], but will be set to 0.0 if less than 0.0 and 1.0 if greater than 1.0
    func setProgress(progress: Float) {
        if playerStatus == .empty || playerStatus == .failed {
            return
        }
        
        var progress = progress
        
        if progress < 0.0 {
            progress = 0.0
        } else if progress > 1.0 {
            progress = 1.0
        }
        
        if let duration = currentAVPlayer?.currentItem?.duration {
            let newTime = progress * Float(duration.seconds)
            currentAVPlayer?.seek(to: CMTimeMakeWithSeconds(Float64(newTime), Int32(NSEC_PER_SEC)))
        }
    }
    
    /// - Returns: the duration of the current item in the Player. nil if no item
    func getDuration() -> CMTime? {
        return currentAVPlayer?.currentItem?.duration
    }
    
    /// - Returns: the time passed if there is a current item in the Player. nil if no item
    func getTimePassed() -> CMTime? {
        return currentAVPlayer?.currentItem?.currentTime()
    }
    
    /// - Returns: the time left from current playback if there is a current item in the Player. nil if no item
    func getTimeLeft() -> CMTime? {
        guard let timePassed = getTimePassed(), let duration = getDuration() else {
            return nil
        }
        return CMTimeSubtract(duration, timePassed)
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
                playerStatus = .paused
                if shouldAutoPlay {
                    togglePlaying()
                }
            case .failed:
                playerStatus = .failed
            default:
                break
            }
            currentAVPlayer?.removeObserver(self, forKeyPath: #keyPath(AVPlayer.status), context: &playerContext)
        }
    }
}
