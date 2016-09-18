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
    let PlayerControlPanelHeight: CGFloat = 250
    
    //Mark: -
    //Mark: Properties
    //Mark: -
    var controlsView: PlayerControlsView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.podcastGrayLight
        
        controlsView = PlayerControlsView(frame: CGRect(x: 0, y: self.view.frame.height - PlayerControlPanelHeight, width: self.view.frame.width, height: PlayerControlPanelHeight))
        
        self.view.addSubview(controlsView)
    }
    
}
