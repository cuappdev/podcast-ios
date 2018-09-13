//
//  NavigationController.swift
//  Podcast
//
//  Created by Natasha Armbrust on 10/6/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        self.navigationBar.backgroundColor = .offWhite
        self.navigationBar.titleTextAttributes = UIFont.navigationBarDefaultFontAttributes
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
