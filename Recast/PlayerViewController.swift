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
    var containerView: UIView!
    var episodeImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black

        containerView = UIView()
        containerView.backgroundColor = .clear
        view.addSubview(containerView)

        episodeImageView = UIImageView(image: UIImage(named: "series_img_1"))
        containerView.addSubview(episodeImageView)

        playerView = PlayerView()
        containerView.addSubview(playerView)

        controlsView = PlayerControlsView(frame: .zero)
        view.addSubview(controlsView)
        controlsView.playPauseButton.addTarget(self, action: #selector(playPauseButtonWasPressed(_:)), for: .touchUpInside)
        controlsView.forwardButton.addTarget(self, action: #selector(skipForwardButtonWasPressed(_:)), for: .touchUpInside)
        controlsView.rewindButton.addTarget(self, action: #selector(skipBackButtonWasPressed(_:)), for: .touchUpInside)
        controlsView.timeSlider.addTarget(self, action: #selector(timeSliderDidChange(_:)), for: .valueChanged)

        setupConstraints()
    }

    func setupConstraints() {
        // MARK: - Constants
        let topPadding: CGFloat = 100

        playerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        episodeImageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.centerY.equalToSuperview()
            make.height.equalTo(episodeImageView.snp.width)
        }

        containerView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalTo(controlsView.snp.top)
        }

        controlsView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(topPadding)
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
            strongSelf.updateDuration(newDuration)
        }

        rateObserverToken = observe(\.player.rate, options: [.new, .initial]) { (strongSelf, change) in
            // Update `playPauseButton` image.
            let newRate = change.newValue!
            let buttonImageName = newRate == 0.0 ? "player_play_icon" : "player_pause_icon"
            let buttonImage = UIImage(named: buttonImageName)
            print(newRate)
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
        timeObserverToken = player.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main) { [weak self] time in
            let timeElapsed = Float(CMTimeGetSeconds(time))

            if let strongSelf = self, !strongSelf.controlsView.timeSlider.isSelected {
                strongSelf.controlsView.timeSlider.value = Float(timeElapsed)
                strongSelf.controlsView.leftTimeLabel.text = strongSelf.createTimeString(time: timeElapsed)
            }
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        if let timeObserverToken = timeObserverToken {
            player.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
    }

    // MARK: - Player Controls

    @objc func playPauseButtonWasPressed(_ sender: UIButton) {
        print("Play/Pause pressed")
        if player.rate == 0.0 {
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

    @objc func skipBackButtonWasPressed(_ sender: UIButton) {
        skip(seconds: -30)
    }

    @objc func skipForwardButtonWasPressed(_ sender: UIButton) {
        skip(seconds: 30)
    }

    @objc func timeSliderDidChange(_ sender: UISlider) {
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
        guard let encl = current?.enclosure, let url = encl.url else {
            // TODO: handle error
            print("\(episode.title!)")
            print("No URL! LAME!")
            return
        }
        // TODO: update for downloaded episodes
        let asset = AVAsset(url: url) // Use Assets for trimming later
        let item = AVPlayerItem(asset: asset)

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

    func updateDuration(_ newDuration: CMTime) {
        let hasValidDuration = newDuration.isNumeric && newDuration.value != 0
        let newDurationSeconds = hasValidDuration ? CMTimeGetSeconds(newDuration) : 0.0
        let currentTime = hasValidDuration ? Float(CMTimeGetSeconds(player.currentTime())) : 0.0

        controlsView.timeSlider.maximumValue = Float(newDurationSeconds)
        controlsView.timeSlider.value = currentTime
        controlsView.timeSlider.isContinuous = true
        controlsView.rewindButton.isEnabled = hasValidDuration
        controlsView.playPauseButton.isEnabled = hasValidDuration
        controlsView.forwardButton.isEnabled = hasValidDuration
        controlsView.timeSlider.isEnabled = hasValidDuration
        controlsView.leftTimeLabel.isEnabled = hasValidDuration
        controlsView.leftTimeLabel.text = createTimeString(time: currentTime)
        controlsView.rightTimeLabel.isEnabled = hasValidDuration
        controlsView.rightTimeLabel.text = createTimeString(time: Float(newDurationSeconds))
    }

    func updatePlayerUI() {

    }

    func updateNowPlayingInfo() {
        guard let imageUrl = current?.podcast?.artworkUrl600 else { return }
        if episodeImageView != nil {
            episodeImageView.kf.setImage(with: imageUrl)
        }
    }

    // MARK: Convenience

    func createTimeString(time: Float) -> String {
        let components = NSDateComponents()
        components.second = Int(max(0.0, time))

        return timeRemainingFormatter.string(from: components as DateComponents)!
    }
}
