//
//  ATCChatUserStoryAdapter.swift
//  ChatApp
//
//  Created by Florian Marcu on 8/21/18.
//  Copyright © 2018 Instamobile. All rights reserved.
//

import UIKit

class ATCChatUserStoryAdapter: ATCGenericCollectionRowAdapter {
    let uiConfig: ATCUIGenericConfigurationProtocol

    init(uiConfig: ATCUIGenericConfigurationProtocol) {
        self.uiConfig = uiConfig
    }

    func configure(cell: UICollectionViewCell, with object: ATCGenericBaseModel) {
        guard let viewModel = object as? ATCUser, let cell = cell as? ATCUserStoryCollectionViewCell else { return }
        if let url = viewModel.profilePictureURL {
            cell.storyImageView.kf.setImage(with: URL(string: url))
        } else {
            // placeholder
        }
        cell.storyImageView.contentMode = .scaleAspectFill
        cell.storyImageView.clipsToBounds = true
        cell.storyImageView.layer.cornerRadius = 50.0/2.0

        cell.storyTitleLabel.text = (viewModel.firstName ?? viewModel.lastName ?? "")
        cell.storyTitleLabel.font = uiConfig.regularFont(size: 13)
        cell.storyTitleLabel.textColor = uiConfig.mainSubtextColor

        cell.onlineStatusView.isHidden = !viewModel.isOnline
        cell.onlineStatusView.layer.cornerRadius = 15.0/2.0
        cell.onlineStatusView.layer.borderColor = UIColor.white.cgColor
        cell.onlineStatusView.layer.borderWidth = 3
        cell.onlineStatusView.backgroundColor = UIColor(hexString: "#4acd1d")

        cell.setNeedsLayout()
    }

    func cellClass() -> UICollectionViewCell.Type {
        return ATCUserStoryCollectionViewCell.self
    }

    func size(containerBounds: CGRect, object: ATCGenericBaseModel) -> CGSize {
        guard let viewModel = object as? ATCUser else { return .zero }
        return CGSize(width: 75, height: 90)
    }
}
