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
    
    // Returns the tableViewCell class and it's reuse id it should be registered with
    var reuseIdAndClass: (String, AnyClass) {
        switch self {
        case .textField:
            return ("textFieldSettingsCell", TextFieldSettingsTableViewCell.self)
        default:
            return ("settingsCell", SettingsTableViewCell.self)
        }
    }
}

struct SettingsPage {
    var id: String
    var parent: String
    var title: String
    var items: [SettingsSection]
    
    init(id: String, parent: String, title: String, items: [SettingsSection] = []) {
        self.id = id
        self.parent = parent
        self.title = title
        self.items = items
    }
}

/**
 * Create a section in settings by setting these
 */
struct SettingsSection {
    var id: String
    var header: String
    var footer: String
    var items: [SettingsField]
    
    init(id: String, items: [SettingsField] = [], header: String = "", footer: String = "") {
        self.id = id
        self.items = items
        self.header = header
        self.footer = footer
    }
}

/**
 * Each on of these in the items array of a section will be shown in that section
 */
struct SettingsField {
    var id: String
    var title: String
    var saveFunction: ((Any) -> Void)
    var type: SettingsFieldType
    var placeholder: String // Only used for TextField!
    var tapAction: (() -> Void) // User for disclosure, but applies to all
    
    init(id: String, title: String, saveFunction: @escaping ((Any) -> Void) = {_ in }, type: SettingsFieldType = .label, placeholder: String = "", tapAction: @escaping (() -> Void) = {}) {
        self.id = id
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
    var sections: [SettingsSection] = [] {
        didSet {
            if tableView != nil {
                self.tableView.reloadData()
            }
        }
    }
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
        tableView.backgroundColor = .paleGrey
        for type in SettingsFieldType.allValues {
            let (reuseId, cellClass):(String, AnyClass) = type.reuseIdAndClass
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
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    @objc private func saveAction() {
        for (i, section) in sections.enumerated() {
            for (j, setting) in section.items.enumerated() {
                switch setting.type {
                case .textField:
                    guard let cell = tableView.cellForRow(at: IndexPath(row: j, section: i)) as? TextFieldSettingsTableViewCell else {
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
    
    func setError(at index: IndexPath, with message: String) {
        // TODO: need fixing
        guard let cell = tableView(tableView, cellForRowAt: index) as? SettingsTableViewCell else {
            return
        }
        cell.displayError(error: message)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: setting.type.reuseIdAndClass.0, for: indexPath) as? SettingsTableViewCell ?? SettingsTableViewCell()
        cell.accessoryType = .none
        switch setting.type {
        case .disclosure:
            cell.accessoryType = .disclosureIndicator
            break
        case .button:
            cell.titleLabel.textColor = .blue
            break
        case .textField:
            let tcell = cell as? TextFieldSettingsTableViewCell ?? TextFieldSettingsTableViewCell()
            tcell.textField.text = ""
            break
        default: break
        }
        cell.setTitle(setting.title)
        //cell.clearError()
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let setting = sections[section]
        return setting.footer
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let setting = sections[section]
        return setting.header
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
