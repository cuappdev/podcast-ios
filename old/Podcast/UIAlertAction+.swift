//
//  UIAlertAction+.swift
//  Podcast
//
//  Created by Natasha Armbrust on 5/17/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import UIKit

extension UIAlertAction {

    /// use this to fix status bar bug
    convenience init(title: String?, handler: ((UIAlertAction) -> Swift.Void)? = nil) {
        let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
        let currentStatusBarColor = statusBar?.backgroundColor
        self.init(title: title, style: .default, handler: { action in
            statusBar?.backgroundColor = currentStatusBarColor
            handler?(action)
        })
    }
}
