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
    case subscribe
    case follow
}

class FillButton: UIButton {
    
    var cornerRadius: CGFloat = 5
    var fillColor: UIColor = .clear
    var unfillColor: UIColor = .clear
    var borderColor: UIColor = .clear
    var textSelectedColor: UIColor = .white
    var textDeselectedColor: UIColor = .black
    var animates: Bool = false
    var animationDuration: Double = 0
    var fontSize: CGFloat = 12
    var fontWeight = UIFontWeightRegular
    
    init(type: FillButtonType) {
        super.init(frame: .zero)
        switch type {
        case .tag:
            unfillColor = UIColor.colorFromCode(0xF4F4F7)
            fillColor = .podcastGray
            animates = true
            animationDuration = 0.15
            borderColor = .clear
            textDeselectedColor = .tagButtonText
            textSelectedColor = .tagButtonText
            fontSize = 12
            fontWeight = UIFontWeightRegular
            break
        case .subscribe:
            fillColor = .podcastTeal
            unfillColor = .clear
            animates = false
            borderColor = .podcastTeal
            textDeselectedColor = .podcastTeal
            textSelectedColor = .podcastWhite
            fontSize = 14
            fontWeight = UIFontWeightRegular
            break
        case .follow:
            fillColor = .podcastWhite
            unfillColor = .clear
            animates = false
            borderColor = .podcastWhite
            textDeselectedColor = .podcastBlack
            textSelectedColor = .podcastWhite
            break
        }
        backgroundColor = unfillColor
        setTitleColor(textDeselectedColor, for: .normal)
        setTitleColor(textSelectedColor, for: .selected)
        setTitleColor(textSelectedColor, for: .highlighted)
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
