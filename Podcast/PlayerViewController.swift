//
//  PlayerViewController.swift
//  Podcast
//
//  Created by Mark Bryan on 9/7/16.
//  Copyright © 2016 Cornell App Development. All rights reserved.
//

import UIKit

class PlayerViewController: UIViewController {
    
    // Mark: Constants
    
    let PlayerControlPanelHeight: CGFloat = 182
    
    
    // Mark: Properties
    
    var controlsView: PlayerControlsView!
    var artworkImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .podcastGrayLight
        tabBarController?.title = "Now Playing"
        
        controlsView = PlayerControlsView(frame: CGRect(x: 0, y: view.frame.height - PlayerControlPanelHeight - tabBarController!.tabBar.frame.height, width: view.frame.width, height: PlayerControlPanelHeight))
        view.addSubview(controlsView)
        
        artworkImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - PlayerControlPanelHeight - tabBarController!.tabBar.frame.height))
        artworkImageView.contentMode = .scaleAspectFill
        artworkImageView.image = UIImage(named: "SampleSeriesArtwork")
        view.addSubview(artworkImageView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        controlsView.playerDidUpdateTime()
        controlsView.playerDidChangeState()
    }
}
