
import UIKit

// Make an action class for each action sheet option
// upon tap -> complete action
class ActionSheetOption {
    
    var type: ActionSheetOptionType
    var action: (() -> ())?
    
    init(type: ActionSheetOptionType, action: (() -> ())?) {
        self.type = type
        self.action = action
    }
    
}

// Make a header class if you want a header for your action sheet
class ActionSheetHeader {
    
    var image: UIImage
    var title: String
    var description: String
    
    init(image: UIImage, title: String, description: String) {
        self.image = image
        self.title = title
        self.description = description
    }
    
}

protocol ActionSheetViewControllerPlayerControlsDelegate: class {
    func didPressSegmentedControlForTrimSilence(selected: Bool)
    func didPressSegmentedControlForSavePreferences(selected: Bool)
}

protocol ActionSheetViewControllerRecastBlurbDelegate: class {
    func didPressSaveRecast(with blurb: String)
}

class ActionSheetViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ActionSheetPlayerControlsTableViewCellDelegate, ActionSheetCreateRecastBlurbTableViewCellDelegate {
    
    var actionSheetContainerView: UIView!
    var optionTableView: UITableView!
    var headerView: ActionSheetHeaderView?
    var cancelButton: UIButton!
    var cancelButtonTitle: String = "Cancel"
    var darkBackgroundView: UIButton!
    var currentStatusBarColor: UIColor?
    var separatorColor: UIColor = .lightGrey
    
    var safeArea: UIEdgeInsets!
    
    var headerViewHeight: CGFloat = 94
    let cancelButtonHeight: CGFloat = 58
    var padding: CGFloat = 18
    
    var options: [ActionSheetOption]
    var header: ActionSheetHeader?
    weak var playerControlsDelegate: ActionSheetViewControllerPlayerControlsDelegate?
    weak var recastBlurbDelegate: ActionSheetCreateRecastBlurbTableViewCellDelegate?
    
    init(options: [ActionSheetOption], header: ActionSheetHeader?) {
        self.options = options
        self.header = header
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        safeArea = UIApplication.shared.delegate?.window??.safeAreaInsets
        view.backgroundColor = .clear
        
        createSubviews()
    }
    
    func createSubviews() {
        
        darkBackgroundView = UIButton(frame: view.frame)
        darkBackgroundView.backgroundColor = .offBlack
        darkBackgroundView.alpha = 0.0
        darkBackgroundView.addTarget(self, action: #selector(cancelButtonWasPressed), for: .touchUpInside)
        
        if let header = header {
            headerView = ActionSheetHeaderView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: headerViewHeight), image: header.image, title: header.title, description: header.description)
            let topSeparator = UIView()
            topSeparator.backgroundColor = separatorColor
            headerView!.addSubview(topSeparator)
            
            topSeparator.snp.makeConstraints { make in
                make.trailing.bottom.equalToSuperview()
                make.leading.equalToSuperview().inset(padding)
                make.height.equalTo(1 / UIScreen.main.scale)
            }
        } else {
            headerViewHeight = 0
        }

        optionTableView = UITableView()

        var optionSheetHeight: CGFloat = 0
        for opt in options {
            optionTableView.register(opt.type.cell, forCellReuseIdentifier: opt.type.cell.identifier)
            optionSheetHeight += opt.type.cell.cellHeight
        }

