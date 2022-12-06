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

// Class for a view model that manages database connections for working with an item.
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
    
    // Function that verifies if all required information for an item is valid and present.
    func verifyInfo() -> Bool {
        if Float(chosenPrice) != nil {
            let price: Float = Float(chosenPrice)!
            return !item.title.isEmpty && !item.size.isEmpty && !item.condition.isEmpty && price > 0 && price < 1000
        }
        return false
    }
    
    // Function that manages the selection of an image for the item from the camera roll.
    func choosePicture(chosenPicture: Binding<UIImage?>, pickerShowing: Binding<Bool>, isLoading: Binding<Bool>) -> some UIViewControllerRepresentable {
        return PicturePicker(chosenPicture: chosenPicture, pickerShowing: pickerShowing, isLoading: isLoading)
    }
    
    // Function that manages the update of item data.
    func updateItem(completion: @escaping () -> Void) -> Bool {
        let db = Firestore.firestore()
        
        if let price = Float(chosenPrice) {
            item.price = price
        } else {
            return false
        }
        
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
    
    // Function that manages the posting of a new item to the marketplace.
    func postItem(completion: @escaping (String) -> Void) {
        let userId = Auth.auth().currentUser?.uid
        updateUserListings()
        
        // Function that adds the new item ID in the seller's item listings.
        func updateUserListings() {
            addItem() {
                let db = Firestore.firestore()
                
                // Update listings once item has been added to Firebase.
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
        
        // Function that adds an item to the database.
        func addItem(completion: @escaping () -> Void) -> Bool {
            // Check that price is a floating-point value.
            if let price = Float(chosenPrice) {
                item.price = price
            }
            else {return false}
            
            uploadNewPicture() {
                let db = Firestore.firestore()
                
                // Try to add item to the database after picture has uploaded to storage.
                do {
                    try db.collection("items").document(self.item.id).setData(from: self.item)
                    print("Successfully saved data.")
                    completion()
                } catch let error {
                    print("There was an issue saving data to Firestore, \(error).")
                }
            }
            return true
        }
        
        // Function that handles the upload of an image to Firebase Storage.
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
    
    // Add tag for an item.
    func addTag(for tag: String) {
        tags.append(tag)
        tagsLeft[tag] = 0
    }
    
    // Remove tag for an item.
    func removeTag(for tag: String) {
        tags = tags.filter { $0 != tag }
        tagsLeft[tag] = 1
    }
    
    // Delete an item and corresponding data from the app.
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
