//
//  ATCMenuHeaderTableViewCell.swift
//  AppTemplatesFoundation
//
//  Created by Florian Marcu on 2/11/17.
//  Copyright © 2017 iOS App Templates. All rights reserved.
//

import Kingfisher
import UIKit

open class ATCMenuHeaderTableViewCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var avatarView: UIImageView!
    open func configureCell(user: ATCUser?) {
        if let urlString = user?.profilePictureURL {
            let imageURL = URL(string: urlString)
            avatarView.kf.setImage(with: imageURL)
        }
        avatarView.layer.cornerRadius = 35
        avatarView.clipsToBounds = true

        nameLabel.text = user?.fullName()
    }
}
