//
//  PlayerViewController.swift
//  Podcast
//
//  Created by Mark Bryan on 9/7/16.
//  Copyright © 2016 Cornell App Development. All rights reserved.
//

import UIKit
import CoreMedia

protocol PlayerHeaderViewDelegate: class {
    func playerHeaderViewDidTapCollapseButton()
}

protocol MiniPlayerViewDelegate: class {
    func miniPlayerViewDidTapPlayButton()
    func miniPlayerViewDidTapPauseButton()
    func miniPlayerViewDidTapExpandButton()
}

class PlayerViewController: TabBarAccessoryViewController, PlayerDelegate, PlayerHeaderViewDelegate, MiniPlayerViewDelegate {
    
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
        playerHeaderView.delegate = self
        playerHeaderView.alpha = 0.0
        view.addSubview(playerHeaderView)
        
        miniPlayerView = MiniPlayerView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 0))
        miniPlayerView.frame.size.width = view.frame.width
        miniPlayerView.delegate = self
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
    
    func playerHeaderViewDidTapCollapseButton() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.collapsePlayer()
    }
    
    func miniPlayerViewDidTapPlayButton() {
       //TODO
    }
    
    func miniPlayerViewDidTapPauseButton() {
        //TODO
    }
    
    func miniPlayerViewDidTapExpandButton() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.expandPlayer()
    }
    
    func expand() {

        self.miniPlayerView.alpha = 0.0
        self.playerHeaderView.alpha = 1.0
        self.view.frame.origin.y = 0
        
        isMini = false
    }
    
    func collapse() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        self.miniPlayerView.alpha = 1.0
        self.playerHeaderView.alpha = 0.0
        self.view.frame.origin.y = self.view.frame.height - appDelegate.tabBarController.tabBarHeight - self.miniPlayerView.frame.height

        isMini = true
    }
    
    override func showAccessoryViewController(animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.5, animations: {
                self.view.alpha = 1.0
            })
        } else {
            view.alpha = 1.0
        }
    }
    
    override func hideAccessoryViewController(animated: Bool) {
        
        if animated {
            UIView.animate(withDuration: 0.5, animations: {
                self.view.alpha = 0.0
            })
        } else {
            view.alpha = 0.0
        }
    }
    
    override func expandAccessoryViewController(animated: Bool) {
        guard isMini else { return }
        
        if animated {
            UIView.animate(withDuration: 0.5, animations: {
                self.expand()
            })
        } else {
            self.expand()
        }
    }
    
    override func collapseAccessoryViewController(animated: Bool) {
        guard !isMini else { return }
        
        if animated {
            UIView.animate(withDuration: 0.5, animations: { 
                self.collapse()
            })
        } else {
            self.collapse()
        }
    }
    
    func updateUI() {
        playerHeaderView.updateUI()
        episodeDetailView.updateUI()
        controlsView.updateUI()
        miniPlayerView.updateUI()
    }
}
