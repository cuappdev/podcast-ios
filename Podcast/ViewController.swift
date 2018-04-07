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
    
    let iPhoneXBottomOffset:CGFloat = 5
    var insetPadding: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if System.isiPhoneX() { insetPadding = iPhoneXBottomOffset }
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    func stylizeNavBar() {
        navigationController?.navigationBar.tintColor = .sea
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.backgroundColor = .offWhite
        navigationController?.navigationBar.barTintColor = .offWhite
        navigationController?.navigationBar.shadowImage = UIColor.silver.as1ptImage()
    }
    
    var mainScrollView: UIScrollView?
    
    func updateTableViewInsetsForAccessoryView() {
        // Override this function in views with UITableViews
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate, let mainScrollView = mainScrollView else { return }
        if appDelegate.tabBarController.accessoryViewController == nil {
            mainScrollView.contentInset.bottom = appDelegate.tabBarController.tabBar.frame.height - insetPadding
        } else {
            let miniPlayerFrame = appDelegate.tabBarController.accessoryViewController?.accessoryViewFrame()
            if let accessoryFrame = miniPlayerFrame {
                mainScrollView.contentInset.bottom = appDelegate.tabBarController.tabBar.frame.height + accessoryFrame.height - insetPadding
            } else {
                mainScrollView.contentInset.bottom = appDelegate.tabBarController.tabBar.frame.height - insetPadding
            }
        }
    }
    
    func mainScrollViewSetup() {
        mainScrollView?.contentInsetAdjustmentBehavior = .automatic
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.backBarButtonItem?.title = ""
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTableViewInsetsForAccessoryView()
        mainScrollViewSetup()
//        stylizeNavBar()
    }

    override func didMove(toParentViewController parent: UIViewController?) {
        super.didMove(toParentViewController: parent)
        stylizeNavBar()
    }

}
