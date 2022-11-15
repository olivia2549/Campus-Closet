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
        db.collection("items").order(by: "timestamp").addSnapshotListener{ querySnapshot, err in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.sortedColumns = []
                var itemIdsCol1: [String] = []
                var itemIdsCol2: [String] = []
                var col1 = true
                for document in querySnapshot!.documents {
                    // Do not show sellers their own items.
                    if (document.get("sellerId") as! String) != Auth.auth().currentUser?.uid {
                        let itemTags = document.get("tags") as! [String]
                        var shouldShow = true
                        
                        for tag in self.tagsLeft {
                            if tag.value == 0 {
                                if !itemTags.contains(where: {$0 == tag.key}) {
                                    print("don't show, key: \(tag.key)")
                                    shouldShow = false
                                    break
                                }
                                else {
                                    col1 ? itemIdsCol1.append(document.documentID) :
                                        itemIdsCol2.append(document.documentID)
                                    col1.toggle()
                                }
                            }
                        }
                        if shouldShow {
                            col1 ? itemIdsCol1.append(document.documentID) :
                                itemIdsCol2.append(document.documentID)
                            col1.toggle()
                        }
                    }
                }
                self.sortedColumns.append(itemIdsCol1)
                self.sortedColumns.append(itemIdsCol2)
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
