//
//  OnboardingView.swift
//  Podcast
//
//  Created by Natasha Armbrust on 3/1/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import UIKit

enum OnboardingType {
    case discover
    case connect
    case recast

    var image: UIImage? {
        switch(self) {
        case .discover:
            return #imageLiteral(resourceName: "discover_tab_bar_unselected")
        case .connect:
            return #imageLiteral(resourceName: "person")
        case .recast:
            return #imageLiteral(resourceName: "repost")
        }
    }

    var title: String {
        switch(self) {
        case .discover:
            return "Discover"
        case .connect:
            return "Connect"
        case .recast:
            return "Recast"
        }
    }

    var explanation: String {
        switch(self) {
        case .discover:
            return "Like comedy podcasts? Find others within the same genre, get personalized recommendations, and discover trending episodes and series!"
        case .connect:
            return "Finally a social podcast app. Find your friends to see what they are listening to, privately share podcasts with others, and follow top podcasters to find curated content."
        case .recast:
            return "Publically share your favorite podcasts by recasting them to your followers!"
        }
    }
}

class OnboardingView: UIView {

    var imageView: UIImageView!
    var title: UILabel!
    var explanation: UILabel!
    let type: OnboardingType

    let titlePadding: CGFloat = 40
    let explanationPadding: CGFloat = 8
    let explanationInset: CGFloat = 50

    init(type: OnboardingType) {
        self.type = type
        super.init(frame: .zero)

        imageView = UIImageView()
        imageView.image = type.image
        addSubview(imageView)

        title = UILabel()
        title.font = ._20SemiboldFont()
        title.textColor = .offWhite
        title.textAlignment = .center
        title.text = type.title
        addSubview(title)

        explanation = UILabel()
        explanation.numberOfLines = 5
        explanation.textAlignment = .center
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        paragraphStyle.alignment = .center
        let attributes = [
            NSAttributedStringKey.paragraphStyle: paragraphStyle,
            NSAttributedStringKey.font: UIFont._16RegularFont(),
            NSAttributedStringKey.foregroundColor: UIColor.offWhite,
        ]
        let attrString = NSMutableAttributedString(string: type.explanation)
        attrString.addAttributes(attributes, range: NSMakeRange(0, attrString.length))
        explanation.attributedText = attrString
        addSubview(explanation)

        imageView.snp.makeConstraints { make in
            make.size.equalTo(100)
            make.centerX.equalToSuperview()
            make.centerY.equalTo(snp.bottom).multipliedBy(0.25)
        }

        title.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(titlePadding)
        }

        explanation.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(explanationInset)
            make.top.equalTo(title.snp.bottom).offset(explanationPadding)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
