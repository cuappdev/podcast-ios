//
//  TempPlayerViewController.swift
//  Podcast
//
//  Created by Mark Bryan on 2/22/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class TempPlayerViewController: UIViewController {

    var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        button = UIButton()
        button.setTitle("Launch Player", for: .normal)
        button.frame.size = CGSize(width: 300, height: 50)
        button.addTarget(self, action: #selector(launchPlayer), for: .touchDown)
        button.center = view.center
        button.backgroundColor = .black
        view.addSubview(button)
    }
    
    func launchPlayer() {
        present(PlayerViewController(), animated: true, completion: nil)
    }

}
