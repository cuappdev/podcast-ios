//
//  PlayerViewController.swift
//  Recast
//
//  Created by Jack Thompson on 9/16/18.
//  Copyright © 2018 Cornell AppDev. All rights reserved.
//

import UIKit
import SnapKit
import AVFoundation

private var playerViewControllerKVOContext = 0

class PlayerViewController: UIViewController {

    // Attempt load and test these asset keys before playing.
    static let assetKeysRequiredToPlay = [
        "playable",
        "hasProtectedContent"
    ]

    // MARK: - Variables
    @objc let player = AVQueuePlayer()

    var currentTime: Double {
        get {
            return CMTimeGetSeconds(player.currentTime())
        }

        set {
            let newTime = CMTimeMakeWithSeconds(newValue, 1)
            player.seek(to: newTime, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
        }
    }

    var duration: Double {
        guard let currentItem = player.currentItem else { return 0.0 }

        return CMTimeGetSeconds(currentItem.duration)
    }

    var rate: Float {
        get {
            return player.rate
        }

        set {
            player.rate = newValue
        }
    }

    var playerLayer: AVPlayerLayer? {
        // TODO:
        return playerView.playerLayer
    }

    /*
     A formatter for individual date components used to provide an appropriate
     value for the `startTimeLabel` and `durationLabel`.
     */
    let timeRemainingFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.zeroFormattingBehavior = .pad
        formatter.allowedUnits = [.minute, .second]

        return formatter
    }()

    /*
     A token obtained from calling `player`'s `addPeriodicTimeObserverForInterval(_:queue:usingBlock:)`
     method.
     */
    var timeObserverToken: Any?

    var assetTitlesAndThumbnails: [URL: (title: String, thumbnail: UIImage)] = [:]

    var loadedAssets = [String: AVURLAsset]()

    private var current: Episode?
    private var queue: [Episode] = []

    var controlsView: PlayerControlsView!
    var playerView: PlayerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        playerView = PlayerView()
        view.addSubview(playerView)

        controlsView = PlayerControlsView(frame: .zero)
        view.addSubview(controlsView)

        setupConstraints()

