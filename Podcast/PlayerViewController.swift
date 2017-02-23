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
    var miniPlayerView: MiniPlayerView!
    var isMini: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        playerHeaderView = PlayerHeaderView(frame: .zero)
        playerHeaderView.frame.size.width = view.frame.width
        playerHeaderView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeMode)))
        playerHeaderView.alpha = 0.0
        view.addSubview(playerHeaderView)
        
        miniPlayerView = MiniPlayerView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 0))
        miniPlayerView.frame.size.width = view.frame.width
        miniPlayerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeMode)))
        view.addSubview(miniPlayerView)
        
        episodeDetailView = EpisodeDetailView(frame: .zero)
        episodeDetailView.frame.size.width = view.frame.width
        episodeDetailView.frame.origin.y = playerHeaderView.frame.maxY
        view.addSubview(episodeDetailView)
        
        controlsView = PlayerControlsView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 0))
        controlsView.frame.origin.y = view.frame.height - controlsView.frame.size.height
        view.addSubview(controlsView)
        
        updateUI()
        
        Player.sharedInstance.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateUI()
    }
    
    func changeMode() {
        isMini ? expand() : collapse()
    }
    
    func expand() {
        UIView.animate(withDuration: 1.0, animations: {
            self.miniPlayerView.alpha = 0.0
            self.playerHeaderView.alpha = 1.0
            self.view.frame.origin.y = 0
        })
        isMini = false
    }
    
    func collapse() {
        UIView.animate(withDuration: 1.0, animations: {
            self.miniPlayerView.alpha = 1.0
            self.playerHeaderView.alpha = 0.0
            // TODO: is there a way to get the TabBar's height? Replace 110 with this value
            self.view.frame.origin.y = self.view.frame.height - 110
        })
        isMini = true
    }
    
    func updateUI() {
        playerHeaderView.updateUI()
        episodeDetailView.updateUI()
        controlsView.updateUI()
        miniPlayerView.updateUI()
    }
}
