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
            return #imageLiteral(resourceName: "radio")
        case .connect:
            return #imageLiteral(resourceName: "human")
        case .recast:
            return #imageLiteral(resourceName: "recast")
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
            //return "Like comedy podcasts? Find others within the same genre, get personalized recommendations, and discover trending episodes and series!"
            return "Find new podcasts by exploring what's trending and browsing curated content based on your interests."
        case .connect:
            //return "Finally a social podcast app. Find your friends to see what they are listening to, privately share podcasts with others, and follow top podcasters to find curated content."
            return "See what your friends are listening to, share suggestions, and receive recommendations."
        case .recast:
            return "Recasting lets you recommend podcasts you love and find new favorites to listen to."
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
            make.centerX.equalToSuperview()
            make.bottom.equalTo(snp.bottom).multipliedBy(0.35)
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
