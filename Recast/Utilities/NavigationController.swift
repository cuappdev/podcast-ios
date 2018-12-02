//
//  NavigationController.swift
//  Recast
//
//  Created by Jack Thompson on 11/17/18.
//  Copyright © 2018 Cornell AppDev. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)

        navigationBar.prefersLargeTitles = true
        navigationBar.barTintColor = .black
        navigationBar.tintColor = .white
        navigationBar.isOpaque = true
        navigationBar.isTranslucent = false

        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationBar.titleTextAttributes = textAttributes
        navigationBar.largeTitleTextAttributes = textAttributes
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