        // TODO: setup player queue from saved queue
    }

    func setupConstraints() {
        // MARK: - Constants
        let topPadding: CGFloat = 100
        let controlsHeight: CGFloat = 100

        playerView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(topPadding)
        }

        controlsView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(topPadding)
            make.height.equalTo(controlsHeight)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        /*
         Update the UI when these player properties change.

         Use the context parameter to distinguish KVO for our particular observers
         and not those destined for a subclass that also happens to be observing
         these properties.
         */
        addObserver(self, forKeyPath: #keyPath(PlayerViewController.player.currentItem.duration), options: [.new, .initial], context: &playerViewControllerKVOContext)
        addObserver(self, forKeyPath: #keyPath(PlayerViewController.player.rate), options: [.new, .initial], context: &playerViewControllerKVOContext)
        addObserver(self, forKeyPath: #keyPath(PlayerViewController.player.currentItem.status), options: [.new, .initial], context: &playerViewControllerKVOContext)
        addObserver(self, forKeyPath: #keyPath(PlayerViewController.player.currentItem), options: [.new, .initial], context: &playerViewControllerKVOContext)

        playerView.playerLayer.player = player

        // Make sure we don't have a strong reference cycle by only capturing self as weak.
        let interval = CMTimeMake(1, 1)
        timeObserverToken = player.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main) { [unowned self] time in
            let timeElapsed = Float(CMTimeGetSeconds(time))

            self.controlsView.timeSlider.value = Float(timeElapsed)
            self.controlsView.leftTimeLabel.text = self.createTimeString(time: timeElapsed)
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        if let timeObserverToken = timeObserverToken {
            player.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }

        player.pause()

        removeObserver(self, forKeyPath: #keyPath(PlayerViewController.player.currentItem.duration), context: &playerViewControllerKVOContext)
        removeObserver(self, forKeyPath: #keyPath(PlayerViewController.player.rate), context: &playerViewControllerKVOContext)
        removeObserver(self, forKeyPath: #keyPath(PlayerViewController.player.currentItem.status), context: &playerViewControllerKVOContext)
        removeObserver(self, forKeyPath: #keyPath(PlayerViewController.player.currentItem), context: &playerViewControllerKVOContext)
    }

    // MARK: - Player Controls

    func playPauseButtonWasPressed(_ sender: UIButton) {
        if player.rate != 1.0 {
            if currentTime == duration {
                currentTime = 0.0
            }
            player.play()
        }
        else {
            player.pause()
        }
    }

    private func skip(seconds: Double) {
        guard let item = player.currentItem else { return }
        let skipAmount = CMTime(seconds: seconds, preferredTimescale: CMTimeScale(1.0))
        let newTime = CMTimeAdd(item.currentTime(), skipAmount)
        player.currentItem?.seek(to: newTime, completionHandler: { success in
            print("Skip success: \(success)")
            self.updateNowPlayingInfo()
        })
    }

    func skipBackButtonWasPressed(_ sender: UIButton) {
        skip(seconds: -30)
    }

    func skipForwardButtonWasPressed(_ sender: UIButton) {
        skip(seconds: 30)
    }

    func timeSliderDidChange(_ sender: UISlider) {
        currentTime = Double(sender.value)
    }

    // MARK: KVO Observation

    // Update our UI when player or `player.currentItem` changes.
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        // Make sure the this KVO callback was intended for this view controller.
        guard context == &playerViewControllerKVOContext else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }

        if keyPath == #keyPath(PlayerViewController.player.currentItem) {
            updateNowPlayingInfo()
        } else if keyPath == #keyPath(PlayerViewController.player.currentItem.duration) {
            // Update `timeSlider` and enable / disable controls when `duration` > 0.0.

            /*
             Handle `NSNull` value for `NSKeyValueChangeNewKey`, i.e. when
             `player.currentItem` is nil.
             */
            let newDuration: CMTime
            if let newDurationAsValue = change?[NSKeyValueChangeKey.newKey] as? NSValue {
                newDuration = newDurationAsValue.timeValue
            } else {
                newDuration = kCMTimeZero
            }

            let hasValidDuration = newDuration.isNumeric && newDuration.value != 0
            let newDurationSeconds = hasValidDuration ? CMTimeGetSeconds(newDuration) : 0.0
            let currentTime = hasValidDuration ? Float(CMTimeGetSeconds(player.currentTime())) : 0.0

            controlsView.timeSlider.maximumValue = Float(newDurationSeconds)
            controlsView.timeSlider.value = currentTime
            controlsView.rewindButton.isEnabled = hasValidDuration
            controlsView.playPauseButton.isEnabled = hasValidDuration
            controlsView.forwardButton.isEnabled = hasValidDuration
            controlsView.timeSlider.isEnabled = hasValidDuration
            controlsView.leftTimeLabel.isEnabled = hasValidDuration
            controlsView.leftTimeLabel.text = createTimeString(time: currentTime)
            controlsView.rightTimeLabel.isEnabled = hasValidDuration
            controlsView.rightTimeLabel.text = createTimeString(time: Float(newDurationSeconds))
        } else if keyPath == #keyPath(PlayerViewController.player.rate) {
            // Update `playPauseButton` image.

            let newRate = (change?[NSKeyValueChangeKey.newKey] as! NSNumber).doubleValue
            let buttonImageName = newRate == 1.0 ? "PauseButton" : "PlayButton"
            let buttonImage = UIImage(named: buttonImageName)
            controlsView.playPauseButton.setImage(buttonImage, for: .normal)
        } else if keyPath ==  #keyPath(PlayerViewController.player.currentItem.status) {
            // Display an error if status becomes `.Failed`.

            /*
             Handle `NSNull` value for `NSKeyValueChangeNewKey`, i.e. when
             `player.currentItem` is nil.
             */
            let newStatus: AVPlayerItemStatus

            if let newStatusAsNumber = change?[NSKeyValueChangeKey.newKey] as? NSNumber {
                newStatus = AVPlayerItemStatus(rawValue: newStatusAsNumber.intValue)!
            } else {
                newStatus = .unknown
            }

            if newStatus == .failed {
                handleError(with: player.currentItem?.error?.localizedDescription, error: player.currentItem?.error)
            }
        }
    }

    /*
     Trigger KVO for anyone observing our properties affected by `player` and
     `player.currentItem`.
     */
    override class func keyPathsForValuesAffectingValue(forKey key: String) -> Set<String> {
        let affectedKeyPathsMappingByKey: [String: Set<String>] = [
            "duration": [#keyPath(PlayerViewController.player.currentItem.duration)],
            "rate": [#keyPath(PlayerViewController.player.rate)]
        ]

        return affectedKeyPathsMappingByKey[key] ?? super.keyPathsForValuesAffectingValue(forKey: key)
    }

    // MARK: Error Handling

    func handleError(with message: String?, error: Error? = nil) {
        NSLog("Error occurred with message: \(message), error: \(error).")

        let alertTitle = NSLocalizedString("alert.error.title", comment: "Alert title for errors")

        let alertMessage = message ?? NSLocalizedString("error.default.description", comment: "Default error message when no NSError provided")

        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)

        let alertActionTitle = NSLocalizedString("alert.error.actions.OK", comment: "OK on error alert")
        let alertAction = UIAlertAction(title: alertActionTitle, style: .default, handler: nil)

        alert.addAction(alertAction)

        present(alert, animated: true, completion: nil)
    }

    // MARK: Custom Play options

    func play(_ episode: Episode) {
        current = episode
        guard let encl = current?.enclosure else {
            // TODO: handle error
            return
        }
        var asset: AVAsset?
        // TODO: update for downloaded episodes
        switch encl {
        case .audio(let url, _, _):
            asset = AVAsset(url: url)
        case .video(let url, _, _):
            asset = AVAsset(url: url)
        case .pdf:
            // Shouldn't happen, PDF should push on PDFViewController
            break
        }
        guard let a = asset else {
            // TODO: handle error
            return
        }
        let item = AVPlayerItem(asset: a)

        if player.status == AVPlayerStatus.failed {
            if let error = player.error {
                print(error)
            }
            if #available(iOS 10, *) {
                player.automaticallyWaitsToMinimizeStalling = false
            }
        }

        player.pause()
        player.replaceCurrentItem(with: item)

        updateNowPlayingInfo()
        updatePlayerUI()
    }

    func queue(_ episode: Episode, at index: Int? = nil) {
        if queue.isEmpty {
            play(episode)
            return
        }
        if let i = index {
            queue.insert(episode, at: i)
        } else {
            queue.append(episode)
        }
    }

    func updatePlayerUI() {

    }

    func updateNowPlayingInfo() {

    }

    // MARK: Convenience

    func createTimeString(time: Float) -> String {
        let components = NSDateComponents()
        components.second = Int(max(0.0, time))

        return timeRemainingFormatter.string(from: components as DateComponents)!
    }
}

// MARK: - PlayerHeaderViewDelegate
extension PlayerViewController: PlayerHeaderViewDelegate {

    func playerHeaderViewDidTapCollapseButton() {
        
    }
}