        optionTableView.frame = CGRect(x: 0, y: headerViewHeight, width: view.frame.width, height: optionSheetHeight)
        actionSheetContainerView = UIView(frame: CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: headerViewHeight + optionSheetHeight + cancelButtonHeight))
        actionSheetContainerView.backgroundColor = .offWhite

        optionTableView.delegate = self
        optionTableView.dataSource = self
        optionTableView.isScrollEnabled = false
        optionTableView.backgroundColor = .offWhite
        optionTableView.separatorColor = separatorColor
        
        cancelButton = UIButton(type: .system)
        cancelButton.frame = CGRect(x: 0, y: headerViewHeight + optionTableView.frame.height, width: view.frame.width, height: cancelButtonHeight)
        cancelButton.backgroundColor = .offWhite
        cancelButton.setTitle(cancelButtonTitle, for: .normal)
        cancelButton.setTitleColor(.slateGrey, for: .normal)
        cancelButton.titleLabel?.font = ._14RegularFont()
        cancelButton.addTarget(self, action: #selector(cancelButtonWasPressed), for: .touchUpInside)
        
        let bottomSeperator = UIView()
        bottomSeperator.backgroundColor = separatorColor
        cancelButton.addSubview(bottomSeperator)
        
        bottomSeperator.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(1 / UIScreen.main.scale)
        }
        if let headerView = headerView {
            actionSheetContainerView.addSubview(headerView)
        }
        actionSheetContainerView.addSubview(optionTableView)
        actionSheetContainerView.addSubview(cancelButton)
        view.addSubview(darkBackgroundView)
        view.addSubview(actionSheetContainerView)
    }
    
    func showActionSheet(animated: Bool) {
        
        UIView.animate(withDuration: animated ? 0.25 : 0.0) {
            guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
            self.currentStatusBarColor = statusBar.backgroundColor
            statusBar.backgroundColor = .clear
            statusBar.alpha = 0.8
            self.darkBackgroundView.alpha = 0.8
            self.actionSheetContainerView.frame = CGRect(x: 0, y: self.view.frame.height - self.actionSheetContainerView.frame.height - self.safeArea.bottom, width: self.actionSheetContainerView.frame.width, height: self.actionSheetContainerView.frame.height + self.safeArea.bottom)
        }
    }
    
    func hideActionSheet(animated: Bool, completion: (() -> ())?) {
        
        UIView.animate(withDuration: animated ? 0.25 : 0.0, animations: {
            guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView, let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            if appDelegate.playerViewController.isCollapsed {
                statusBar.backgroundColor = self.currentStatusBarColor // don't change status bar color if player is expanded
            }
            statusBar.alpha = 1
            self.darkBackgroundView.alpha = 0.0
            self.actionSheetContainerView.frame = CGRect(x: 0, y: self.view.frame.height, width: self.actionSheetContainerView.frame.width, height: self.actionSheetContainerView.frame.height)
        }, completion: { (completed: Bool) in
            completion?()
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let optionType = options[indexPath.row].type
        guard let cell = tableView.dequeueReusableCell(withIdentifier: optionType.cell.identifier) else { return UITableViewCell() }

        (cell as? ActionSheetPlayerControlsTableViewCell)?.delegate = self
        (cell as? ActionSheetCreateRecastBlurbTableViewCell)?.delegate = self
        (cell as? ActionSheetTableViewCellProtocol)?.setup(withOption: optionType)

        if indexPath.row == options.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let optionType = options[indexPath.row].type
        return optionType.cell.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let option = options[indexPath.row]
        if case .createBlurb = option.type {
            return
        }
        option.action?()
        
        tableView.deselectRow(at: indexPath, animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func cancelButtonWasPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        hideActionSheet(animated: true, completion: {
            
            self.willMove(toParentViewController: nil)
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
            
            completion?()
        })
    }

    // MARK - TableViewCell Delegate Methods
    func didPressSegmentedControl(cell: ActionSheetPlayerControlsTableViewCell, isSelected: Bool) {
        guard let indexPath = optionTableView.indexPath(for: cell) else { return }
        let option = options[indexPath.row]
        switch(option.type) {
        case .playerSettingsTrimSilence:
            playerControlsDelegate?.didPressSegmentedControlForTrimSilence(selected: isSelected)
        case .playerSettingsCustomizePlayerSettings:
            playerControlsDelegate?.didPressSegmentedControlForSavePreferences(selected: isSelected)
        default:
            break
        }
    }

    func didPressSaveBlurb(for cell: ActionSheetCreateRecastBlurbTableViewCell, with blurb: String) {
        guard let indexPath = optionTableView.indexPath(for: cell) else { return }
        let option = options[indexPath.row]
        switch(option.type) {
        case .createBlurb:
            option.type = .createBlurb(currentBlurb: blurb)
            option.action?()
            dismiss(animated: true)
        default: break
        }
    }
}
