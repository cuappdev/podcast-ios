//
//  NSAttributedString+.swift
//  Podcast
//
//  Created by Mindy Lou on 2/25/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import Foundation

extension NSAttributedString {

    /// Returns: Formatted text to have the proper line height, font, and color for episode descriptions.
    func toEpisodeDescriptionStyle(lineBreakMode: NSLineBreakMode? = nil) -> NSMutableAttributedString {
        let mutableString = NSMutableAttributedString(attributedString: self)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 4
        if let lineBreak = lineBreakMode {
            style.lineBreakMode = lineBreak
        }
        let attributes = [
            NSAttributedStringKey.paragraphStyle: style,
            NSAttributedStringKey.font: UIFont._14RegularFont(),
            NSAttributedStringKey.foregroundColor: UIColor.charcoalGrey
        ]
        mutableString.addAttributes(attributes, range: NSMakeRange(0, self.length))
        return mutableString
    }

    /// Returns: height/resize value for text given a width constraint.
    func height(withConstrainedWidth width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.toEpisodeDescriptionStyle().boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)

        return ceil(boundingBox.height)
    }

}
