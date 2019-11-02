//
//  ATCChatThreadsViewController.swift
//  ChatApp
//
//  Created by Florian Marcu on 8/20/18.
//  Copyright © 2018 Instamobile. All rights reserved.
//

import UIKit

class ATCChatThreadsViewController: ATCGenericCollectionViewController {
  
  init(configuration: ATCGenericCollectionViewControllerConfiguration,
       selectionBlock: ATCollectionViewSelectionBlock?,
       viewer: ATCUser) {
    super.init(configuration: configuration, selectionBlock: selectionBlock)
    self.use(adapter: ATCChatThreadAdapter(uiConfig: configuration.uiConfig, viewer: viewer), for: "ATChatMessage")
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  static func mockThreadsVC(uiConfig: ATCUIGenericConfigurationProtocol,
                            dataSource: ATCGenericCollectionViewControllerDataSource,
                            viewer: ATCUser) -> ATCChatThreadsViewController {
    let collectionVCConfiguration = ATCGenericCollectionViewControllerConfiguration(
      pullToRefreshEnabled: false,
      pullToRefreshTintColor: .white,
      collectionViewBackgroundColor: .white,
      collectionViewLayout: ATCLiquidCollectionViewLayout(),
      collectionPagingEnabled: false,
      hideScrollIndicators: false,
      hidesNavigationBar: false,
      headerNibName: nil,
      scrollEnabled: false,
      uiConfig: uiConfig
    )
    
    let vc = ATCChatThreadsViewController(configuration: collectionVCConfiguration, selectionBlock: ATCChatThreadsViewController.selectionBlock(viewer: viewer), viewer: ATCChatMockStore.users[0])
    vc.genericDataSource = dataSource
    return vc
  }
  
  static func selectionBlock(viewer: ATCUser) -> ATCollectionViewSelectionBlock? {
    return { (navController, object) in
      let uiConfig = ATCChatUIConfiguration(primaryColor: UIColor(hexString: "#0084ff"),
                                            secondaryColor: UIColor(hexString: "#f0f0f0"),
                                            inputTextViewBgColor: UIColor(hexString: "#f4f4f6"),
                                            inputTextViewTextColor: .black,
                                            inputPlaceholderTextColor: UIColor(hexString: "#979797"))
      if let lastMessage = object as? ATChatMessage {
        let otherUser = viewer.uid == lastMessage.atcSender.uid ? lastMessage.recipient : lastMessage.atcSender
        let vc = ATCChatThreadViewController(user: viewer, channel: ATCChatChannel(id: lastMessage.channelId, name: otherUser.fullName()), uiConfig: uiConfig)
        navController?.pushViewController(vc, animated: true)
      }
    }
  }
}
