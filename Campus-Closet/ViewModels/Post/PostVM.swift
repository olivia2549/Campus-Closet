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

@MainActor class PostVM: ObservableObject, HandlesTagsVM {
    @Published var tags: [String] = []
    @Published var item = ItemModel()
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
    
    func postItem() {
        let db = Firestore.firestore()
        guard let price = Float(item.price) else {
            print("invalid price")
            return
        }
        
        db.collection("items").document(item.id).setData([
            "_id": item.id,
            "title": item.title,
            "description": item.description,
            "sellerId": item.sellerId,
            "price": price,
            "size": item.size,
            "biddingEnabled": item.biddingEnabled,
            "tags": tags,
            "condition": item.condition
        ]) { (error) in
            if let e = error {
                print("There was an issue saving data to Firestore, \(e).")
            } else {
                print("Successfully saved data.")
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
    
}
