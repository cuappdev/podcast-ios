//
//  UIAlertController+.swift
//  Podcast
//
//  Created by Natasha Armbrust on 2/19/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import UIKit

extension UIAlertController {

    static func somethingWentWrongAlert() -> UIAlertController {
        let alert = UIAlertController(title: "Whoops an error occured!", message: "That's technology for ya", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        return alert
    }
}
