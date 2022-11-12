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
    
    func verifyInfo() -> Bool {
        return !item.title.isEmpty && !item.price.isEmpty && !item.size.isEmpty && !item.condition.isEmpty && hasValidPrice()
    }
    
    private func hasValidPrice() -> Bool {
        let price = Float(item.price)
        return price != nil && price! < 1000
    }
    
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
    
    func sendNotification() {
        let user = ProfileVM().fetchUser(userID: item.sellerId)
        
        let messageBody = ["title": "hello", "body": "you have successfully made a bid"]
        let body: [String: Any] = [
            "to": user.token,
            "notification": messageBody,
            "data": []
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: body)
        
        let url = URL(string: "https://fcm.googleapis.com/fcm/send")!
        let serverKey = "AAAA_IxReKc:APA91bEq-CiQa_N6FrcdR5N0BnYXK5TLGzQ9WKcPCY8YDgOgFVNoS7viBitcoHahfdMXPlb17ryx1t4P2vPtFXfocTauxYjRsTaE-Tpre6-mcXvxn60BQD66v1Vk5oIwWyBBVqA_YKtU"
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=\(serverKey)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                print(error?.localizedDescription ?? "No data")
                return
            }
            if let data = data {
                print("successfully sent")
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                if let responseJSON = responseJSON as? [String: Any] {
                    print("response: \(responseJSON)")
                }
            }
        }
        
        task.resume()
        
    }
    
}
