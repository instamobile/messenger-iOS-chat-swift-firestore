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
        ATCUser(uid: "1", firstName: "Florian", lastName: "Marcu", avatarURL: "https://scontent-sjc3-1.xx.fbcdn.net/v/t1.0-1/p160x160/29597813_2121995191149827_5819918472649375744_n.jpg?_nc_cat=0&_nc_log=1&oh=11b25905f592585ce5b0ed828018bf97&oe=5C001AEC", email: "test@gmail.com", isOnline: false),
        ATCUser(uid: "2", firstName: "Cristina", lastName: "Radulescu", avatarURL: "https://scontent-sjc3-1.xx.fbcdn.net/v/t1.0-1/p160x160/22449666_1639860456076867_3545872153636299949_n.jpg?_nc_cat=0&_nc_log=1&oh=97ae550175e007c469175be0c64b202b&oe=5C09EC1B", email: "testcristina@gmail.com", isOnline: true),
        ATCUser(uid: "3", firstName: "Ben", lastName: "Marcu", avatarURL: "https://scontent-sjc3-1.xx.fbcdn.net/v/t1.0-1/p160x160/36754155_1408920955904513_1699511270467698688_n.jpg?_nc_cat=0&_nc_log=1&oh=aa26194ab77b90184ff1d84b09fa461f&oe=5C3A9E55", email: "benjamin@gmail.com", isOnline: false),
        ATCUser(uid: "324", firstName: "Debbie", lastName: "Rudin", avatarURL: "https://scontent-sjc3-1.xx.fbcdn.net/v/t1.0-1/p160x160/36856097_1734031453371469_8786514446274002944_n.jpg?_nc_cat=0&_nc_log=1&oh=5c99ca549c893004566a82c061a34d39&oe=5C0819FE", email: "deb@gmail.com", isOnline: true),
        ATCUser(uid: "12", firstName: "Mark", lastName: "Horrowitz", avatarURL: "https://scontent-sjc3-1.xx.fbcdn.net/v/t1.0-1/p160x160/15589860_1349325718420477_3094794729846578388_n.jpg?_nc_cat=0&_nc_log=1&oh=0572f75c2909dc9e780f0e14f4a509a0&oe=5BF6D46C", email: "mark@gmail.com", isOnline: true),
        ATCUser(uid: "1542", firstName: "Marius", lastName: "Sacca", avatarURL: "https://scontent-sjc3-1.xx.fbcdn.net/v/t1.0-1/p160x160/22788987_1862521183777422_2051858414477110741_n.jpg?_nc_cat=0&_nc_log=1&oh=43ab6b8b25c3721312f004fce712ad46&oe=5C3A9734", email: "Sacca@gmail.com", isOnline: false),
        ATCUser(uid: "65", firstName: "Serious", lastName: "John", avatarURL: "https://scontent-sjc3-1.xx.fbcdn.net/v/t1.0-1/c0.15.100.100/1965025_10202558366375605_1358193226_n.jpg?_nc_cat=0&_nc_log=1&oh=0cea57c9639fba1b1f85c9183e692d62&oe=5C0BA2F5", email: "asda@gmail.com", isOnline: false),
        ATCUser(uid: "543", firstName: "Flav", lastName: "Houston", avatarURL: "https://scontent-sjc3-1.xx.fbcdn.net/v/t1.0-1/p160x160/15941199_10211646783709143_4305563380035474309_n.jpg?_nc_cat=0&_nc_log=1&oh=6ae782dba40395e2b838c23b51a15292&oe=5C02960A", email: "fas@gmail.com", isOnline: false),
        ATCUser(uid: "5341", firstName: "Mike", lastName: "Montano", avatarURL: "https://scontent-sjc3-1.xx.fbcdn.net/v/t1.0-1/p160x160/26731324_1820868117946453_6634254513662463433_n.jpg?_nc_cat=0&_nc_log=1&oh=1d33684c90c8ccdac8d9fb7bd6674513&oe=5C02C61A", email: "65465hbtr@gmail.com", isOnline: false),
        ATCUser(uid: "5341", firstName: "Bogdan", lastName: "Tarca", avatarURL: "https://scontent-sjc3-1.xx.fbcdn.net/v/t1.0-1/p160x160/23754911_1686874304689488_466414949983210768_n.jpg?_nc_cat=0&_nc_log=1&oh=7277088bca635974108e2a2b47215dfa&oe=5BF89581", email: "23fg34g@gmail.com", isOnline: false),
        ATCUser(uid: "876", firstName: "Krystle", lastName: "Cheung", avatarURL: "https://scontent-sjc3-1.xx.fbcdn.net/v/t1.0-1/p160x160/34882950_2213777981971781_7582528181404434432_n.jpg?_nc_cat=0&_nc_log=1&oh=35e92a9b21057374887a14c49227a29a&oe=5C0EAC8A", email: "23fg34g@gmail.com", isOnline: false),
        ]

    static let threads = [
        ATChatMessage(messageId: "1", messageKind: MessageKind.text("That template is awesome \u{1F60D}"), createdAt: Date().yesterday, atcSender: users[2], recipient: users[0], seenByRecipient: true),
        ATChatMessage(messageId: "2", messageKind: MessageKind.text("\u{1F631} Wow, it's real time"), createdAt: Date().yesterday, atcSender: users[1], recipient: users[0], seenByRecipient: false),
        ATChatMessage(messageId: "3", messageKind: MessageKind.text("Let's create a group, it works!"), createdAt: Date().yesterday, atcSender: users[0], recipient: users[3], seenByRecipient: true),
        ATChatMessage(messageId: "4", messageKind: MessageKind.text("Yo, yo, long time, no see"), createdAt: Date().yesterday, atcSender: users[6], recipient: users[0], seenByRecipient: false),
        ATChatMessage(messageId: "5", messageKind: MessageKind.text("Who cares, dude? \u{1F61D}"), createdAt: Date().yesterday, atcSender: users[4], recipient: users[0], seenByRecipient: true),
        ATChatMessage(messageId: "6", messageKind: MessageKind.text("Are you there?"), createdAt: Date().yesterday, atcSender: users[5], recipient: users[0], seenByRecipient: true),
        ATChatMessage(messageId: "7", messageKind: MessageKind.text("Let's talk tomorrow"), createdAt: Date().yesterday, atcSender: users[0], recipient: users[7], seenByRecipient: true),
        ATChatMessage(messageId: "8", messageKind: MessageKind.text("Nope, too late"), createdAt: Date().yesterday, atcSender: users[0], recipient: users[8], seenByRecipient: true),
        ATChatMessage(messageId: "9", messageKind: MessageKind.text("It supports emojis! \u{1F648}"), createdAt: Date().yesterday, atcSender: users[0], recipient: users[9], seenByRecipient: true),
        ATChatMessage(messageId: "10", messageKind: MessageKind.text("Hard to believe \u{1F613}"), createdAt: Date().yesterday, atcSender: users[10], recipient: users[0], seenByRecipient: true),
    ]
}
