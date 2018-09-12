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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Configure the UI
        let config = ChatUIConfiguration()
        config.configureUI()

        FirebaseApp.configure()

        let threadsDataSource = ATCGenericLocalHeteroDataSource(items: ATCChatMockStore.threads)

        // Window setup
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = ChatHostViewController(uiConfig: config,
                                                            threadsDataSource: threadsDataSource,
                                                            viewer: ATCChatMockStore.users[1])
        window?.makeKeyAndVisible()

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }
}
