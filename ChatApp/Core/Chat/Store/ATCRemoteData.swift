//
//  ATCRemoteData.swift
//  ChatApp
//
//  Created by Dan Burkhardt on 3/20/19.
//  Copyright © 2019 Instamobile. All rights reserved.
//

import Foundation
import Firebase

/// Sample class that gets all channels from the remote data store.
class ATCRemoteData{
    let db = Firestore.firestore()
    
    func getChannels(){
        print("getting all channels")
        db.collection("channels").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Firebase returned an error while getting chat documents: \(err)")
            } else {
                if querySnapshot?.documents == nil{
                    print("no channels or threads found for this user's organization\n. No worries a brand new one will automatically be created when you first attempt to send a message")
                }else{
                    // Uncomment to see all documents in this user's org
                    // Usually a bad thing though, only use to debug and do not release
//                    for document in querySnapshot!.documents {
//                        print("\(document.documentID) => \(document.data())")
//                    }
                }
            }
        }
    }
    
    /// Function ensures that all
    func checkPath(path: [String], dbRepresentation: [String:Any]){
        print("checking for the db snapshopt of main chat store: '\(path[0])'")
        db.collection(path[0]).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                if querySnapshot?.documents != nil {
                    print("checking for channelID: \(path[1])")
                    let channelIDRef = self.db.collection(path[0]).document(path[1])
                    channelIDRef.getDocument { (document, error) in
                        if let document = document, document.exists {
                            
                            print("chat thread exists for \(dbRepresentation)")
                            // Uncomment to see the data description
                            //let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                        } else {
                            print("adding indexable values to the database representation")
                            var modifiedDBRepresentation = dbRepresentation
                            
                            // We will always have a thread ID with participants separated
                            // by a ':' character, so let's work with that
                            if let participants = (dbRepresentation["id"] as? String)?.components(separatedBy: ":"){
                                modifiedDBRepresentation["participants"] = participants
                                // Now, on Firestore, set your database to be indexed on "participants"
                                // This allows you to search for all documents that have a particular participant present
                                // say for example, retrieving only the threads to which the current logged-in user belongs
                            }else{
                                print("somehow we didn't have participant IDs, big issues")
                            }
                            
                            print("chat thread does not currently exist for \(dbRepresentation)")
                            print("creating chat thread for \(dbRepresentation)")
                            channelIDRef.setData(dbRepresentation) { err in
                                if let err = err {
                                    print("Firestore error returned when creating chat thread!: \(err)")
                                } else {
                                    print("chat thread successfully created")
                                }
                            }
                        }
                    }
                }else{
                    print("querySnapshot.documents was nil")
                    // TODO: usually, you don't want all of your users to see all of the other users of your app
                    // append an organization or "group" name to the path, BEFORE channels to make sure your user
                    // groups do not bleed over
                    self.db.collection(path[0]).document(path[1]).setData(dbRepresentation){ err in
                        if let err = err {
                            print("Firestore error returned when creating chat thread!: \(err)")
                        } else {
                            print("chat channel and thread successfully created!")
                        }
                    }
                }
            }
        }
    }
    
}
