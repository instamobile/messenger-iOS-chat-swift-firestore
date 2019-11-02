//
//  ATCChatHomeViewController.swift
//  ChatApp
//
//  Created by Florian Marcu on 8/21/18.
//  Copyright © 2018 Instamobile. All rights reserved.
//

import UIKit

class ATCChatHomeViewController: ATCGenericCollectionViewController {
  
  init(configuration: ATCGenericCollectionViewControllerConfiguration,
       selectionBlock: ATCollectionViewSelectionBlock?,
       viewer: ATCUser) {
    
    super.init(configuration: configuration, selectionBlock: selectionBlock)
    
    self.title = "TeamChat"
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  static func homeVC(uiConfig: ATCUIGenericConfigurationProtocol,
                     threadsDataSource: ATCGenericCollectionViewControllerDataSource,
                     viewer: ATCUser) -> ATCChatHomeViewController {
    let collectionVCConfiguration = ATCGenericCollectionViewControllerConfiguration(
      pullToRefreshEnabled: false,
      pullToRefreshTintColor: .gray,
      collectionViewBackgroundColor: .white,
      collectionViewLayout: ATCLiquidCollectionViewLayout(),
      collectionPagingEnabled: false,
      hideScrollIndicators: false,
      hidesNavigationBar: false,
      headerNibName: nil,
      scrollEnabled: true,
      uiConfig: uiConfig
    )
    
    let homeVC = ATCChatHomeViewController(configuration: collectionVCConfiguration, selectionBlock: { (navController, object) in
      
    }, viewer: ATCChatMockStore.users[0])
    
    
    // Configure Stories carousel
    let storiesVC = self.storiesViewController(uiConfig: uiConfig,
                                               dataSource: ATCGenericLocalDataSource<ATCUser>(items: ATCChatMockStore.users),
                                               viewer: viewer)
    let storiesCarousel = ATCCarouselViewModel(title: nil,
                                               viewController: storiesVC,
                                               cellHeight: 105)
    storiesCarousel.parentViewController = homeVC
    
    // Configure list of message threads
    let threadsVC = ATCChatThreadsViewController.mockThreadsVC(uiConfig: uiConfig, dataSource: threadsDataSource, viewer: viewer)
    let threadsViewModel = ATCViewControllerContainerViewModel(viewController: threadsVC, cellHeight: nil, subcellHeight: 85)
    threadsViewModel.parentViewController = homeVC
    homeVC.use(adapter: ATCViewControllerContainerRowAdapter(), for: "ATCViewControllerContainerViewModel")
    
    // Finish home VC configuration
    homeVC.genericDataSource = ATCGenericLocalHeteroDataSource(items: [storiesCarousel, threadsViewModel])
    return homeVC
  }
  
  
  static func storiesViewController(uiConfig: ATCUIGenericConfigurationProtocol,
                                    dataSource: ATCGenericCollectionViewControllerDataSource,
                                    viewer: ATCUser) -> ATCGenericCollectionViewController {
    let layout = ATCCollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.minimumInteritemSpacing = 10
    layout.minimumLineSpacing = 10
    let configuration = ATCGenericCollectionViewControllerConfiguration(pullToRefreshEnabled: false,
                                                                        pullToRefreshTintColor: .white,
                                                                        collectionViewBackgroundColor: .white,
                                                                        collectionViewLayout: layout,
                                                                        collectionPagingEnabled: false,
                                                                        hideScrollIndicators: true,
                                                                        hidesNavigationBar: false,
                                                                        headerNibName: nil,
                                                                        scrollEnabled: true,
                                                                        uiConfig: uiConfig)
    let vc = ATCGenericCollectionViewController(configuration: configuration, selectionBlock: ATCChatHomeViewController.storySelectionBlock(viewer: viewer))
    vc.genericDataSource = dataSource
    vc.use(adapter: ATCChatUserStoryAdapter(uiConfig: uiConfig), for: "ATCUser")
    return vc
  }
  
  static func storySelectionBlock(viewer: ATCUser) -> ATCollectionViewSelectionBlock? {
    return { (navController, object) in
      let uiConfig = ATCChatUIConfiguration(primaryColor: UIColor(hexString: "#0084ff"),
                                            secondaryColor: UIColor(hexString: "#f0f0f0"),
                                            inputTextViewBgColor: UIColor(hexString: "#f4f4f6"),
                                            inputTextViewTextColor: .black,
                                            inputPlaceholderTextColor: UIColor(hexString: "#979797"))
      if let user = object as? ATCUser {
        let id1 = (user.uid ?? "")
        let id2 = (viewer.uid ?? "")
        let channelId = "\(id1):\(id2)"
        print("loading thread for channelID: \(channelId)")
        let vc = ATCChatThreadViewController(user: viewer, channel: ATCChatChannel(id: channelId, name: user.fullName()), uiConfig: uiConfig)
        navController?.pushViewController(vc, animated: true)
      }
    }
  }
}
