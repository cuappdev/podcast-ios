//
//  PlayerViewController.swift
//  Podcast
//
//  Created by Mark Bryan on 9/7/16.
//  Copyright © 2016 Cornell App Development. All rights reserved.
//

import UIKit

class PlayerViewController: UIViewController {
    
    //Mark: -
    //Mark: Constants
    //Mark: -
    let PlayerControlPanelHeight: CGFloat = 160
    
    //Mark: -
    //Mark: Properties
    //Mark: -
    var controlsView: PlayerControlsView!
    var artworkImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.podcastGrayLight
        self.tabBarController?.title = "Now Playing"
        
        controlsView = PlayerControlsView(frame: CGRect(x: 0, y: self.view.frame.height - PlayerControlPanelHeight - tabBarController!.tabBar.frame.height, width: self.view.frame.width, height: PlayerControlPanelHeight))
        self.view.addSubview(controlsView)
        
        artworkImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - PlayerControlPanelHeight - tabBarController!.tabBar.frame.height))
        artworkImageView.contentMode = .ScaleAspectFill
        artworkImageView.image = UIImage(named: "SampleSeriesArtwork")
        self.view.addSubview(artworkImageView)
    }
    
}
