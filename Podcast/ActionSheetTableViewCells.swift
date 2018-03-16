//
//  ActionSheetTableViewCells.swift
//  Podcast
//
//  Created by Natasha Armbrust on 3/16/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import UIKit

protocol ActionSheetTableViewCellProtocol: class {
    static var identifier: String { get }
    static var cellHeight: CGFloat { get }
    func setup(withOption option: ActionSheetOptionType)
}

// MARK
// MARK -- ActionSheetStandardTableViewCell
// MARK
class ActionSheetStandardTableViewCell: UITableViewCell {

    let padding: CGFloat = 18
    var leftPadding: CGFloat = 50
    var titleLabel: UILabel!
    var iconImage: UIImageView!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .offWhite
        separatorInset = UIEdgeInsets(top: 0, left: padding, bottom: 0, right: 0)

        titleLabel = UILabel()
        titleLabel.numberOfLines = 3
        titleLabel.font = ._14RegularFont()
        addSubview(titleLabel)

        iconImage = UIImageView()
        addSubview(iconImage)

        iconImage.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(padding)
            make.centerY.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(leftPadding)
            make.trailing.equalToSuperview().inset(padding)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup(withOption option: ActionSheetOptionType) {
        titleLabel.text = option.title
        titleLabel.textColor = option.titleColor
        iconImage.snp.remakeConstraints { make in
            make.leading.equalToSuperview().inset(padding)
            make.centerY.equalToSuperview()
            make.size.equalTo(option.iconImage?.size ?? 0)
        }
        iconImage.image = option.iconImage
    }

}

// MARK
// MARK -- ActionSheetMoreOptionsStandardTableViewCell
// MARK

class ActionSheetMoreOptionsStandardTableViewCell: ActionSheetStandardTableViewCell, ActionSheetTableViewCellProtocol {

    static var identifier: String = "actionSheetStandardTableViewCellIdentifier"
    static var cellHeight: CGFloat = 58


    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK
// MARK -- ActionSheetRecastDescriptionTableViewCell
// MARK

class ActionSheetRecastDescriptionTableViewCell: ActionSheetStandardTableViewCell, ActionSheetTableViewCellProtocol {
    static var identifier: String = "actionSheetRecastDescriptionTableViewCellIdentifier"
    static var cellHeight: CGFloat = 70

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK
// MARK -- ActionSheetPlayerControlsTableViewCell
// MARK

protocol ActionSheetPlayerControlsTableViewCellDelegate: class {
    func didPressSegmentedControlForTrimSilence(selected: Bool)
}

class ActionSheetPlayerControlsTableViewCell: UITableViewCell, ActionSheetTableViewCellProtocol {

    let padding: CGFloat = 18
    let leftPadding: CGFloat = 50

    static var identifier: String = "actionSheetPlayerControlsTableViewCellIdentifier"
    static var cellHeight: CGFloat = 58

    var switchControl: UISwitch!
    var titleLabel: UILabel!
    weak var delegate: ActionSheetPlayerControlsTableViewCellDelegate?

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .offWhite
        separatorInset = UIEdgeInsets(top: 0, left: padding, bottom: 0, right: 0)

        titleLabel = UILabel()
        titleLabel.numberOfLines = 3
        titleLabel.font = ._14RegularFont()
        addSubview(titleLabel)

        switchControl = UISwitch()
        switchControl.onTintColor = .sea
        switchControl.addTarget(self, action: #selector(segmentedControlPress), for: .valueChanged)
        addSubview(switchControl)

        switchControl.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(padding)
            make.centerY.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(switchControl.snp.trailing).offset(padding)
            make.trailing.equalToSuperview().inset(padding)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup(withOption option: ActionSheetOptionType) {
        titleLabel.text = option.title
        titleLabel.textColor = option.titleColor
        switch(option) {
        case .playerSettingsTrimSilence(let selected):
            switchControl.isOn = selected
        default:
            switchControl.isOn = false
        }
    }

    @objc func segmentedControlPress() {
        delegate?.didPressSegmentedControlForTrimSilence(selected: switchControl.isOn)
    }
}
