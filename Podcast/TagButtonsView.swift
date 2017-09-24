//
//  TagButtonsView.swift
//  Podcast
//
//  Created by Natasha Armbrust on 3/1/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

//tav view for episode and card cell where tags are clickable buttons
class TagButtonsView: UIView {
    
    var tagButtonPaddingX: CGFloat = 17
    var tagButtonHeight: CGFloat = 18
    
    var tagButtons: [UIButton] = []
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepareForReuse() {
        for button in tagButtons {
            button.removeFromSuperview()
        }
        tagButtons = []
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    //setup tag Buttons
    func setupTagButtons(tags: [Tag]) {
        // Create tags (Need no tags design)
        tagButtons = []
        let width = UIScreen.main.bounds.width
        if tags.count > 0 {
            var remainingWidth = width - 2 * tagButtonPaddingX
            let moreTags = UIButton(frame: CGRect.zero)
            moreTags.setTitle("and \(tags.count) more", for: .normal)
            moreTags.isEnabled = false
            moreTags.titleLabel?.font = UIFont.systemFont(ofSize: 13.0)
            moreTags.setTitleColor(.podcastGrayDark, for: .normal)
            moreTags.sizeToFit()
            remainingWidth = remainingWidth - moreTags.frame.width
            var offset: CGFloat = 0
            var numAdded = 0
            for index in 0 ..< tags.count {
                let tag = tags[index]
                let tagButton = UIButton(frame: CGRect.zero)
                if index == tags.count - 1 {
                    tagButton.setTitle("and " + tag.name, for: .normal)
                } else {
                    tagButton.setTitle(tag.name + ", ", for: .normal)
                }
                tagButton.titleLabel?.font = UIFont.systemFont(ofSize: 13.0)
                tagButton.setTitleColor(.podcastGrayDark, for: .normal)
                tagButton.sizeToFit()
                
                if tagButton.frame.width < remainingWidth {
                    // Add tag
                    tagButton.frame = CGRect(x: tagButtonPaddingX + offset, y: 0, width: tagButton.frame.width, height: tagButtonHeight)
                    tagButton.tag = index
                    self.addSubview(tagButton)
                    tagButtons.append(tagButton)
                    remainingWidth = remainingWidth - tagButton.frame.width
                    offset = offset + tagButton.frame.width
                    numAdded += 1
                }
            }
            
            if (tags.count != numAdded) {
                moreTags.setTitle("and \(tags.count-numAdded) more", for: .normal)
                moreTags.sizeToFit()
                moreTags.frame = CGRect(x: tagButtonPaddingX + offset, y: 0, width: moreTags.frame.width, height: tagButtonHeight)
                self.addSubview(moreTags)
                tagButtons.append(moreTags)
            }
        } else {
            tagButtonHeight = 0
        }
    }
}
