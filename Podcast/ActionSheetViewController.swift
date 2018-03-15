
import UIKit

protocol ActionSheetTableViewCellProtocol: class {
    static var identifier: String { get }
    static var cellHeight: CGFloat { get }
    func setup(withOption option: ActionSheetOptionType)
}

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



class ActionSheetHeaderView: UIView {
    
    var imageView: ImageView!
    var titleLabel: UILabel!
    var descriptionLabel: UILabel!
    
    let episodeNameLabelY: CGFloat = 27
    let episodeNameLabelX: CGFloat = 86.5
    let episodeNameLabelRightX: CGFloat = 21
    let episodeNameLabelHeight: CGFloat = 18
    let descriptionLabelX: CGFloat = 86.5
    let descriptionLabelY: CGFloat = 47.5
    var descriptionLabelHeight: CGFloat = 14.5
    var padding: CGFloat = 18
    let smallPadding: CGFloat = 2
    var imageViewSize: CGFloat = 60
    
    init(frame: CGRect, image: UIImage, title: String, description: String) {
        super.init(frame: frame)
        
        backgroundColor = .offWhite
        
        imageView = ImageView()
        titleLabel = UILabel()
        descriptionLabel = UILabel()

        titleLabel.font = ._14SemiboldFont()
        titleLabel.textColor = .offBlack
        titleLabel.numberOfLines = 2

        descriptionLabel.font = ._12RegularFont()
        descriptionLabel.textColor = .charcoalGrey
        descriptionLabel.numberOfLines = 2

        imageView.image = image
        titleLabel.text = title
        descriptionLabel.text = description
        
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(padding)
            make.leading.equalToSuperview().inset(padding)
            make.size.equalTo(imageViewSize)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(padding)
            make.trailing.equalToSuperview().inset(padding)
            make.top.equalTo(imageView.snp.top)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(smallPadding)
            make.leading.equalTo(titleLabel.snp.leading)
            make.trailing.equalTo(titleLabel.snp.trailing)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

enum ActionSheetOptionType {
    case download(selected: Bool)
    case bookmark(selected: Bool)
    case recommend(selected: Bool)
    case listeningHistory
    case shareEpisode
    case confirmShare
    case deleteShare
    case recastDescription
    case playerSettingsTrimSilence(selected: Bool)
    
    var title: String {
        switch (self) {
        case .download(let selected):
            return selected ? "Remove download" : "Download this episode"
        case .bookmark(let selected):
            return selected ? "Remove save" : "Save for later"
        case .recommend(let selected):
            return selected ? "Undo recast" : "Recast this episode"
        case .listeningHistory:
            return "Remove from Listening History"
        case .shareEpisode:
            return "Share this episode"
        case .confirmShare:
            return "Click to confirm share"
        case .deleteShare:
            return "Delete shared episode"
        case .recastDescription:
            return "When you recast a podcast episode, that episode is shared with your followers on their feed."
        case .playerSettingsTrimSilence:
            return "Trim silent parts of episode"
        }
    }
    
    var iconImage: UIImage? {
        switch(self) {
        case .download(let selected):
            return selected ? #imageLiteral(resourceName: "download_remove") : #imageLiteral(resourceName: "download")
        case .bookmark(let selected):
            return selected ? #imageLiteral(resourceName: "bookmark_feed_icon_selected") : #imageLiteral(resourceName: "bookmark_feed_icon_unselected")
        case .recommend(let selected):
            return selected ? #imageLiteral(resourceName: "repost_selected") : #imageLiteral(resourceName: "repost")
        case .listeningHistory, .deleteShare:
            return #imageLiteral(resourceName: "failure_icon")
        case .shareEpisode, .confirmShare:
            return #imageLiteral(resourceName: "iShare")
        case .recastDescription:
            return #imageLiteral(resourceName: "repost_selected")
        default:
            return nil
        }
    }

    var titleColor: UIColor {
        return .charcoalGrey
    }

    var cell: ActionSheetTableViewCellProtocol.Type {
        switch(self) {
        case .recastDescription:
            return ActionSheetRecastDescriptionTableViewCell.self
        case .playerSettingsTrimSilence:
            return ActionSheetPlayerControlsTableViewCell.self
        default:
            return ActionSheetMoreOptionsStandardTableViewCell.self
        }
    }
}

class ActionSheetOption {
    
    var type: ActionSheetOptionType
    var action: (() -> ())?
    
    init(type: ActionSheetOptionType, action: (() -> ())?) {
        self.type = type
        self.action = action
    }
    
}

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

protocol ActionSheetViewControllerDelegate: class {
    func didPressSegmentedControlForTrimSilence(selected: Bool)
}

class ActionSheetViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ActionSheetPlayerControlsTableViewCellDelegate {
    
    var actionSheetContainerView: UIView!
    var optionTableView: UITableView!
    var headerView: ActionSheetHeaderView?
    var cancelButton: UIButton!
    var cancelButtonTitle: String = "Cancel"
    var darkBackgroundView: UIButton!
    var separatorColor: UIColor = .lightGrey
    
    var safeArea: UIEdgeInsets!
    
    var headerViewHeight: CGFloat = 94
    let cancelButtonHeight: CGFloat = 58
    var padding: CGFloat = 18
    
    var options: [ActionSheetOption]
    var header: ActionSheetHeader?
    weak var delegate: ActionSheetViewControllerDelegate?
    
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
            
            self.darkBackgroundView.alpha = 0.8
            self.actionSheetContainerView.frame = CGRect(x: 0, y: self.view.frame.height - self.actionSheetContainerView.frame.height - self.safeArea.bottom, width: self.actionSheetContainerView.frame.width, height: self.actionSheetContainerView.frame.height + self.safeArea.bottom)
        }
        
    }
    
    func hideActionSheet(animated: Bool, completion: (() -> ())?) {
        
        UIView.animate(withDuration: animated ? 0.25 : 0.0, animations: {
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
    func didPressSegmentedControlForTrimSilence(selected: Bool) {
        delegate?.didPressSegmentedControlForTrimSilence(selected: selected)
    }

}
