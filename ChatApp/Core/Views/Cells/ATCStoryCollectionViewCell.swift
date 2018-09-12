//
//  ATCStoryCollectionViewCell.swift
//  RestaurantApp
//
//  Created by Florian Marcu on 5/15/18.
//  Copyright © 2018 iOS App Templates. All rights reserved.
//

import UIKit

class ATCStoryViewModel: NSObject, ATCGenericBaseModel {
    var imageURLString: String
    var title: String
    var atcDescription: String

    init(imageURLString: String, title: String, description: String) {
        self.imageURLString = imageURLString
        self.title = title
        self.atcDescription = description
    }

    required init(jsonDict: [String: Any]) {
        fatalError()
    }
}

class ATCStoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet var storyImageView: UIImageView!
    @IBOutlet var storyLabel: UILabel!

    func configure(viewModel: ATCStoryViewModel, uiConfig: ATCUIGenericConfigurationProtocol) {
        storyImageView.contentMode = .scaleAspectFill
        storyImageView.layer.masksToBounds = true
        storyImageView.clipsToBounds = true
        storyImageView.layer.cornerRadius = 35
        storyLabel.font = uiConfig.regularSmallFont

        storyImageView.kf.setImage(with: URL(string: viewModel.imageURLString))
        storyLabel.text = viewModel.title
    }
}
