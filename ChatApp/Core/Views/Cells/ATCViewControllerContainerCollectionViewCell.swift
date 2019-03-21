//
//  ATCViewControllerContainerCollectionViewCell.swift
//  ListingApp
//
//  Created by Florian Marcu on 6/12/18.
//  Copyright © 2018 Instamobile. All rights reserved.
//

import UIKit

class ATCViewControllerContainerCollectionViewCell: UICollectionViewCell {

    @IBOutlet var containerView: UIView!

    func configure(viewModel: ATCViewControllerContainerViewModel) {
        containerView.setNeedsLayout()
        containerView.layoutIfNeeded()

        let viewController = viewModel.viewController

        viewController.view.frame = containerView.bounds
        containerView.addSubview(viewController.view)
        self.setNeedsLayout()
        viewModel.parentViewController?.addChild(viewModel.viewController)
    }
}
