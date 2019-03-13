//
//  ATCDrawerController.swift
//  AppTemplatesFoundation
//
//  Created by Florian Marcu on 2/10/17.
//  Copyright © 2017 iOS App Templates. All rights reserved.
//

import UIKit

class ATCDrawerController: UIViewController, ATCNavigationControllerDelegate {
    var rootViewController: ATCNavigationController
    var menuController: ATCMenuCollectionViewController
    var isMenuExpanded: Bool = false
    let overlayView = UIView()

    init(rootViewController: ATCNavigationController, menuController: ATCMenuCollectionViewController) {
        self.rootViewController = rootViewController
        self.menuController = menuController
        super.init(nibName: nil, bundle: nil)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.addChild(rootViewController)
        self.view.addSubview(rootViewController.view)
        rootViewController.didMove(toParent: self)

        overlayView.backgroundColor = .black
        overlayView.alpha = 0
        view.addSubview(overlayView)

        self.menuController.view.frame = CGRect(x: 0, y: 0, width: 0, height: self.view.bounds.height)
        self.addChild(menuController)
        self.view.addSubview(menuController.view)
        menuController.didMove(toParent: self)

        configureGestures()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        overlayView.frame = view.bounds
        let width: CGFloat = (isMenuExpanded) ? view.bounds.width * 3 / 4 : 0.0
        self.menuController.view.frame = CGRect(x: 0, y: 0, width: width , height: self.view.bounds.height)
    }

    func toggleMenu() {
        isMenuExpanded = !isMenuExpanded
        let bounds = self.view.bounds
        let width: CGFloat = (isMenuExpanded) ? bounds.width * 3 / 4 : 0.0

        UIView.animate(withDuration: 0.3, animations: {
            self.menuController.view.frame = CGRect(x: 0, y: 0, width: width, height: bounds.height)
            self.overlayView.alpha = (self.isMenuExpanded) ? 0.5 : 0.0
        }) { (success) in
        }
    }

    func navigateTo(viewController: UIViewController) {
        rootViewController.setViewControllers([viewController], animated: false)
        self.toggleMenu()
    }

    fileprivate func configureGestures() {
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeLeft))
        swipeLeftGesture.direction = .left
        overlayView.addGestureRecognizer(swipeLeftGesture)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOverlay))
        overlayView.addGestureRecognizer(tapGesture)
    }

    @objc fileprivate func didSwipeLeft() {
        toggleMenu()
    }

    @objc fileprivate func didTapOverlay() {
        toggleMenu()
    }
}

extension ATCDrawerController {
    func navigationControllerDidTapMenuButton(_ navigationController: ATCNavigationController) {
        toggleMenu()
    }
}
