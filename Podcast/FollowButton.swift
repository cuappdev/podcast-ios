//
//  FollowButton.swift
//  Podcast
//
//  Created by Drew Dunne on 11/9/16.
//  Copyright © 2016 Cornell App Development. All rights reserved.
//

import UIKit

class FollowButton: UIButton {
    
    init() {
        super.init(frame: .zero)
        isSelected = false
        titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightSemibold)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        let ctx:CGContext = UIGraphicsGetCurrentContext()!;
        let strokeColor: CGColor = self.tintColor.cgColor
        let fillColor: CGColor = UIColor.podcastWhite.cgColor
        ctx.setFillColor(fillColor)
        ctx.setStrokeColor(strokeColor)
        ctx.saveGState()
        let lineWidth: CGFloat = 1.0;
        ctx.setLineWidth(lineWidth)
        let outlinePath: UIBezierPath = UIBezierPath(roundedRect: self.bounds.insetBy(dx: lineWidth, dy: lineWidth), byRoundingCorners: UIRectCorner.allCorners, cornerRadii: CGSize(width: self.bounds.size.height/2, height: self.bounds.size.height/2))
        ctx.addPath(outlinePath.cgPath)
        ctx.strokePath()
        ctx.restoreGState()
        
        titleLabel?.textColor = (isSelected == true) ? UIColor.podcastWhite : UIColor.podcastBlack
        
        if (self.isSelected == false) {
            ctx.saveGState()
            let fillPath: UIBezierPath = UIBezierPath(roundedRect: self.bounds.insetBy(dx: lineWidth, dy: lineWidth), byRoundingCorners: UIRectCorner.allCorners, cornerRadii: CGSize(width: self.bounds.size.height/2, height: self.bounds.size.height/2))
            ctx.addPath(fillPath.cgPath)
            ctx.fillPath()
            ctx.restoreGState()
        }
    }
    
    override var frame: CGRect {
        didSet {
            super.frame = frame
            self.setNeedsDisplay()
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            super.isHighlighted = isHighlighted
            self.setNeedsDisplay()
        }
    }
    
    override var isSelected: Bool {
        didSet {
            super.isSelected = isSelected
            self.setNeedsDisplay()
        }
    }

}
