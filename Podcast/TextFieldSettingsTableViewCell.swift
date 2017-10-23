//
//  TextFieldSettingsTableViewCell.swift
//  Podcast
//
//  Created by Drew Dunne on 10/22/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class TextFieldSettingsTableViewCell: SettingsTableViewCell {

    var textField: UITextField!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        titleLabel.frame = CGRect(x: labelPadding, y: (height - labelHeight) / 2, width: frame.width - 2 * labelPadding, height: labelHeight)
        
        textField = UITextField(frame: CGRect.zero)
        textField.font = UIFont._14RegularFont()
        textField.textColor = .offBlack
        addSubview(textField)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getTextInput() -> String {
        return textField.text ?? ""
    }

}
