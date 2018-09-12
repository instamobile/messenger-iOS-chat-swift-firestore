//
//  ATCChatChannel.swift
//  ChatApp
//
//  Created by Florian Marcu on 8/26/18.
//  Copyright © 2018 Instamobile. All rights reserved.
//

import FirebaseFirestore

struct ATCChatChannel {

    let id: String
    let name: String

    init(id: String, name: String) {
        self.id = id
        self.name = name
    }

    init?(document: QueryDocumentSnapshot) {
        let data = document.data()

        guard let name = data["name"] as? String else {
            return nil
        }

        id = document.documentID
        self.name = name
    }
}

extension ATCChatChannel: DatabaseRepresentation {

    var representation: [String : Any] {
        var rep = ["name": name]
        rep["id"] = id
        return rep
    }

}

extension ATCChatChannel: Comparable {

    static func == (lhs: ATCChatChannel, rhs: ATCChatChannel) -> Bool {
        return lhs.id == rhs.id
    }

    static func < (lhs: ATCChatChannel, rhs: ATCChatChannel) -> Bool {
        return lhs.name < rhs.name
    }

}
