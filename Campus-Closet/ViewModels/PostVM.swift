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
    @Published var tags: [String] = []
    @Published var isEditing = false
    @Published var item = Item()
    @Published var chosenPicture: UIImage?
    @Published var sellerIsAnonymous = false
    @Published var tagsLeft = [
        "womens": 1,
        "mens": 1,
        "tops": 1,
        "bottoms": 1,
        "dresses": 1,
        "shoes": 1,
        "accessories": 1
    ]

    func choosePicture(chosenPicture: Binding<UIImage?>, pickerShowing: Binding<Bool>) -> some UIViewControllerRepresentable {
        return PicturePicker(chosenPicture: chosenPicture, pickerShowing: pickerShowing)
    }
    
    func uploadPicture() -> String {
        let storageRef = Storage.storage().reference()
        let pictureData = chosenPicture!.pngData()
        var picturePath: String = "item-pictures/\(UUID().uuidString).png"
        
        if pictureData != nil {
            let pictureRef = storageRef.child(picturePath)
            
            let upload = pictureRef.putData(pictureData!, metadata: nil) { metadata, error in
                if error != nil || metadata == nil {
                    picturePath = ""
                }
            }
        }
        
        return picturePath
    }
    
    func postItem() {
        let newPicturePath = uploadPicture()
        let userId = Auth.auth().currentUser?.uid
        
        // eventually want to use this and make price a float
//        guard let price = Float(item.price) else {
//            print("invalid price")
//            return
//        }
        
        let db = Firestore.firestore()
        db.collection("items").document(item.id).setData([
            "_id": item.id,
            "title": item.title,
            "picture": newPicturePath,
            "description": item.description,
            "sellerId": userId!,
            "price": item.price,
            "size": item.size,
            "biddingEnabled": item.biddingEnabled,
            "tags": tags,
            "condition": item.condition,
            "timestamp": Date.now
        ]) { (error) in
            if let e = error {
                print("There was an issue saving data to Firestore, \(e).")
            } else {
                print("Successfully saved data.")
            }
        }
        
        db.collection("users").document(userId!).updateData([
            "listings": FieldValue.arrayUnion([item.id])
        ])
    }
    
    func addTag(for tag: String) {
        tags.append(tag)
        tagsLeft[tag] = 0
    }
    
    func removeTag(for tag: String) {
        tags = tags.filter { $0 != tag }
        tagsLeft[tag] = 1
    }
    
}
