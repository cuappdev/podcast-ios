//
//  SettingsPageViewController.swift
//  Podcast
//
//  Created by Drew Dunne on 10/22/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

// Add more field types as created
// String value is cell reuse ID
enum SettingsFieldType {
    case button
    case textField
    case disclosure
    case label
    case toggle
    
    static let allValues: [SettingsFieldType] = [.button, .textField, .disclosure, .label, .toggle]
    
    func getReuseIDAndClass() -> (String, AnyClass) {
        switch self {
        case .textField:
            return ("textFieldSettingsCell", TextFieldSettingsTableViewCell.self)
        default:
            return ("settingsCell", SettingsTableViewCell.self)
        }
    }
}

/**
 * Create a section in settings by setting these
 */
struct SettingsSection {
    var header: String?
    var footer: String?
    var items: [SettingsField]
    
    init(items: [SettingsField]) {
        self.items = items
    }
}

/**
 * Each on of these in the items array of a section will be shown in that section
 */
struct SettingsField {
    var title: String
    var saveFunction: ((Any) -> Void)
    var type: SettingsFieldType
    var placeholder: String // Only used for TextField!
    var tapAction: (() -> Void) // User for disclosure, but applies to all
    
    init(title: String, saveFunction: @escaping ((Any) -> Void) = {_ in }, type: SettingsFieldType = .label, placeholder: String = "", tapAction: @escaping (() -> Void) = {}) {
        self.title = title
        self.saveFunction = saveFunction
        self.type = type
        self.placeholder = placeholder
        self.tapAction = tapAction
    }
}

/**
 * SettingsPageViewController is a settings controller where changing the sections and items
 * array will dynamically create a settings view with desired actions.
 */
class SettingsPageViewController: ViewController, UITableViewDelegate, UITableViewDataSource {

    // View items
    private var tableView: UITableView!
    private var saveButton: UIBarButtonItem!
    
    // Can change this but not recommended
    var sectionSpacing: CGFloat = 18
    
    // Settable configurations
    var sections: [SettingsSection] = []
    var showSave: Bool! {
        didSet {
            if showSave {
                navigationItem.rightBarButtonItem = saveButton
            } else {
                navigationItem.rightBarButtonItem = nil
            }
        }
    }
    var returnOnSave:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.showsVerticalScrollIndicator = true
        tableView.allowsSelection = false
        tableView.backgroundColor = .paleGrey
        for type in SettingsFieldType.allValues {
            let (reuseId, cellClass):(String, AnyClass) = type.getReuseIDAndClass()
            tableView.register(cellClass, forCellReuseIdentifier: reuseId)
        }
        tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = true
        mainScrollView = tableView
        view.addSubview(tableView)
        
        saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveAction))
        if showSave {
            navigationItem.rightBarButtonItem = saveButton
        } else {
            navigationItem.rightBarButtonItem = nil
        }
        
        tableView.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
    }
    
    @objc private func saveAction() {
        for (i, section) in sections.enumerated() {
            for (j, setting) in section.items.enumerated() {
                switch setting.type {
                case .textField:
                    guard let cell = tableView.cellForRow(at: IndexPath(row: j, section: i)) as? TextFieldSettingsTableViewCell else {
                        // TODO: create some sort of error marking for cells
                        return
                    }
                    setting.saveFunction(cell.getTextInput())
                    break
                default: setting.saveFunction(())
                }
            }
        }
        if returnOnSave {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func setError(atIndex: IndexPath, withMessage: String) {
        // TODO: Need ideas for error signaling
    }
    
    // MARK: UITableViewDelegate & UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SettingsTableViewCell.height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let setting = sections[indexPath.section].items[indexPath.row]
        var cell = tableView.dequeueReusableCell(withIdentifier: setting.type.getReuseIDAndClass().0, for: indexPath) as? SettingsTableViewCell ?? SettingsTableViewCell()
        cell.accessoryType = .none
        switch setting.type {
        case .disclosure:
            cell.accessoryType = .disclosureIndicator
            break
        case .button:
            cell.titleLabel.textColor = .blue
            break
        case .textField:
            cell = cell as? TextFieldSettingsTableViewCell ?? TextFieldSettingsTableViewCell()
            break
        default: break
        }
        cell.setTitle(setting.title)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionSpacing
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        let setting = sections[indexPath.section].items[indexPath.row]
        switch setting.type {
        case .disclosure: return true
        default: return false
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let setting = sections[indexPath.section].items[indexPath.row]
        setting.tapAction()
    }

}
