
import UIKit

class TabBarItem {
    var rootViewController: UINavigationController
    var index: Int
    var selectedImage: UIImage
    var unselectedImage: UIImage
    
    init(index: Int, rootViewController: UINavigationController, selectedImage: UIImage, unselectedImage: UIImage) {
        self.index = index
        self.rootViewController = rootViewController
        self.selectedImage = selectedImage
        self.unselectedImage = unselectedImage
    }
}

class TabBarController: UIViewController {
    
    var tabBarHeight: CGFloat = 50.0
    var tabBarContainerView = UIView()
    var tabBarButtons = [UIButton]()
    var transparentTabBarEnabled: Bool = false
    var tabBarButtonFireEvent: UIControlEvents = .touchDown
    
    var safeArea: UIEdgeInsets!
    
    var tabBarItems: [Int: TabBarItem] = [:]
    
    var currentlyPresentedViewController: UIViewController?
    var accessoryViewController: TabBarAccessoryViewController?
    
    var tabBarIsHidden: Bool = false
    
    // Tab to present on viewDidLoad
    var preselectedTabIndex = 0
    
    var tabBarColor: UIColor = .offWhite {
        didSet {
            tabBarContainerView.backgroundColor = tabBarColor
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .offWhite
        safeArea = UIApplication.shared.delegate?.window??.safeAreaInsets
        
        createTabBarContainerView()
        setupTabs()
        
        programmaticallyPressTabBarButton(atIndex: preselectedTabIndex)
    }
    
    func createTabBarContainerView() {
        
        tabBarContainerView = UIView(frame: CGRect(x: 0, y: view.frame.height - tabBarHeight - safeArea.bottom, width: view.frame.width, height: tabBarHeight + safeArea.bottom))
        tabBarContainerView.backgroundColor = tabBarColor

        if !UIAccessibilityIsReduceTransparencyEnabled() && transparentTabBarEnabled {
            
            tabBarContainerView.backgroundColor = UIColor.clear
            
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)

            blurEffectView.frame = tabBarContainerView.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            tabBarContainerView.addSubview(blurEffectView)
            
        }
        
        let lineSeparator = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 1))
        lineSeparator.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        tabBarContainerView.addSubview(lineSeparator)
        
        view.addSubview(tabBarContainerView)
    }
    
    func addTab(index: Int, rootViewController: UINavigationController, selectedImage: UIImage, unselectedImage: UIImage) {
        tabBarItems[index] = TabBarItem(index: index, rootViewController: rootViewController, selectedImage: selectedImage, unselectedImage: unselectedImage)
    }
    
    func setupTabs() {
        
        let tabBarButtonWidth = view.frame.width / CGFloat(tabBarItems.count)
        var xOffset: CGFloat = 0.0
        for i in 0 ..< tabBarItems.count {
            
            let newTabBarButton = UIButton(frame: CGRect(x: xOffset,
                                                         y: 0,
                                                         width: tabBarButtonWidth,
                                                         height: tabBarHeight))
            
            newTabBarButton.backgroundColor = .clear
            
            newTabBarButton.addTarget(self, action: #selector(didPressTabBarButton(tabBarButton:)), for: tabBarButtonFireEvent)
            
            newTabBarButton.setImage(tabBarItems[i]?.selectedImage, for: .selected)
            newTabBarButton.setImage(tabBarItems[i]?.unselectedImage, for: .normal)
            
            tabBarContainerView.addSubview(newTabBarButton)
            
            tabBarButtons.append(newTabBarButton)
            
            xOffset += tabBarButtonWidth
        }
        
    }
    
    @objc func didPressTabBarButton(tabBarButton: UIButton) {
        
        guard let tabBarButtonIndex = tabBarButtons.index(of: tabBarButton) else { return }
        programmaticallyPressTabBarButton(atIndex: tabBarButtonIndex)
    }
    
    func programmaticallyPressTabBarButton(atIndex index: Int) {
        if tabBarButtons[index].isSelected { //pop to root view controller
            tabBarItems[index]?.rootViewController.popToRootViewController(animated: true)
        }
        for button in tabBarButtons {
            button.isSelected = false
        }
        tabBarButtons[index].isSelected = true
        present(tabBarItems[index]!.rootViewController, animated: false, completion: nil)
    }
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        
        currentlyPresentedViewController?.willMove(toParentViewController: nil)
        currentlyPresentedViewController?.view.removeFromSuperview()
        currentlyPresentedViewController?.removeFromParentViewController()
        currentlyPresentedViewController = nil
        
        viewControllerToPresent.view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        
        if let localAccessoryViewController = accessoryViewController {
            view.insertSubview(viewControllerToPresent.view, belowSubview: localAccessoryViewController.view)
        } else {
            view.insertSubview(viewControllerToPresent.view, belowSubview: tabBarContainerView)
        }
        
        addChildViewController(viewControllerToPresent)
        viewControllerToPresent.didMove(toParentViewController: self)
        currentlyPresentedViewController = viewControllerToPresent
        
        completion?()
    }
    
    func addAccessoryViewController(accessoryViewController: TabBarAccessoryViewController) {
        
        self.accessoryViewController?.willMove(toParentViewController: nil)
        self.accessoryViewController?.view.removeFromSuperview()
        self.accessoryViewController?.removeFromParentViewController()
        self.accessoryViewController = nil
        
        accessoryViewController.view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        view.insertSubview(accessoryViewController.view, belowSubview: tabBarContainerView)
        addChildViewController(accessoryViewController)
        accessoryViewController.didMove(toParentViewController: self)
        self.accessoryViewController = accessoryViewController
        
        // update table view insets for accessory view
        if let viewController = currentlyPresentedViewController?.topViewController() as? ViewController {
            viewController.updateTableViewInsetsForAccessoryView()
        }
    }
    
    func showTabBar(animated: Bool) {
        
        if !tabBarIsHidden { return }
        
        if animated {
            UIView.animate(withDuration: 0.2, animations: {
                self.tabBarContainerView.frame = CGRect(x: 0, y: self.view.frame.height - self.tabBarContainerView.frame.height, width: self.tabBarContainerView.frame.width, height: self.tabBarContainerView.frame.height)
            })
        } else {
            tabBarContainerView.frame = CGRect(x: 0, y: view.frame.height - tabBarContainerView.frame.height, width: tabBarContainerView.frame.width, height: tabBarContainerView.frame.height)
        }
        
        tabBarIsHidden = false
    }
    
    func hideTabBar(animated: Bool) {
        
        if tabBarIsHidden { return }
        
        if animated {
            UIView.animate(withDuration: 0.2, animations: {
                self.tabBarContainerView.frame = CGRect(x: 0, y: self.view.frame.height, width: self.tabBarContainerView.frame.width, height: self.tabBarContainerView.frame.height)
            })
        } else {
            tabBarContainerView.frame = CGRect(x: 0, y: view.frame.height, width: tabBarContainerView.frame.width, height: tabBarContainerView.frame.height)
        }
        
        tabBarIsHidden = true
    }
}
