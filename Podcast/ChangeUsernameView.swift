//
//  ChangeUsernameView.swift
//  Podcast
//
//  Created by Natasha Armbrust on 4/26/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

protocol ChangeUsernameViewDelegate: class  {
    func changeUsernameViewTextFieldDidEndEditing(changeUsernameView: ChangeUsernameView, username: String)
    func continueButtonPress(changeUsernameView: ChangeUsernameView)
    func changeUsernameViewTextFieldDidBeginEditing()
}

class ChangeUsernameView: UIView, UITextFieldDelegate {
    
    var welcomeLabel: UILabel!
    var instructionText: UILabel!
    var usernameTextField: UITextField!
    var continueButton: UIButton!
    weak var delegate: ChangeUsernameViewDelegate?
    var user: User!
    var successView: ImageView!
    
    //Constants
    var welcomeLabelHeight: CGFloat = 20
    var welcomeLabelY: CGFloat = 10
    var labelPadding: CGFloat = 10
    var instructionTextPaddingX: CGFloat = 40
    var usernameTextFieldPaddingX: CGFloat = 40
    var usernameTextFieldHeight: CGFloat = 20
    var usernameTextFieldLabelPadding: CGFloat = 20
    var continueButtonHeight: CGFloat = 40
    var successViewWidth: CGFloat = 9
    var successViewHeight: CGFloat = 9
    
    init(frame: CGRect, user: User) {
        super.init(frame: frame)
        
        backgroundColor = .offWhite
        welcomeLabel = UILabel(frame: CGRect(x: 0, y: welcomeLabelY, width: frame.width, height: welcomeLabelHeight))
        welcomeLabel.text = "Welcome, " + user.firstName
        welcomeLabel.textColor = .charcoalGrey
        welcomeLabel.textAlignment = .center
        welcomeLabel.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold)
        welcomeLabel.center.x = center.x
        addSubview(welcomeLabel)
        
        instructionText = UILabel(frame: CGRect(x: 0, y: welcomeLabel.frame.maxY + labelPadding, width: frame.width - 2 * instructionTextPaddingX, height: 0))
        instructionText.text = "Please create a username for your account"
        instructionText.textColor = .slateGrey
        instructionText.textAlignment = .center
        instructionText.numberOfLines = 2
        instructionText.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.regular)
        instructionText.sizeToFit()
        instructionText.center.x = center.x
        addSubview(instructionText)
        
        usernameTextField = UITextField(frame: CGRect(x: 0, y: instructionText.frame.maxY + usernameTextFieldLabelPadding, width: frame.width - 2 * usernameTextFieldPaddingX, height: usernameTextFieldHeight))
        usernameTextField.center.x = center.x
        let border = CALayer()
        border.borderColor = UIColor.paleGrey.cgColor
        border.frame = CGRect(x: 0, y: usernameTextField.frame.size.height - CGFloat(1.0), width: usernameTextField.frame.size.width, height: usernameTextField.frame.size.height)
        border.borderWidth = CGFloat(1.0)
        usernameTextField.layer.addSublayer(border)
        usernameTextField.layer.masksToBounds = true
        usernameTextField.placeholder = "Username"
        usernameTextField.textColor = .charcoalGrey
        usernameTextField.textAlignment = .center
        usernameTextField.autocapitalizationType = .none
        usernameTextField.delegate = self
        usernameTextField.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.regular)
        addSubview(usernameTextField)
        
        continueButton = UIButton(frame: CGRect(x: 0, y: frame.height - continueButtonHeight, width: frame.width, height: continueButtonHeight))
        continueButton.backgroundColor = .silver
        continueButton.setTitle("Get Started", for: .normal)
        continueButton.setTitleColor(.offWhite, for: .normal)
        continueButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold)
        continueButton.addTarget(self, action: #selector(continueButtonPress), for: .touchUpInside)
        continueButton.isEnabled = false
        addSubview(continueButton)
        
        successView = ImageView(frame: CGRect(x: usernameTextField.frame.maxX - successViewWidth, y: usernameTextField.frame.origin.y + successViewHeight/2, width: successViewWidth, height: successViewHeight))
        successView.image = #imageLiteral(resourceName: "success_icon")
        successView.isHidden = true
        addSubview(successView)
        
        layer.cornerRadius = 2
        clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func continueButtonPress() {
        delegate?.continueButtonPress(changeUsernameView: self)
    }
    
    func changeUsernameSuccess() {
        usernameTextField.isEnabled = true
        successView.image = #imageLiteral(resourceName: "success_icon")
        successView.isHidden = false
        continueButton.isEnabled = true
        continueButton.backgroundColor = .rosyPink
    }
    
    func changeUsernameFailure() {
        successView.image = #imageLiteral(resourceName: "failure_icon")
        successView.isHidden = false
        usernameTextField.isEnabled = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.isEnabled = false
        delegate?.changeUsernameViewTextFieldDidEndEditing(changeUsernameView: self, username: textField.text!)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        successView.isHidden = true
        continueButton.isEnabled = false
        continueButton.backgroundColor = .silver
        delegate?.changeUsernameViewTextFieldDidBeginEditing()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
