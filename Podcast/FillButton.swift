//
//  FillButton.swift
//  Podcast
//
//  Created by Drew Dunne on 2/26/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

enum FillButtonType {
    case tag
    case subscribePicture
    case follow
    case followWhite
}

class FillButton: Button {
    
    var type: FillButtonType!
    
    var cornerRadius: CGFloat = 5
    var fillColor: UIColor = .clear
    var unfillColor: UIColor = .clear
    var borderColor: UIColor = .clear
    var selectedTextColor: UIColor = .offWhite
    var deselectedTextColor: UIColor = .offBlack
    var animates: Bool = false
    var animationDuration: Double = 0
    var fontSize: CGFloat = 12
    var fontWeight = UIFont.Weight.regular
    
    init(type: FillButtonType) {
        super.init()
        self.type = type
        switch type {
        case .tag:
            unfillColor = .lightGrey
            fillColor = .paleGrey
            animates = true
            animationDuration = 0.15
            borderColor = .clear
            deselectedTextColor = .charcoalGrey
            selectedTextColor = .charcoalGrey
            fontSize = 12
            fontWeight = UIFont.Weight.regular
            break
        case .subscribePicture:
            setImage(#imageLiteral(resourceName: "subscribe_button"), for: .normal)
            setImage(#imageLiteral(resourceName: "subscribed_button"), for: .selected)
        case .follow:
            fillColor = .offWhite
            unfillColor = .clear
            animates = false
            borderColor = .offWhite
            deselectedTextColor = .offWhite
            selectedTextColor = .offBlack
            fontSize = 14
            fontWeight = UIFont.Weight.regular
            break
        case .followWhite:
            unfillColor = .offWhite
            fillColor = .sea
            animates = true
            animationDuration = 0.15
            borderColor = .sea
            deselectedTextColor = .sea
            selectedTextColor = .offWhite
            fontSize = 14
            fontWeight = UIFont.Weight.regular
        }
        backgroundColor = unfillColor
        setTitleColor(deselectedTextColor, for: .normal)
        setTitleColor(selectedTextColor, for: .selected)
        setTitleColor(selectedTextColor, for: .highlighted)
        setTitleColor(deselectedTextColor, for: .disabled)
        titleLabel?.font = .systemFont(ofSize: fontSize, weight:fontWeight)
        layer.cornerRadius = cornerRadius
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isHighlighted: Bool {
        didSet {
            super.isHighlighted = isHighlighted
            UIView.animate(withDuration: animationDuration, animations: {
                if self.isHighlighted || self.isSelected {
                    self.backgroundColor = self.fillColor
                } else {
                    self.backgroundColor = self.unfillColor
                }
            })
            setNeedsDisplay()
        }
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
