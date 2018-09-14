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
    let errorViewWidth: CGFloat = 17.0
    let accessoryViewPadding: CGFloat = 8
        
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        textField = UITextField(frame: CGRect.zero)
        textField.font = UIFont._14RegularFont()
        textField.textColor = .offBlack
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        addSubview(textField)

        textField.snp.makeConstraints({ make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(textFieldPadding)
            make.trailing.lessThanOrEqualToSuperview().inset(labelSidePadding)
            // no insets top and bottom (easier to tap)
            make.top.bottom.equalToSuperview()
            make.width.greaterThanOrEqualTo(textFieldWidth)
        })
        
        accessoryView = UIImageView(image: #imageLiteral(resourceName: "failure_icon"))
        addSubview(accessoryView!)
        accessoryView?.snp.makeConstraints({ make in
            make.leading.equalTo(textField.snp.trailing)
            make.height.width.equalTo(errorViewWidth).priority(999)
            make.trailing.equalToSuperview().inset(accessoryViewPadding)
            make.top.bottom.equalToSuperview().inset(height - 2 * errorViewWidth)
        })
        accessoryView?.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getTextInput() -> String {
        return textField.text ?? ""
    }
    
    override func displayError(error: String) {
        super.displayError(error: error)
        accessoryView?.isHidden = false
        bringSubview(toFront: accessoryView!)
        print("errors!")
    }
    
    override func clearError() {
        super.clearError()
        accessoryView?.isHidden = true
    }

}
