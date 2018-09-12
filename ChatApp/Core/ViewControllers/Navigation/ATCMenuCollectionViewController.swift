//
//  ATCMenuCollectionViewController.swift
//  ShoppingApp
//
//  Created by Florian Marcu on 3/19/18.
//  Copyright © 2018 iOS App Templates. All rights reserved.
//

import UIKit

protocol ATCMenuCollectionViewCellConfigurable {
    func configure(item: ATCNavigationItem);
}

public struct ATCMenuUIConfiguration {
    var itemFont: UIFont = UIFont(name: "FallingSkyCond", size: 16)!
    var tintColor: UIColor = UIColor(hexString: "#555555")
    var itemHeight: CGFloat = 45.0
    var backgroundColor: UIColor = .white
}

public struct ATCMenuConfiguration {
    let user: ATCUser?
    let cellClass: UICollectionViewCell.Type?
    let headerHeight: CGFloat
    let items: [ATCNavigationItem]
    let uiConfig: ATCMenuUIConfiguration
}

class ATCMenuCollectionViewController: ATCGenericCollectionViewController {

    fileprivate var lastSelectedIndexPath: IndexPath?

    var user: ATCUser?

    let cellClass: UICollectionViewCell.Type?
    let headerHeight: CGFloat
    let menuConfiguration: ATCMenuConfiguration

    init(menuConfiguration: ATCMenuConfiguration, collectionVCConfiguration: ATCGenericCollectionViewControllerConfiguration) {
        self.user = menuConfiguration.user
        self.cellClass = menuConfiguration.cellClass
        self.headerHeight = menuConfiguration.headerHeight
        self.menuConfiguration = menuConfiguration

        super.init(configuration: collectionVCConfiguration)
        if let cellClass = cellClass {
            self.use(adapter: ATCMenuItemRowAdapter(cellClassType: cellClass, uiConfig: menuConfiguration.uiConfig), for: "ATCNavigationItem")
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = menuConfiguration.uiConfig.backgroundColor
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let collectionView = collectionView {
            collectionView.contentInset.top = max((collectionView.frame.height - collectionView.contentSize.height) / 3.0, 0)
        }
    }
}

extension ATCMenuCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let menuItem = self.genericDataSource?.object(at: indexPath.row) as? ATCNavigationItem else {
            return
        }
        let vc = menuItem.viewController
        self.drawerController()?.navigateTo(viewController: vc)
    }
}

extension ATCMenuCollectionViewController {
    fileprivate func drawerController() -> ATCDrawerController? {
        return (self.parent as? ATCDrawerController)
    }
}
