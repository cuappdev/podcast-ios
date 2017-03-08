
import UIKit

class TabBarController: UIViewController {
    
    var numberOfTabs: Int = 0
    var tabBarHeight: CGFloat = 50.0
    var tabBarContainerView = UIView()
    var tabBarButtons = [UIButton]()
    var transparentTabBarEnabled: Bool = false
    var tabBarButtonFireEvent: UIControlEvents = .touchDown
    
    var selectedBarButtonImages = [Int:UIImage]()
    var unSelectedBarButtonImages = [Int:UIImage]()
    
    var currentlyPresentedViewController: UIViewController?
    var accessoryViewController: TabBarAccessoryViewController?
    
    var tabBarIsHidden: Bool = false
    
    // Tab to present on viewDidLoad
    var preselectedTabIndex = 0
    
    var tabBarColor: UIColor = .white {
        didSet {
            tabBarContainerView.backgroundColor = tabBarColor
        }
    }

    var blocksToExecuteOnTabBarButtonPress = [Int:() -> ()]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        createTabBarContainerView()
        setupTabs()
        
        programmaticallyPressTabBarButton(atIndex: preselectedTabIndex)
    }
    
    func createTabBarContainerView() {
        
        tabBarContainerView = UIView(frame: CGRect(x: 0, y: view.frame.height - tabBarHeight, width: view.frame.width, height: tabBarHeight))
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
    
    func setupTabs() {
        
        let tabBarButtonWidth = view.frame.width / CGFloat(numberOfTabs)
        var xOffset: CGFloat = 0.0
        for i in 0 ..< numberOfTabs {
            
            let newTabBarButton = UIButton(frame: CGRect(x: xOffset,
                                                         y: 0,
                                                         width: tabBarButtonWidth,
                                                         height: tabBarHeight))
            
            newTabBarButton.backgroundColor = .clear
            
            newTabBarButton.addTarget(self, action: #selector(didPressTabBarButton(tabBarButton:)), for: tabBarButtonFireEvent)
            
            newTabBarButton.setImage(selectedBarButtonImages[i], for: .selected)
            newTabBarButton.setImage(unSelectedBarButtonImages[i], for: .normal)
            
            tabBarContainerView.addSubview(newTabBarButton)
            
            tabBarButtons.append(newTabBarButton)
            
            xOffset += tabBarButtonWidth
        }
        
    }
    
    func didPressTabBarButton(tabBarButton: UIButton) {
        
        guard let tabBarButtonIndex = tabBarButtons.index(of: tabBarButton) else { return }
        
        for button in tabBarButtons {
            button.isSelected = false
        }
        
        tabBarButton.isSelected = true
        
        if let blockToExecute = blocksToExecuteOnTabBarButtonPress[tabBarButtonIndex] {
            blockToExecute()
        }
    }
    
    func programmaticallyPressTabBarButton(atIndex index: Int) {
        
        for button in tabBarButtons {
            button.isSelected = false
        }
        
        tabBarButtons[index].isSelected = true
        
        if let blockToExecute = blocksToExecuteOnTabBarButtonPress[index] {
            blockToExecute()
        }
    }
    
    func setSelectedImage(image: UIImage, forTabAtIndex index: Int) {
        selectedBarButtonImages[index] = image
    }
    
    func setUnselectedImage(image: UIImage, forTabAtIndex index: Int) {
        unSelectedBarButtonImages[index] = image
    }
    
    func addBlockToExecuteOnTabBarButtonPress(block: @escaping () -> (), forTabAtIndex index: Int) {
        blocksToExecuteOnTabBarButtonPress[index] = block
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
