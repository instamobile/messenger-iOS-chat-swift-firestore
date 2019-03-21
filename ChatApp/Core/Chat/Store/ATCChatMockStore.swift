//
//  ATCChatMockStore.swift
//  ChatApp
//
//  Created by Florian Marcu on 8/18/18.
//  Copyright © 2018 Instamobile. All rights reserved.
//

import MessageKit
import UIKit

class ATCChatMockStore {
    static let users = [
        ATCUser(uid: "dan", firstName: "Dan", lastName: "Burkhardt", avatarURL: "https://cdn0.iconfinder.com/data/icons/avatar-2/500/man-2-512.png", email: "test@gigabitelabs.com", isOnline: false),
        ATCUser(uid: "simulator", firstName: "iPhone", lastName: "Simulator", avatarURL: "https://cdn-images-1.medium.com/max/1000/1*QUmlH0_tRyjlbxVkSKtk3A.png", email: "testcristina@gmail.com", isOnline: true),
        ATCUser(uid: "sandra", firstName: "Sandra", lastName: "O'Connor", avatarURL: "https://cdn0.iconfinder.com/data/icons/people-avatar-flat/64/girl_ginger_curly_people_woman_teenager_avatar-512.png", email: "testcristina@gmail.com", isOnline: true),
        ATCUser(uid: "sam", firstName: "Sam", lastName: "Smith", avatarURL: "https://cdn1.iconfinder.com/data/icons/avatar-2-2/512/Programmer-512.png", email: "testcristina@gmail.com", isOnline: false),
        ATCUser(uid: "tom", firstName: "Tom", lastName: "Bradley", avatarURL: "https://cdn3.iconfinder.com/data/icons/business-avatar-1/512/4_avatar-512.png", email: "testcristina@gmail.com", isOnline: true),
        ]
 
    // HEY AGAIN: set the users for stcSender and atcRecipient on one of these so that one is the user
    // for your simulator, the other one is your device
    static let threads = [
        ATChatMessage(messageId: "1", messageKind: MessageKind.text("TestThread"), createdAt: Date().yesterday, atcSender: users[2], recipient: users[0], seenByRecipient: false),// <- try this one
        ATChatMessage(messageId: "2", messageKind: MessageKind.text("\u{1F631} Wow, it's real time"), createdAt: Date().yesterday, atcSender: users[1], recipient: users[0], seenByRecipient: true)
    ]
}
