//
//  UnderlineTabBarView.swift
//  Eatery
//
//  Created by Eric Appel on 11/4/15.
//  Copyright © 2015 CUAppDev. All rights reserved.
//

import UIKit

protocol TabBarDelegate: class {
    func selectedTabDidChange(_ newIndex: Int)
}

private let kUnderlineHeight: CGFloat = 2

class UnderlineTabBarView: UIView, TabbedPageViewControllerDelegate {
    
    weak var delegate: TabBarDelegate?
    var tabButtons: [UIButton] = []
    var tabWidth: CGFloat!
    
    var underlineView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
    }
    
    func setUp(_ sections: [String]) {
        
        tabWidth = frame.width / CGFloat(sections.count)
        
        for (section, index) in zip(sections, 0..<sections.count) {
            let tabButton = UIButton()
            tabButton.setTitle(section, for: UIControlState())
            tabButton.setTitleColor(.podcastGrayDark, for: UIControlState())
            tabButton.setTitleColor(.podcastGreenBlue, for: .selected)
            tabButton.titleLabel?.font = .systemFont(ofSize: 12, weight: UIFontWeightSemibold)
            tabButton.addTarget(self, action: #selector(UnderlineTabBarView.tabButtonPressed(_:)), for: .touchUpInside)
            tabButton.frame = CGRect(x: CGFloat(index) * tabWidth, y: 0, width: tabWidth, height: frame.height)
            addSubview(tabButton)
            tabButtons.append(tabButton)
        }
        
        // Underline
        let underlineY = frame.height - kUnderlineHeight
        underlineView = UIView(frame: CGRect(x: 0, y: underlineY, width: 0, height: kUnderlineHeight))
        underlineView.backgroundColor = .podcastGreenBlue
        underlineView.frame = underlineFrameForIndex(0)
        
        addSubview(underlineView)
        
        tabButtons.first!.isSelected = true
        
    }
    
    func underlineFrameForIndex(_ index: Int) -> CGRect {
        var rect = CGRect.zero
        
        rect.origin.x = CGFloat(index) * tabWidth
        rect.origin.y = frame.height - kUnderlineHeight
        
        rect.size.width = tabWidth
        rect.size.height = kUnderlineHeight
        
        return rect
    }
    
    func updateSelectedTabAppearance(_ newIndex: Int) {
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.underlineView.frame = self.underlineFrameForIndex(newIndex)
            for tab in self.tabButtons {
                tab.isSelected = false
            }
            self.tabButtons[newIndex].isSelected = true
        })
    }
    
    func tabButtonPressed(_ sender: UIButton) {
        let index = tabButtons.index(of: sender)!
        updateSelectedTabAppearance(index)
        delegate?.selectedTabDidChange(index)
    }
    
    func selectedTabDidChange(_ newIndex: Int) {
        updateSelectedTabAppearance(newIndex)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Storyboards are not welcome here.")
    }
    
}
