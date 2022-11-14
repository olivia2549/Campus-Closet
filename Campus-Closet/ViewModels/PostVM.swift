//
//  PostVM.swift
//  Campus-Closet
//
//  Created by Lauren Scott on 10/21/22.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

@MainActor class PostVM: ObservableObject, HandlesTagsVM, ItemInfoVM {
    @Published var chosenPicture: UIImage?
    @Published var item = Item()
    @Published var isEditing = false
    @Published var sellerIsAnonymous = false
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
    
    func verifyInfo() -> Bool {
        return !item.title.isEmpty && !item.price.isEmpty && !item.size.isEmpty && !item.condition.isEmpty && hasValidPrice()
    }
    
    private func hasValidPrice() -> Bool {
        let price = Float(item.price)
        return price != nil && price! < 1000
    }
    
    func choosePicture(chosenPicture: Binding<UIImage?>, pickerShowing: Binding<Bool>) -> some UIViewControllerRepresentable {
        return PicturePicker(chosenPicture: chosenPicture, pickerShowing: pickerShowing)
    }
    
    func postItem() {
        let userId = Auth.auth().currentUser?.uid
        var newPicturePath = ""
        updateUserListings()
        
        func updateUserListings() {
            addItem() {
                let db = Firestore.firestore()
                db.collection("users").document(userId!).updateData([
                    "listings": FieldValue.arrayUnion([self.item.id])
                ])
            }
        }
        
        func addItem(completion: @escaping () -> Void) {
            uploadNewPicture() {
                let db = Firestore.firestore()
                db.collection("items").document(self.item.id).setData([
                    "_id": self.item.id,
                    "title": self.item.title,
                    "picture": newPicturePath,
                    "description": self.item.description,
                    "sellerId": userId!,
                    "price": self.item.price,
                    "size": self.item.size,
                    "biddingEnabled": self.item.biddingEnabled,
                    "tags": self.tags,
                    "condition": self.item.condition,
                    "studentCreated": self.item.studentCreated,
                    "timestamp": Date.now
                ]) { (error) in
                    if let e = error {
                        print("There was an issue saving data to Firestore, \(e).")
                    } else {
                        print("Successfully saved data.")
                        completion()
                    }
                }
            }
        }
        
        func uploadNewPicture(completion: @escaping () -> Void) {
            if chosenPicture == nil {
                return
            }
            
            let storageRef = Storage.storage().reference()
            let pictureData = chosenPicture!.jpegData(compressionQuality: 0)
            var picturePath: String = "item-pictures/\(UUID().uuidString).jpeg"

            if pictureData != nil {
                let pictureRef = storageRef.child(picturePath)
                let _ = pictureRef.putData(pictureData!, metadata: nil) { metadata, error in
                    if error != nil || metadata == nil {
                        picturePath = ""
                    }
                    else {
                        newPicturePath = picturePath
                        completion()
                    }
                }
            }
        }
    }
    
    func addTag(for tag: String) {
        tags.append(tag)
        tagsLeft[tag] = 0
    }
    
    func removeTag(for tag: String) {
        tags = tags.filter { $0 != tag }
        tagsLeft[tag] = 1
    }
    
    func deleteItem() {
    }
}
