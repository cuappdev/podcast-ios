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
}
