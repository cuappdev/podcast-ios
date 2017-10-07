//
//  UnderlineTabBarView.swift
//  Podcast
//
//  Created by Eric Appel on 11/4/15.
//  Copyright © 2015 CUAppDev. All rights reserved.
//

import UIKit

protocol TabBarDelegate: class {
    func selectedTabDidChange(toNewIndex newIndex: Int)
}

class UnderlineTabBarView: UIView, TabbedPageViewControllerDelegate {
    
    weak var delegate: TabBarDelegate?
    var tabButtons: [UIButton] = []
    var tabWidth: CGFloat!
    
    var underlineView: UIView!
    var selectedIndex: Int!
    
    let UnderlineHeight: CGFloat = 2
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .offWhite
    }
    
    func setUp(sections: [String]) {
        
        tabWidth = frame.width / CGFloat(sections.count)
        
        for (section, index) in zip(sections, 0 ..< sections.count) {
            let tabButton = UIButton()
            tabButton.setTitle(section, for: UIControlState())
            tabButton.setTitleColor(.charcoalGrey, for: UIControlState())
            tabButton.setTitleColor(.sea, for: .selected)
            tabButton.titleLabel?.font = ._12SemiboldFont()
            tabButton.addTarget(self, action: #selector(UnderlineTabBarView.tabButtonPressed(sender:)), for: .touchUpInside)
            tabButton.frame = CGRect(x: CGFloat(index) * tabWidth, y: 0, width: tabWidth, height: frame.height)
            addSubview(tabButton)
            tabButtons.append(tabButton)
        }
        
        // Underline
        let underlineY = frame.height - UnderlineHeight
        underlineView = UIView(frame: CGRect(x: 0, y: underlineY, width: 0, height: UnderlineHeight))
        underlineView.backgroundColor = .sea
        underlineView.frame = underlineFrameForIndex(index: 0)
        
        selectedIndex = 0
        
        addSubview(underlineView)
        
        tabButtons.first?.isSelected = true
        
    }
    
    func underlineFrameForIndex(index: Int) -> CGRect {
        var rect = CGRect.zero
        
        rect.origin.x = CGFloat(index) * tabWidth
        rect.origin.y = frame.height - UnderlineHeight
        
        rect.size.width = tabWidth
        rect.size.height = UnderlineHeight
        
        return rect
    }
    
    func updateSelectedTabAppearance(toNewIndex newIndex: Int) {
        UIView.animate(withDuration: 0.2, animations: {
            self.underlineView.frame = self.underlineFrameForIndex(index: newIndex)
            for tab in self.tabButtons {
                tab.isSelected = false
            }
            self.tabButtons[newIndex].isSelected = true
        })
    }
    
    @objc func tabButtonPressed(sender: UIButton) {
        let index = tabButtons.index(of: sender)!
        selectedIndex = index
        updateSelectedTabAppearance(toNewIndex: index)
        delegate?.selectedTabDidChange(toNewIndex: index)
    }
    
    func selectedTabDidChange(toNewIndex newIndex: Int) {
        updateSelectedTabAppearance(toNewIndex: newIndex)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Storyboards are not welcome here.")
    }
    
}
