//
//  ATCNavigationViewController.swift
//  AppTemplatesFoundation
//
//  Created by Florian Marcu on 2/8/17.
//  Copyright © 2017 iOS App Templates. All rights reserved.
//

import UIKit

public enum ATCNavigationStyle {
    case tabBar
    case sideBar
}

public enum ATCNavigationMenuItemType {
    case viewController
    case logout
}

public final class ATCNavigationItem: ATCGenericBaseModel {
    let viewController: UIViewController
    let title: String
    let image: UIImage?
    let type: ATCNavigationMenuItemType
    let leftTopView: UIView?
    let rightTopView: UIView?

    init(title: String,
         viewController: UIViewController,
         image: UIImage?,
         type: ATCNavigationMenuItemType,
         leftTopView: UIView? = nil,
         rightTopView: UIView? = nil) {
        self.title = title
        self.viewController = viewController
        self.image = image
        self.type = type
        self.leftTopView = leftTopView
        self.rightTopView = rightTopView
    }

    convenience init(jsonDict: [String: Any]) {
        self.init(title: "", viewController: UIViewController(), image: nil, type: .viewController)
    }

    public var description: String {
        return title
    }
}

public struct ATCHostConfiguration {
    let menuConfiguration: ATCMenuConfiguration
    let style: ATCNavigationStyle
    let topNavigationRightView: UIView?
    let topNavigationLeftImage: UIImage?
    let topNavigationTintColor: UIColor?
    let statusBarStyle: UIStatusBarStyle
    let uiConfig: ATCUIGenericConfigurationProtocol
}

public class ATCHostViewController: UIViewController {
    var user: ATCUser? {
        didSet {
            menuViewController?.user = user
            menuViewController?.collectionView?.reloadData()
        }
    }

    var items: [ATCNavigationItem] {
        didSet {
            menuViewController?.genericDataSource = ATCGenericLocalDataSource(items: items)
            menuViewController?.collectionView?.reloadData()
        }
    }
    let style: ATCNavigationStyle
    let statusBarStyle: UIStatusBarStyle

    var tabController: UITabBarController?
    var navigationRootController: ATCNavigationController?
    var menuViewController: ATCMenuCollectionViewController?
    var drawerController: ATCDrawerController?

    init(configuration: ATCHostConfiguration) {
        self.style = configuration.style
        let menuConfiguration = configuration.menuConfiguration
        self.items = menuConfiguration.items
        self.user = menuConfiguration.user
        self.statusBarStyle = configuration.statusBarStyle

        super.init(nibName: nil, bundle: nil)
        configureChildrenViewControllers(configuration: configuration)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        presentLoggedInViewControllers()
    }

    fileprivate func presentLoggedInViewControllers() {
        let childVC: UIViewController = (style == .tabBar) ? tabController! : drawerController!
        if let view = (style == .tabBar) ? tabController!.view : drawerController!.view {
            UIView.transition(with: self.view, duration: 0.5, options: .transitionFlipFromLeft, animations: {
                self.addChildViewControllerWithView(childVC)
            }, completion: nil)
        }
    }

    fileprivate func configureChildrenViewControllers(configuration: ATCHostConfiguration) {
        if (style == .tabBar) {
            let navigationControllers = items.filter{$0.type == .viewController}.map {
                ATCNavigationController(rootViewController: $0.viewController,
                                        topNavigationLeftView: $0.leftTopView,
                                        topNavigationRightView: $0.rightTopView,
                                        topNavigationLeftImage: nil)
            }
            tabController = UITabBarController()
            tabController?.setViewControllers(navigationControllers, animated: true)
            for (tag, item) in items.enumerated() {
                item.viewController.tabBarItem = UITabBarItem(title: item.title, image: item.image, tag: tag)
            }
        } else {
            guard let firstVC = items.first?.viewController else { return }
            navigationRootController = ATCNavigationController(rootViewController: firstVC, topNavigationRightView: configuration.topNavigationRightView, topNavigationLeftImage: configuration.topNavigationLeftImage, topNavigationTintColor: configuration.topNavigationTintColor)
            let collectionVCConfiguration = ATCGenericCollectionViewControllerConfiguration(
                pullToRefreshEnabled: false,
                pullToRefreshTintColor: .white,
                collectionViewBackgroundColor: .black,
                collectionViewLayout: ATCLiquidCollectionViewLayout(),
                collectionPagingEnabled: false,
                hideScrollIndicators: false,
                hidesNavigationBar: false,
                headerNibName: nil,
                scrollEnabled: true,
                uiConfig: configuration.uiConfig
            )
            let menuConfiguration = configuration.menuConfiguration
            menuViewController = ATCMenuCollectionViewController(menuConfiguration: menuConfiguration, collectionVCConfiguration: collectionVCConfiguration)
            menuViewController?.genericDataSource = ATCGenericLocalDataSource<ATCNavigationItem>(items: menuConfiguration.items)
            drawerController = ATCDrawerController(rootViewController: navigationRootController!, menuController: menuViewController!)
            navigationRootController?.drawerDelegate = drawerController
            if let drawerController = drawerController {
                self.addChild(drawerController)
                navigationRootController?.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: nil)
                navigationRootController?.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: nil)
            }
        }
    }
}
