//
//  ATCViewControllerContainerModel.swift
//  ListingApp
//
//  Created by Florian Marcu on 6/12/18.
//  Copyright © 2018 Instamobile. All rights reserved.
//

import UIKit

class ATCViewControllerContainerViewModel: ATCGenericBaseModel {

    var description: String = "Carousel"

    let cellHeight: CGFloat?
    let subcellHeight: CGFloat?
    var viewController: UIViewController
    weak var parentViewController: UIViewController?

    init(viewController: UIViewController, cellHeight: CGFloat? = nil, subcellHeight: CGFloat? = nil) {
        self.cellHeight = cellHeight
        self.subcellHeight = subcellHeight
        self.viewController = viewController
        if let _ = cellHeight, let _ = subcellHeight {
            fatalError("Choose either static or dynamic size. You can have both.")
        }
    }

    required init(jsonDict: [String: Any]) {
        fatalError()
    }
}
