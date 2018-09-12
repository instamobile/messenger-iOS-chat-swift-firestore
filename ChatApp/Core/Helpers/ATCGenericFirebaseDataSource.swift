//
//  ATCGenericFirebaseDataSource.swift
//  ShoppingApp
//
//  Created by Florian Marcu on 10/15/17.
//  Copyright © 2017 iOS App Templates. All rights reserved.
//

import Firebase

let kItemsPerPage: UInt = 10

class ATCGenericFirebaseDataSource<T: ATCGenericBaseModel & ATCGenericFirebaseParsable>: ATCGenericCollectionViewControllerDataSource {
    weak var delegate: ATCGenericCollectionViewControllerDataSourceDelegate?

    private let dbRef = Database.database().reference()
    private var store: [T] = [T]()
    private var lastFetchedObjectKey: Any?
    private var didFinishLoadingBottom = false
    private let dbChild: DatabaseReference

    init(tableName: String) {
        dbChild = dbRef.child(tableName)
    }

    func object(at index: Int) -> ATCGenericBaseModel? {
        return store[index]
    }

    func numberOfObjects() -> Int {
        return store.count
    }

    func loadFirst() {
        dbChild
            .queryOrderedByKey()
            .queryLimited(toFirst: kItemsPerPage)
            .observeSingleEvent(of: .value, with: { snapshot in
                let results = self.parseResults(snapshot: snapshot)
                self.store += results
                if let children = snapshot.children.allObjects as? [DataSnapshot] {
                    self.lastFetchedObjectKey = children.last?.key
                }
                self.delegate?.genericCollectionViewControllerDataSource(self, didLoadFirst: results)
            })
    }

    func loadBottom() {
        if didFinishLoadingBottom {
            return
        }
        dbChild
            .queryOrderedByKey()
            .queryStarting(atValue: lastFetchedObjectKey)
            .queryLimited(toFirst: kItemsPerPage + 1)
            .observeSingleEvent(of: .value) { snapshot in
                var results = self.parseResults(snapshot: snapshot)
                results.removeFirst()
                self.didFinishLoadingBottom = (results.count == 0)
                self.store += results
                if let children = snapshot.children.allObjects as? [DataSnapshot], let last = children.last {
                    self.lastFetchedObjectKey = last.key
                }
                self.delegate?.genericCollectionViewControllerDataSource(self, didLoadBottom: results)
        }
    }

    func loadTop() {

    }

    private func parseResults(snapshot: DataSnapshot) -> [T] {
        var res = [T]()
        guard let children = snapshot.children.allObjects as? [DataSnapshot] else {
            return []
        }
        for child in children {
            if let dict = child.value as? [String: Any] {
                res.append(T(key: child.key, jsonDict: dict))
            }
        }
        return res
    }
}
