//
//  ATCChatThreadAdapter.swift
//  ChatApp
//
//  Created by Florian Marcu on 8/20/18.
//  Copyright © 2018 Instamobile. All rights reserved.
//

import Kingfisher
import UIKit

class ATCChatThreadAdapter: ATCGenericCollectionRowAdapter {
    let uiConfig: ATCUIGenericConfigurationProtocol
    let viewer: ATCUser

    init(uiConfig: ATCUIGenericConfigurationProtocol, viewer: ATCUser) {
        self.uiConfig = uiConfig
        self.viewer = viewer
    }

    func configure(cell: UICollectionViewCell, with object: ATCGenericBaseModel) {
        guard let viewModel = object as? ATChatMessage, let cell = cell as? ATCThreadCollectionViewCell else { return }
        let theOtherUser = (viewer.email == viewModel.atcSender.email) ? viewModel.recipient : viewModel.atcSender
        if let url = theOtherUser.profilePictureURL {
            cell.singleImageView.kf.setImage(with: URL(string: url))
        } else {
            // placeholder
        }
        cell.singleImageView.contentMode = .scaleAspectFill
        cell.singleImageView.clipsToBounds = true
        cell.singleImageView.layer.cornerRadius = 60.0/2.0

        let unseenByMe = (!viewModel.seenByRecipient && viewer.email == viewModel.recipient.email)
        cell.titleLabel.text = (theOtherUser.firstName ?? "") + " " +  (theOtherUser.lastName ?? "")
        cell.titleLabel.font = unseenByMe ? uiConfig.mediumBoldFont : uiConfig.regularMediumFont
        cell.titleLabel.textColor = uiConfig.mainTextColor

        var subtitle = (viewer.email == viewModel.atcSender.email) ? "You: " : ""
        subtitle += viewModel.messageText + " \u{00B7} " + TimeFormatHelper.chatString(for: viewModel.sentDate)
        cell.subtitleLabel.text = subtitle
        cell.subtitleLabel.font = uiConfig.regularSmallFont
        cell.subtitleLabel.textColor = uiConfig.mainSubtextColor

        cell.onlineStatusView.isHidden = !theOtherUser.isOnline
        cell.onlineStatusView.layer.cornerRadius = 15.0/2.0
        cell.onlineStatusView.layer.borderColor = UIColor.white.cgColor
        cell.onlineStatusView.layer.borderWidth = 3
        cell.onlineStatusView.backgroundColor = UIColor(hexString: "#4acd1d")

        cell.setNeedsLayout()
    }

    func cellClass() -> UICollectionViewCell.Type {
        return ATCThreadCollectionViewCell.self
    }

    func size(containerBounds: CGRect, object: ATCGenericBaseModel) -> CGSize {
        guard let viewModel = object as? ATChatMessage else { return .zero }
        return CGSize(width: containerBounds.width, height: 85)
    }
}
