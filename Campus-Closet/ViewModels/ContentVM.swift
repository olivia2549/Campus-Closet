//
//  ContentVM.swift
//  Campus-Closet
//
//  Created by Olivia Logan on 10/23/22.
//

import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage
import Foundation

@MainActor class ContentVM: ObservableObject, HandlesTagsVM, RenderContentVM {
    private var db = Firestore.firestore()
    var user = User()
    @Published var sortedColumns: [[String]] = []
    @Published var tags: [String] = []
    @Published var tagsLeft = [
        "womens": 1,
        "mens": 1,
        "tops": 1,
        "bottoms": 1,
        "dresses": 1,
        "shoes": 1,
        "accessories": 1
    ]
    
    func fetchData() {
        fetchUser() {
            self.db.collection("items").order(by: "timestamp").addSnapshotListener{ querySnapshot, err in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    self.sortedColumns = []
                    var itemIdsCol1: [String] = []
                    var itemIdsCol2: [String] = []
                    var col1 = true
                    for document in querySnapshot!.documents {
                        let itemID = document.get("_id") as! String
                        
                        // Do not show buyers items they've bid on or saved
                        if self.user.saved.contains(itemID) || self.user.bids.contains(itemID) {
                            continue
                        }
                        guard let sellerID = document.get("sellerId") else {return}
                        guard let userID = Auth.auth().currentUser?.uid else {return}
                        
                        
                        
                        // Do not show sellers their own items.
//                        if (document.get("sellerId") as! String) == userID {
//                            continue
//                        }
                        if (sellerID as! String) == userID {
                            continue
                        }
                        
                        // Filter tags
                        let itemTags = document.get("tags") as! [String]
                        var shouldShow = true
                        for tag in self.tagsLeft {
                            if tag.value == 0 {
                                if !itemTags.contains(where: {$0 == tag.key}) {
                                    print("don't show, key: \(tag.key)")
                                    shouldShow = false
                                    break
                                }
                            }
                        }
                        if shouldShow {
                            col1 ? itemIdsCol1.append(document.documentID) :
                                itemIdsCol2.append(document.documentID)
                            col1.toggle()
                        }
                    }
                    self.sortedColumns.append(itemIdsCol1)
                    self.sortedColumns.append(itemIdsCol2)
                }
            }
        }
    }
    
    func fetchUser(completion: @escaping () -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {return}
        let userRef = db.collection("users").document(userID)
        
        userRef.getDocument(as: User.self) { result in
            switch result {
            case .success(let user):
                self.user = user
                completion()
            case .failure(let error):
                print("Error decoding user: \(error)")
            }
        }
    }
    
    func addTag(for tag: String) {
        tags.append(tag)
        tagsLeft[tag] = 0
        fetchData()
    }
    
    func removeTag(for tag: String) {
        tags = tags.filter { $0 != tag }
        tagsLeft[tag] = 1
        fetchData()
    }
}
