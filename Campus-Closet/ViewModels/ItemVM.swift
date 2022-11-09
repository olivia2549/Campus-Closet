//
//  ItemVM.swift
//  Campus-Closet
//
//  Created by Hilly Yehoshua on 10/30/22.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage

@MainActor class ItemVM: ObservableObject, ItemInfoVM {
    @Published var item = Item()
    @Published var isEditing = true
    @Published var itemImage: UIImage?
    @Published var isSeller = false
    private var db = Firestore.firestore()
    
    // Find an item in the database with a particular id
    func fetchItem(with id: String) {
        db.collection("items")
            .document(id)
            .getDocument(as: Item.self) { result in
                switch result {
                case .success(let item):
                    self.item = item
                    self.isSeller = item.sellerId == Auth.auth().currentUser?.uid
                    let pictureRef = Storage.storage().reference(withPath: self.item.picture)
                    // Download profile picture with max size of 30MB.
                    pictureRef.getData(maxSize: 30 * 1024 * 1024) { (data, error) in
                        if let err = error {
                            print(err)
                        } else if data != nil {
                            if let picture = UIImage(data: data!) {
                                DispatchQueue.main.async {
                                    self.itemImage = picture
                                }
                            }
                        }
                    }
                case .failure(let error):
                    print("Error decoding item: \(error)")
                }
            }
    }
    
    // Update an item (after editing)
    func postItem() {
        let db = Firestore.firestore()
        db.collection("items").document(item.id).updateData([
            "title": item.title,
            "description": item.description,
            "price": item.price,
            "size": item.size,
        ]) { (error) in
            if let e = error {
                print("There was an issue saving data to Firestore, \(e).")
            } else {
                print("Successfully saved data.")
            }
        }
    }
    
    func deleteItem() {
        let db = Firestore.firestore()
        db.collection("items").document(item.id).delete()
        if let user = Auth.auth().currentUser?.uid {
            db.collection("users").document(user).updateData([
                "listings": FieldValue.arrayRemove([item.id])
            ]) { error in
                if let e = error {
                    print("There was an issue deleting the item, \(e)")
                } else {
                    print("Successfully deleted.")
                }
            }
        }
    }
    
}
