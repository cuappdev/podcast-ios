//
//  Label+.swift
//  Podcast
//
//  Created by Natasha Armbrust on 9/11/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

extension UILabel {
    
    //@param: label with text,font,and width
    // Changes height of label to fit text with current font and width
    //@return: None
    static func adjustHeightToFit(label: UILabel, numberOfLines: Int? = nil) {
        let newLabel = UILabel(frame: .zero)
        let size = CGSize(width: label.frame.width, height: CGFloat.greatestFiniteMagnitude)
        newLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        newLabel.font = label.font
        newLabel.text = label.text
        newLabel.numberOfLines = numberOfLines ?? label.numberOfLines
        let newSize = newLabel.sizeThatFits(size)
        
        label.frame.size = newSize
        label.numberOfLines = numberOfLines ?? label.numberOfLines
    }

    // taken from https://stackoverflow.com/questions/32309247/add-read-more-to-the-end-of-uilabel
    static func addTrailing(to label: UILabel, with trailingText: String, moreText: String, moreTextFont: UIFont, moreTextColor: UIColor, numberOfLinesAllowed: Int) -> NSAttributedString {
        guard let text = label.text else { return NSAttributedString() }
        if label.numberOfVisibleLines <= numberOfLinesAllowed {
            return NSAttributedString(string: text, attributes: [NSAttributedStringKey.font: label.font])
        }
        let readMoreText = trailingText + moreText
        let lengthForVisibleString = label.vissibleTextLength
        let mutableString = text
        let trimmedString = (mutableString as NSString).replacingCharacters(in: NSRange(location: lengthForVisibleString, length: (text.count - lengthForVisibleString)), with: "")
        let readMoreLength = readMoreText.count
        let trimmedForReadMore: String = (trimmedString as NSString).replacingCharacters(in: NSRange(location: ((trimmedString.count ?? 0) - readMoreLength), length: readMoreLength), with: "") + trailingText
        let answerAttributed = NSMutableAttributedString(string: trimmedForReadMore, attributes: [NSAttributedStringKey.font: label.font])
        let readMoreAttributed = NSMutableAttributedString(string: moreText, attributes: [NSAttributedStringKey.font: moreTextFont, NSAttributedStringKey.foregroundColor: moreTextColor])
        answerAttributed.append(readMoreAttributed)
        return answerAttributed
    }

    var numberOfVisibleLines: Int {
        let textSize = CGSize(width: CGFloat(self.frame.size.width), height: CGFloat(MAXFLOAT))
        let rHeight: Int = lroundf(Float(self.sizeThatFits(textSize).height))
        let charSize: Int = lroundf(Float(self.font.pointSize))
        return rHeight / charSize
    }

    // taken from https://stackoverflow.com/questions/32309247/add-read-more-to-the-end-of-uilabel
    var vissibleTextLength: Int {
        guard let _ = self.text else { return 0 }
        let font: UIFont = self.font
        let mode: NSLineBreakMode = self.lineBreakMode
        let labelWidth: CGFloat = self.frame.size.width
        let labelHeight: CGFloat = self.frame.size.height
        let sizeConstraint = CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude)

        let attributes: [AnyHashable: Any] = [NSAttributedStringKey.font: font]
        let attributedText = NSAttributedString(string: self.text!, attributes: attributes as? [NSAttributedStringKey : Any])
        let boundingRect: CGRect = attributedText.boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, context: nil)

        if boundingRect.size.height > labelHeight {
            var index: Int = 0
            var prev: Int = 0
            let characterSet = CharacterSet.whitespacesAndNewlines
            repeat {
                prev = index
                if mode == NSLineBreakMode.byCharWrapping {
                    index += 1
                } else {
                    index = (self.text! as NSString).rangeOfCharacter(from: characterSet, options: [], range: NSRange(location: index + 1, length: self.text!.count - index - 1)).location
                }
            } while index != NSNotFound && index < self.text!.count && (self.text! as NSString).substring(to: index).boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, attributes: attributes as? [NSAttributedStringKey : Any], context: nil).size.height <= labelHeight
            return prev
        }
        return self.text!.count
    }
}
