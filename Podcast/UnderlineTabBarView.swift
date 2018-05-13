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

class UnderlineTabBarView: UIView {
    
    weak var delegate: TabBarDelegate?
    var tabButtons: [UIButton] = []
    var notificationLabels: [UILabel] = []
    var notificationViews: [UIView] = []
    var tabWidth: CGFloat!
    
    var underlineView: UIView!
    var selectedIndex: Int!
    
    let underlineHeight: CGFloat = 2
    let buttonTopOffset: CGFloat = 12
    let notificationPadding: CGFloat = 6
    let notificationHeight: CGFloat = 20
    let notificationOffset: CGFloat = 8
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .offWhite
    }
    
    func setUp(sections: [String]) {
        
        tabWidth = frame.width / CGFloat(sections.count)
        
        for (section, index) in zip(sections, 0 ..< sections.count) {
            let tabButton = Button()
            tabButton.setTitle(section, for: UIControlState())
            tabButton.setTitleColor(.charcoalGrey, for: UIControlState())
            tabButton.setTitleColor(.sea, for: .selected)
            tabButton.titleLabel?.textAlignment = .center
            tabButton.titleLabel?.font = ._12SemiboldFont()
            tabButton.addTarget(self, action: #selector(UnderlineTabBarView.tabButtonPressed(sender:)), for: .touchUpInside)
            addSubview(tabButton)
            tabButtons.append(tabButton)
            tabButton.snp.makeConstraints { make in
                // Logic here: offset the left side's center by 1/4 width,
                // offset the right tab's center by 1/4 of width
                make.centerX.equalToSuperview().offset(-frame.width/4 + CGFloat(index) * frame.width/2)
                make.top.equalToSuperview().offset(buttonTopOffset)
            }

            let notificationView = UIView()
            notificationView.backgroundColor = .rosyPink
            addSubview(notificationView)
            notificationViews.append(notificationView)
            notificationView.clipsToBounds = true
            notificationView.layer.cornerRadius = 10
            notificationView.isHidden = true
            notificationView.snp.makeConstraints { make in
                make.leading.equalTo(tabButtons[index].snp.trailing).offset(notificationOffset)
                make.centerY.equalTo(tabButtons[index])
                make.height.equalTo(notificationHeight)
            }

            let notificationLabel = UILabel()
            notificationLabel.backgroundColor = .clear
            notificationLabel.textColor = .offWhite
            notificationLabel.textAlignment = .center
            notificationLabel.font = ._10SemiboldFont()
            notificationLabel.isHidden = true
            notificationView.addSubview(notificationLabel)
            notificationLabels.append(notificationLabel)
            notificationLabel.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(notificationPadding)
            }
        }
        
        // Underline
        let underlineY = frame.height - underlineHeight
        underlineView = UIView(frame: CGRect(x: 0, y: underlineY, width: 0, height: underlineHeight))
        underlineView.backgroundColor = .sea
        underlineView.frame = underlineFrameForIndex(index: 0)
        
        selectedIndex = 0
        
        addSubview(underlineView)
        
        tabButtons.first?.isSelected = true
        
    }
    
    func underlineFrameForIndex(index: Int) -> CGRect {
        var rect = CGRect.zero
        
        rect.origin.x = CGFloat(index) * tabWidth
        rect.origin.y = frame.height - underlineHeight
        
        rect.size.width = tabWidth
        rect.size.height = underlineHeight
        
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

    /// Update the notification badge count for the specified index.
    func updateNotificationCount(to number: Int, for index: Int) {
        notificationLabels[index].isHidden = number == 0
        notificationViews[index].isHidden = number == 0
        notificationLabels[index].text = number > 20 ? "20+" : "\(number)"
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
