//
//  ActivitityIndicatorView.swift
//  Podcast
//
//  Created by Natasha Armbrust on 11/14/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class LoadingAnimatorUtilities {

    static var loadingAnimatorSize: CGFloat = 30

    static func createLoadingAnimator() -> NVActivityIndicatorView {
        let color: UIColor = .sea
        let type: NVActivityIndicatorType = .lineScalePulseOut
        let frame = CGRect(x: 0, y: 0, width: loadingAnimatorSize, height: 2/3 * loadingAnimatorSize)
        return NVActivityIndicatorView(frame: frame, type: type, color: color, padding: 0)
    }

    static func createInfiniteScrollAnimator() -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: loadingAnimatorSize, height: loadingAnimatorSize))
        view.color = .sea
        return view
    }
}
