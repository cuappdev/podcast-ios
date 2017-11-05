//
//  UnimplementedViewController.swift
//  Podcast
//
//  Created by Natasha Armbrust on 11/2/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class UnimplementedViewController: ViewController {
    
    var emptyStateTableView: EmptyStateTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .paleGrey
        emptyStateTableView = EmptyStateTableView(frame: view.frame, type: .unimplemented)
        emptyStateTableView.loadingAnimation.stopAnimating()
        view.addSubview(emptyStateTableView)
    }
}
