//
//  FillNumberButton.swift
//  Podcast
//
//  Created by Natasha Armbrust on 11/2/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

enum FillNumberButtonType {
    case subscribe
    case recommend
}

class FillNumberButton: Button {

    let type: FillNumberButtonType
    let buttonTitlePadding: CGFloat = 7
    var fillColor: UIColor = .clear
    var unfillColor: UIColor = .clear
    
    init(type: FillNumberButtonType) {
        self.type = type
        super.init()
        
        switch(type) {
        case .subscribe:
            fillColor = .sea
            unfillColor = .clear
            setupWithNumber(isSelected: false, numberOf: 0)
            setTitleColor(.sea, for: .normal)
            setTitleColor(.offWhite, for: .selected)
            setTitleColor(.sea, for: .highlighted)
            setTitleColor(.offWhite, for: .disabled)
            titleLabel?.font = ._14RegularFont()
            layer.cornerRadius = 5
            layer.borderWidth = 1
            layer.borderColor = UIColor.sea.cgColor
            
        case .recommend:
            setupWithNumber(isSelected: false, numberOf: 0)
            setImage(#imageLiteral(resourceName: "heart_icon"), for: .normal)
            setImage(#imageLiteral(resourceName: "heart_icon_selected"), for: .selected)
            contentHorizontalAlignment = .left
            titleEdgeInsets = UIEdgeInsets(top: 0, left: buttonTitlePadding, bottom: 0, right: 0)
            setTitleColor(.charcoalGrey, for: .normal)
            setTitleColor(.rosyPink, for: .selected)
            titleLabel?.font = ._12RegularFont()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupWithNumber(isSelected: Bool, numberOf: Int) {
        self.isSelected = isSelected
        var titleString: String
        switch(type) {
        case .subscribe:
            titleString = isSelected ? "Subscribed" : "Subscribe"
            if numberOf > 0 {
                titleString += "  |  \(numberOf.shortString())"
            }
        case .recommend:
            titleString = numberOf > 0 ? numberOf.shortString() : ""
        }
        setTitle(titleString, for: .normal)
    }
    
    override var isSelected: Bool {
        didSet {
            super.isSelected = isSelected
            if self.isSelected {
                self.backgroundColor = fillColor
            } else {
                self.backgroundColor = unfillColor
            }
            setNeedsDisplay()
        }
    }

}
