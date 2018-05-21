//
//  MessageView+.swift
//  Podcast
//
//  Created by Natasha Armbrust on 5/20/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import UIKit
import SwiftMessages

enum MessageViewType {
    case recast(episode: Episode)
    case share(episode: Episode, user: User)

    var title: String {
        switch self {
        case .recast(let episode):
            return "You’ve successfully recasted \(episode.title)"
        case .share(let episode, let user):
            return "You've successfully shared \(episode.title) with \(user.fullName())"
        }
    }

    var image: UIImage? {
        switch self {
            case .recast(let episode), .share(let episode, _):
                let imageView = ImageView()
                imageView.setImageAsynchronouslyWithDefaultImage(url: episode.smallArtworkImageURL)
                return imageView.image
        }
    }

    func buttonAssets() -> (image: UIImage?, title: String?, handler: (() -> ())?)? {
        switch self {
        case .recast:
            return (nil, "Edit", nil)
        default:
            return nil
        }
    }
}

extension MessageView {

    static func show(with type: MessageViewType, completion: (()->())? = nil) {
        let duration: TimeInterval = 3
        let imageSize: CGFloat = 28

        let view = MessageView.viewFromNib(layout: .messageView)

        view.configureTheme(backgroundColor: .sea, foregroundColor: .offWhite, iconImage: nil, iconText: nil)

        view.configureDropShadow()

        let buttonAssets = type.buttonAssets()
        view.configureContent(title: type.title, body: nil, iconImage: type.image, iconText: nil, buttonImage: buttonAssets?.image, buttonTitle: buttonAssets?.title, buttonTapHandler: { _ in
            buttonAssets?.handler?()
            SwiftMessages.hide()
            completion?()
        })

        view.button?.isHidden = buttonAssets == nil
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
