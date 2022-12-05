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

@MainActor class PostVM: ObservableObject, HandlesTagsVM {
    @Published var item = Item()
    @Published var chosenPrice = ""
    @Published var chosenPicture: UIImage?
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
        "accessories": 1,
        "new": 1,
        "lightly used": 1,
        "used": 1
    ]
    
    func verifyInfo() -> Bool {
        return !item.title.isEmpty && !item.size.isEmpty && !item.condition.isEmpty && item.price < 1000
    }
    
    func choosePicture(chosenPicture: Binding<UIImage?>, pickerShowing: Binding<Bool>, isLoading: Binding<Bool>) -> some UIViewControllerRepresentable {
        return PicturePicker(chosenPicture: chosenPicture, pickerShowing: pickerShowing, isLoading: isLoading)
    }
    
    func updateItem(completion: @escaping () -> Void) -> Bool {
        let db = Firestore.firestore()
        if let price = Float(chosenPrice) {
            item.price = price
        }
        else {return false}
        db.collection("items").document(item.id).updateData([
            "title": item.title,
            "description": item.description,
            "price": item.price,
            "size": item.size,
            "condition": item.condition
        ]) { (error) in
            if let e = error {
                print("There was an issue saving data to Firestore, \(e).")
            } else {
                print("Successfully updated the item.")
                completion()
            }
        }
        return true
    }
    
    func postItem(completion: @escaping (String) -> Void) {
        let userId = Auth.auth().currentUser?.uid
        updateUserListings()
        
        func updateUserListings() {
            addItem() {
                print("completion called")
                let db = Firestore.firestore()
                db.collection("users").document(userId!).updateData([
                    "listings": FieldValue.arrayUnion([self.item.id])
                ]) { (error) in
                    if let e = error {
                        print("There was an issue saving data to Firestore, \(e).")
                    } else {
                        print("Successfully saved data: \(self.item.id).")
                        completion(self.item.id)
                    }
                }
            }
        }
        
        func addItem(completion: @escaping () -> Void) -> Bool {
            if let price = Float(chosenPrice) {
                item.price = price
            }
            else {return false}
            uploadNewPicture() {
                let db = Firestore.firestore()
                do {
                    try db.collection("items").document(self.item.id).setData(from: self.item)
                    print("Successfully saved data.")
                    completion()
                }
                catch let error {
                    print("There was an issue saving data to Firestore, \(error).")
                }
            }
            return true
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
                        self.item.picture = picturePath
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
        let db = Firestore.firestore()
        db.collection("items").document(item.id).delete() { error in
            if let e = error {
                print("There was an issue deleting the item, \(e)")
            } else {
                print("Successfully deleted from items.")
                if let user = Auth.auth().currentUser?.uid {
                    db.collection("users").document(user).updateData([
                        "listings": FieldValue.arrayRemove([self.item.id])
                    ]) { error in
                        if let e = error {
                            print("There was an issue deleting the item, \(e)")
                        } else {
                            print("Successfully deleted from listings.")
                        }
                    }
                }
            }
        }
    }
}
