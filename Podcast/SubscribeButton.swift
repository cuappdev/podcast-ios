//
//  SubscribeButton.swift
//  Podcast
//
//  Created by Drew Dunne on 2/18/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class SubscribeButton: UIButton {
    
    let cornerRadius: CGFloat = 5
    
    init() {
        super.init(frame: .zero)
        isSelected = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let ctx: CGContext = UIGraphicsGetCurrentContext()!
        let strokeColor: CGColor = UIColor.podcastTeal.cgColor
        let fillColor: CGColor = UIColor.podcastTeal.cgColor
        ctx.setFillColor(fillColor)
        ctx.setStrokeColor(strokeColor)
        ctx.saveGState()
        let lineWidth: CGFloat = 1.0
        ctx.setLineWidth(lineWidth)
        let outlinePath: UIBezierPath = UIBezierPath(roundedRect: bounds.insetBy(dx: lineWidth, dy: lineWidth), byRoundingCorners: UIRectCorner.allCorners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        ctx.addPath(outlinePath.cgPath)
        ctx.strokePath()
        ctx.restoreGState()
        
        titleLabel?.textColor = isSelected || isHighlighted ? .podcastWhite : .podcastTeal
        
        if isSelected || isHighlighted {
            ctx.saveGState()
            let fillPath: UIBezierPath = UIBezierPath(roundedRect: bounds.insetBy(dx: lineWidth, dy: lineWidth), byRoundingCorners: .allCorners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
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
