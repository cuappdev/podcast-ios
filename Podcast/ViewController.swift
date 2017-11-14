//
//  ViewController.swift
//  Podcast
//
//  Created by Drew Dunne on 4/25/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

/*
 * USAGE:
 *     Either override the function updateTableViewInsetsForAccessoryView() in your subclass
 *     and update the bottom UITableView insets to be large enough for the accessory view (miniplayer)
 * OR:
 *     Set the 'mainScrollView' property to be your view's UIScrollView/UITableView/UICollectionView/etc
 *         ex. mainScrollView = bookmarkTableView
 *     This way is easier but offers less flexibility (ex. doesn't work for multiple full screen tableViews on one view).
 *
 */

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .sea
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    var mainScrollView: UIScrollView?
    
    func updateTableViewInsetsForAccessoryView() {
        // Override this function in views with UITableViews
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate, let mainScrollView = mainScrollView else { return }
        if appDelegate.tabBarController.accessoryViewController == nil {
            mainScrollView.contentInset.bottom = appDelegate.tabBarController.tabBarHeight
        } else {
            let miniPlayerFrame = appDelegate.tabBarController.accessoryViewController?.accessoryViewFrame()
            if let accessoryFrame = miniPlayerFrame {
                mainScrollView.contentInset.bottom = appDelegate.tabBarController.tabBarHeight + accessoryFrame.height
            } else {
                mainScrollView.contentInset.bottom = appDelegate.tabBarController.tabBarHeight
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.backBarButtonItem?.title = ""
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateTableViewInsetsForAccessoryView()
        mainScrollView?.contentInsetAdjustmentBehavior = .automatic
    }

}
