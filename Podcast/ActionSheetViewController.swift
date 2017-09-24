
import UIKit

class ActionSheetTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)

        textLabel?.font = UIFont.systemFont(ofSize: 14)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    var imageViewX: CGFloat = 17.5
    var imageViewY: CGFloat = 17
    var imageViewSize: CGFloat = 60
    
    init(frame: CGRect, image: UIImage, title: String, description: String) {
        super.init(frame: frame)
        
        backgroundColor = .podcastWhite
        
        imageView = ImageView(frame: CGRect(x: imageViewX, y: imageViewY, width: imageViewSize, height: imageViewSize))
        titleLabel = UILabel(frame: CGRect(x: episodeNameLabelX, y: episodeNameLabelY, width: frame.width - episodeNameLabelRightX - episodeNameLabelX, height: episodeNameLabelHeight))
        descriptionLabel = UILabel(frame: CGRect(x: descriptionLabelX, y: descriptionLabelY, width: frame.width, height: descriptionLabelHeight))

        titleLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
        titleLabel.textColor = .podcastBlack

        descriptionLabel.font = UIFont.systemFont(ofSize: 12.0)
        descriptionLabel.textColor = .podcastGrayDark

        imageView.image = image
        titleLabel.text = title
        descriptionLabel.text = description
        
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ActionSheetOption {
    
    var title: String
    var titleColor: UIColor
    var image: UIImage
    var action: (() -> ())?
    
    init(title: String, titleColor: UIColor, image: UIImage, action: (() -> ())?) {
        self.title = title
        self.titleColor = titleColor
        self.image = image
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

class ActionSheetViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var actionSheetContainerView: UIView!
    var optionTableView: UITableView!
    var headerView: ActionSheetHeaderView?
    var cancelButton: UIButton!
    var darkBackgroundView: UIButton!
    
    var headerViewHeight: CGFloat = 94
    let optionCellHeight: CGFloat = 58
    let cancelButtonHeight: CGFloat = 58
    
    let optionCellReuseIdentifier = "Option Cell Reuse Identifier"
    
    var options: [ActionSheetOption]
    var header: ActionSheetHeader?
    
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

        view.backgroundColor = .clear
        createSubviews()
    }
    
    func createSubviews() {
        
        darkBackgroundView = UIButton(frame: view.frame)
        darkBackgroundView.backgroundColor = .black
        darkBackgroundView.alpha = 0.0
        darkBackgroundView.addTarget(self, action: #selector(cancelButtonWasPressed), for: .touchUpInside)
        
        if let header = header {
            headerView = ActionSheetHeaderView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: headerViewHeight), image: header.image, title: header.title, description: header.description)
        } else {
            headerViewHeight = 0
        }
        
        actionSheetContainerView = UIView(frame: CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: headerViewHeight + optionCellHeight * CGFloat(options.count) + cancelButtonHeight))
        actionSheetContainerView.backgroundColor = .podcastWhite
        
        optionTableView = UITableView(frame: CGRect(x: 0, y: headerViewHeight, width: view.frame.width, height: optionCellHeight * CGFloat(options.count)))
        optionTableView.register(ActionSheetTableViewCell.self, forCellReuseIdentifier: optionCellReuseIdentifier)
        optionTableView.delegate = self
        optionTableView.dataSource = self
        optionTableView.isScrollEnabled = false
        optionTableView.backgroundColor = .podcastWhite
        
        let topSeparator = UIView(frame: CGRect(x: 15, y: headerViewHeight, width: view.frame.size.width, height: 1 / UIScreen.main.scale))
        topSeparator.backgroundColor = optionTableView.separatorColor
        
        cancelButton = UIButton(type: .system)
        cancelButton.frame = CGRect(x: 0, y: headerViewHeight + optionTableView.frame.height, width: view.frame.width, height: cancelButtonHeight)
        cancelButton.backgroundColor = .podcastWhite
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.podcastGrayLight, for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        cancelButton.addTarget(self, action: #selector(cancelButtonWasPressed), for: .touchUpInside)
        
        if let headerView = headerView {
            actionSheetContainerView.addSubview(headerView)
        }
        actionSheetContainerView.addSubview(optionTableView)
        actionSheetContainerView.addSubview(topSeparator)
        actionSheetContainerView.addSubview(cancelButton)
        view.addSubview(darkBackgroundView)
        view.addSubview(actionSheetContainerView)
    }
    
    func showActionSheet(animated: Bool) {
        
        UIView.animate(withDuration: animated ? 0.25 : 0.0) {
            
            self.darkBackgroundView.alpha = 0.8
            self.actionSheetContainerView.frame = CGRect(x: 0, y: self.view.frame.height - self.actionSheetContainerView.frame.height, width: self.actionSheetContainerView.frame.width, height: self.actionSheetContainerView.frame.height)
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
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: optionCellReuseIdentifier) as? ActionSheetTableViewCell else { return UITableViewCell() }
        
        let option = options[indexPath.row]
        
        cell.textLabel?.text = option.title
        cell.textLabel?.textColor = option.titleColor
        cell.imageView?.image = option.image
        
        if indexPath.row == options.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return optionCellHeight
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
}
