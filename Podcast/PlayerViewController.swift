//
//  PlayerViewController.swift
//  Podcast
//
//  Created by Mark Bryan on 9/7/16.
//  Copyright © 2016 Cornell App Development. All rights reserved.
//

import UIKit
import CoreMedia

class PlayerViewController: UIViewController, PlayerDelegate {
    
    var controlsView: PlayerControlsView!
    var episodeDetailView: EpisodeDetailView!
    var playerHeaderView: PlayerHeaderView!
    var episodeNameLabel: UILabel!
    var seriesNameLabel: UILabel!
    
    let EpisodeDetailViewYVal: CGFloat = 87
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .podcastGrayLight
        
        playerHeaderView = PlayerHeaderView(frame: .zero)
        playerHeaderView.frame.size.width = view.frame.width
        playerHeaderView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(playerHeaderTapped)))
        view.addSubview(playerHeaderView)
        
        episodeDetailView = EpisodeDetailView(frame: .zero)
        episodeDetailView.frame.size.width = view.frame.width
        episodeDetailView.frame.origin.y = EpisodeDetailViewYVal
        view.addSubview(episodeDetailView)
        
        controlsView = PlayerControlsView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 0))
        controlsView.frame.origin.y = view.frame.height - controlsView.frame.size.height
        view.addSubview(controlsView)
        
        // TODO: add comments section
        
        updateUI()
        
        Player.sharedInstance.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateUI()
    }
    
    func playerHeaderTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    func updateUI() {
        playerHeaderView.updateUI()
        episodeDetailView.updateUI()
        controlsView.updateUI()
    }
}
