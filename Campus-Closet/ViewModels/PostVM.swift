//
//  PostVM.swift
//  Campus-Closet
//
//  Created by Lauren Scott on 10/21/22.
//

import Foundation
import Firebase
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

@MainActor class PostVM: ObservableObject {
    // TODO: Fetch and enter user-input data instead of this sample data.
    @Published var name: String = "Sample shirt"
    @Published var price: Float = 10.99
    @Published var biddingEnabled: Bool = true
    @Published var type: String = "shirt"
    @Published var condition: String = "lightly worn"

    func postItem() {
        let db = Firestore.firestore()
        
        db.collection("items").addDocument(data: [
            "name": name,
            "price": price,
            "biddingEnabled": biddingEnabled,
            "type": type,
            "condition": condition
        ]) { (error) in
            if let e = error {
                print("There was an issue saving data to Firestore, \(e).")
            } else {
                print("Successfully saved data.")
            }
        }
    }
}
