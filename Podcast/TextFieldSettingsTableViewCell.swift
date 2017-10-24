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
    let textFieldWidth: CGFloat = 30.0
    let textFieldPadding: CGFloat = 12.0
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        textField = UITextField(frame: CGRect.zero)
        textField.font = UIFont._14RegularFont()
        textField.textColor = .offBlack
        addSubview(textField)

        textField.snp.makeConstraints({ make in
            make.left.equalTo(titleLabel.snp.right).offset(textFieldPadding)
            make.right.equalToSuperview().inset(labelSidePadding)
            make.top.equalToSuperview().inset(labelTopPadding)
            make.bottom.equalToSuperview().inset(labelTopPadding)
            make.width.greaterThanOrEqualTo(textFieldWidth)
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getTextInput() -> String {
        return textField.text ?? ""
    }

}
