//
//  AppDelegate.swift
//  ChatApp
//
//  Created by Florian Marcu on 8/18/18.
//  Copyright © 2018 Instamobile. All rights reserved.
//

import Firebase
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // Configure the UI
        let config = ChatUIConfiguration()
        config.configureUI()

        FirebaseApp.configure()

        let threadsDataSource = ATCGenericLocalHeteroDataSource(items: ATCChatMockStore.threads)
        
        // HEY THERE, user. read the next few lines below
        // Helper file to access remote data for a user
        let remoteData = ATCRemoteData()
        // Checks if user's firestore actually has channels setup
        remoteData.getChannels()
        
        // For testing, set this to a usr from 0-4 and run it to your simulator
        // Then, set it to any other user and run it to your phone. THEN-> see my comment in ATCChatMockStore.swift
        let user = 2
        // If both devices have a different user active, AND the chat thread is available, you can msg live
        
        
        // Window setup
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = ChatHostViewController(uiConfig: config,
                                                            threadsDataSource: threadsDataSource,
                                                            viewer: ATCChatMockStore.users[user])
        
        print("currentUser: \(ATCChatMockStore.users[user].debugDescription)")
        window?.makeKeyAndVisible()

        return true
    }
}
