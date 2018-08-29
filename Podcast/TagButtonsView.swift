//
//  TopicButtonsView.swift
//  Podcast
//
//  Created by Natasha Armbrust on 3/1/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

//tav view for episode and card cell where topics are clickable buttons
class TopicButtonsView: UIView {
    
    var topicButtonPaddingX: CGFloat = 17
    var topicButtonHeight: CGFloat = 18
    
    var topicButtons: [UIButton] = []
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepareForReuse() {
        for button in topicButtons {
            button.removeFromSuperview()
        }
        topicButtons = []
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    //setup topic Buttons
    func setupTopicButtons(topics: [Topic]) {
        // Create topics (Need no topics design)
        topicButtons = []
        let width = UIScreen.main.bounds.width
        if !topics.isEmpty {
            var remainingWidth = width - 2 * topicButtonPaddingX
            let moreTopics = UIButton(frame: CGRect.zero)
            moreTopics.setTitle("and \(topics.count) more", for: .normal)
            moreTopics.isEnabled = false
            moreTopics.titleLabel?.font = ._12RegularFont()
            moreTopics.setTitleColor(.charcoalGrey, for: .normal)
            moreTopics.sizeToFit()
            remainingWidth = remainingWidth - moreTopics.frame.width
            var offset: CGFloat = 0
            var numAdded = 0
            for index in 0 ..< topics.count {
                let topic = topics[index]
                let topicButton = UIButton(frame: CGRect.zero)
                if index == topics.count - 1 {
                    topicButton.setTitle("and " + topic.name, for: .normal)
                } else {
                    topicButton.setTitle(topic.name + ", ", for: .normal)
                }
                topicButton.titleLabel?.font = ._12RegularFont()
                topicButton.setTitleColor(.charcoalGrey, for: .normal)
                topicButton.sizeToFit()
                
                if topicButton.frame.width < remainingWidth {
                    // Add topic
                    topicButton.frame = CGRect(x: topicButtonPaddingX + offset, y: 0, width: topicButton.frame.width, height: topicButtonHeight)
                    topicButton.tag = index
                    self.addSubview(topicButton)
                    topicButtons.append(topicButton)
                    remainingWidth = remainingWidth - topicButton.frame.width
                    offset = offset + topicButton.frame.width
                    numAdded += 1
                }
            }
            
            if (topics.count != numAdded) {
                moreTopics.setTitle("and \(topics.count-numAdded) more", for: .normal)
                moreTopics.sizeToFit()
                moreTopics.frame = CGRect(x: topicButtonPaddingX + offset, y: 0, width: moreTopics.frame.width, height: topicButtonHeight)
                self.addSubview(moreTopics)
                topicButtons.append(moreTopics)
            }
        } else {
            topicButtonHeight = 0
        }
    }
}
