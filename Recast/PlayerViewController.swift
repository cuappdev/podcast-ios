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

    // MARK: - Variables
    @objc let player = AVQueuePlayer()

    var currentTime: Double {
        get {
            return CMTimeGetSeconds(player.currentTime())
        }

        set {
            let newTime = CMTimeMakeWithSeconds(newValue, preferredTimescale: 1)
            player.seek(to: newTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
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
        // TODO: Implement player layer
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

    var durationObserverToken: Any?
    var rateObserverToken: Any?
    var statusObserverToken: Any?
    var currentObserverToken: Any?

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


        // MARK: - KVO Observation

        /*
         Update the UI when these player properties change.

         Use the context parameter to distinguish KVO for our particular observers
         and not those destined for a subclass that also happens to be observing
         these properties.
         */
        durationObserverToken = observe(\.player.currentItem?.duration, options: [.new, .initial]) { (strongSelf, change) in
            // Update `timeSlider` and enable / disable controls when `duration` > 0.0.

            /*
             Handle `NSNull` value for `NSKeyValueChangeNewKey`, i.e. when
             `player.currentItem` is nil.
             */
            let newDuration: CMTime
            if let t = change.newValue, let time = t {
                newDuration = time
            } else {
                newDuration = CMTime.zero
            }

            let hasValidDuration = newDuration.isNumeric && newDuration.value != 0
            let newDurationSeconds = hasValidDuration ? CMTimeGetSeconds(newDuration) : 0.0
            let currentTime = hasValidDuration ? Float(CMTimeGetSeconds(strongSelf.player.currentTime())) : 0.0

            strongSelf.controlsView.timeSlider.maximumValue = Float(newDurationSeconds)
            strongSelf.controlsView.timeSlider.value = currentTime
            strongSelf.controlsView.rewindButton.isEnabled = hasValidDuration
            strongSelf.controlsView.playPauseButton.isEnabled = hasValidDuration
            strongSelf.controlsView.forwardButton.isEnabled = hasValidDuration
            strongSelf.controlsView.timeSlider.isEnabled = hasValidDuration
            strongSelf.controlsView.leftTimeLabel.isEnabled = hasValidDuration
            strongSelf.controlsView.leftTimeLabel.text = strongSelf.createTimeString(time: currentTime)
            strongSelf.controlsView.rightTimeLabel.isEnabled = hasValidDuration
            strongSelf.controlsView.rightTimeLabel.text = strongSelf.createTimeString(time: Float(newDurationSeconds))
        }

        rateObserverToken = observe(\.player.rate, options: [.new, .initial]) { (strongSelf, change) in
            // Update `playPauseButton` image.
            let newRate = change.newValue!
            let buttonImageName = newRate == 0.0 ? "player_play_icon" : "player_pause_icon"
            let buttonImage = UIImage(named: buttonImageName)
            strongSelf.controlsView.playPauseButton.setImage(buttonImage, for: .normal)
        }

        statusObserverToken = observe(\.player.currentItem?.status, options: [.new, .initial]) { (strongSelf, change) in
            // Display an error if status becomes `.Failed`.
            /*
             Handle `NSNull` value for `NSKeyValueChangeNewKey`, i.e. when
             `player.currentItem` is nil.
             */
            let newStatus: AVPlayerItem.Status

            if let status = change.newValue {
                newStatus = status!
            } else {
                newStatus = .unknown
            }

            if newStatus == .failed {
                strongSelf.handleError(with: strongSelf.player.currentItem?.error?.localizedDescription, error: strongSelf.player.currentItem?.error)
            }
        }

        currentObserverToken = observe(\.player.currentItem?, options: [.new, .initial]) { (strongSelf, _) in
            strongSelf.updateNowPlayingInfo()
        }

        playerView.playerLayer.player = player

        // Make sure we don't have a strong reference cycle by only capturing self as weak.
        let interval = CMTimeMake(value: 1, timescale: 1)
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
    }

    // MARK: - Player Controls

    func playPauseButtonWasPressed(_ sender: UIButton) {
        if player.rate != 1.0 {
            if currentTime == duration {
                currentTime = 0.0
            }
            player.play()
        } else {
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
        NSLog("Error occurred with message: \(message!), error: \(error!).")

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
            print("Found URL: \(url)")
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

//        if player.status == AVQueuePlayer.Status.failed {
//            if let error = player.error {
//                print(error)
//            }
//            if #available(iOS 10, *) {
//                player.automaticallyWaitsToMinimizeStalling = false
//            }
//        }

        if #available(iOS 10, *) {
            player.automaticallyWaitsToMinimizeStalling = false
        }

        player.pause()
        player.replaceCurrentItem(with: item)
        player.play()

        updateNowPlayingInfo()
        updatePlayerUI()
    }

    // TODO: Queueing
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
