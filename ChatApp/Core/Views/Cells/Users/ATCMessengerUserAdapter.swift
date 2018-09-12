//
//  ATCMessengerUserAdapter.swift
//  ChatApp
//
//  Created by Florian Marcu on 8/22/18.
//  Copyright © 2018 Instamobile. All rights reserved.
//

import UIKit

class ATCMessengerUserAdapter: ATCGenericCollectionRowAdapter {
    let uiConfig: ATCUIGenericConfigurationProtocol

    init(uiConfig: ATCUIGenericConfigurationProtocol) {
        self.uiConfig = uiConfig
    }

    func configure(cell: UICollectionViewCell, with object: ATCGenericBaseModel) {
        if let user = object as? ATCUser, let cell = cell as? ATCMessengerUserCollectionViewCell {
            if let url = user.profilePictureURL {
                cell.avatarImageView.kf.setImage(with: URL(string: url))
            } else {
                // placeholder
            }
            cell.avatarImageView.contentMode = .scaleAspectFill
            cell.avatarImageView.clipsToBounds = true
            cell.avatarImageView.layer.cornerRadius = 40.0/2.0

            cell.nameLabel.text = (user.firstName ?? "") + " " +  (user.lastName ?? "")
            cell.nameLabel.font = uiConfig.mediumBoldFont
            cell.nameLabel.textColor = uiConfig.mainTextColor

            cell.borderView.backgroundColor = UIColor(hexString: "#e6e6e6")
            cell.setNeedsLayout()
        }
    }

    func cellClass() -> UICollectionViewCell.Type {
        return ATCMessengerUserCollectionViewCell.self
    }

    func size(containerBounds: CGRect, object: ATCGenericBaseModel) -> CGSize {
        guard let viewModel = object as? ATCUser else { return .zero }
        return CGSize(width: containerBounds.width, height: 80)
    }
}
