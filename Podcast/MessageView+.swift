//
//  MessageView+.swift
//  Podcast
//
//  Created by Natasha Armbrust on 5/20/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import UIKit
import SwiftMessages

extension MessageView {

    static func showRecastView(for episode: Episode, completion: (()->())? = nil) {
        let duration: TimeInterval = 3
        let imageSize: CGFloat = 28

        let view = MessageView.viewFromNib(layout: .messageView)

        view.configureTheme(backgroundColor: .sea, foregroundColor: .offWhite, iconImage: nil, iconText: nil)

        view.configureDropShadow()

        let imageView = ImageView()
        imageView.setImageAsynchronouslyWithDefaultImage(url: episode.smallArtworkImageURL)

        view.configureContent(title: "You’ve successfully recasted \(episode.title)", body: nil, iconImage: imageView.image, iconText: nil, buttonImage: nil, buttonTitle: "Edit", buttonTapHandler: { _ in
            SwiftMessages.hide()
            completion?()
        })

        view.titleLabel?.font = ._12RegularFont()
        view.titleLabel?.numberOfLines = 0
        view.button?.titleLabel?.font = ._12SemiboldFont()

        var config = SwiftMessages.Config()
        config.duration = .seconds(seconds: duration)

        view.configureIcon(withSize: CGSize(width: imageSize, height: imageSize), contentMode: .scaleAspectFit)
        view.iconImageView?.addCornerRadius(height: imageSize)

        SwiftMessages.show(config: config, view: view)
    }
}
