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
    var itemPublisher: Published<Item>.Publisher { $item }
    
    @Published var isEditing = true
    @Published var itemImage: UIImage?
    @Published var isSeller = false
    @Published var isSaved = false
    @Published var isSold = false
    @Published var isGuest = false
    private var db = Firestore.firestore()
    
    func verifyInfo() -> Bool {
        return !item.title.isEmpty && !item.price.isEmpty && !item.size.isEmpty && !item.condition.isEmpty && hasValidPrice()
    }
    
    private func hasValidPrice() -> Bool {
        let price = Float(item.price)
        return price != nil && price! < 1000
    }
    
    func fetchUser(itemID: String, completion: @escaping () -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {return}
        let userRef = db.collection("users").document(userID)
        
        userRef.getDocument(as: User.self) { result in
            switch result {
            case .success(let user):
                self.isSaved = user.saved.contains(itemID)
                self.isSold = user.sold.contains(itemID)
                self.isGuest = user.id == "iR0c0aZXPoRsw5DN3cpmf9mzUEK2"
                completion()
            case .failure(let error):
                print("Error decoding user: \(error)")
            }
        }
    }
    
    // Find an item in the database with a particular id
    func fetchItem(with id: String, completion: @escaping () -> Void) {
        fetchUser(itemID: id) {
            self.db.collection("items")
                .document(id)
                .getDocument(as: Item.self) { result in
                    switch result {
                    case .success(let item):
                        self.item = item
                        self.isSeller = (item.sellerId == Auth.auth().currentUser?.uid)
                        self.isGuest = Auth.auth().currentUser?.uid == "iR0c0aZXPoRsw5DN3cpmf9mzUEK2"
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
                        completion()
                    case .failure(let error):
                        print("Error decoding item: \(error)")
                    }
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
        
    }
    
    // go through each bidder and remove from their bids
    func sellItem() {
        for bid in item.bidHistory {
            db.collection("users").document(bid.key).updateData([
                "bids": FieldValue.arrayRemove([item.id])
            ]) { error in
                if let e = error {
                    print("There was an issue saving data to Firestore, \(e).")
                } else {
                    print("Successfully removed item from each bidder.")
                    self.isSold = true
                }
            }
        }
    }
    
    func saveItem() {
        guard let userId = Auth.auth().currentUser?.uid else {return}
        db.collection("users").document(userId).updateData([
            "saved": FieldValue.arrayUnion([item.id])
        ]) { (error) in
            if let e = error {
                print("There was an issue saving data to Firestore, \(e).")
            } else {
                print("Successfully saved item.")
                self.isSaved = true
            }
        }
    }
    
    func unsaveItem() {
        guard let userId = Auth.auth().currentUser?.uid else {return}
        db.collection("users").document(userId).updateData([
            "saved": FieldValue.arrayRemove([item.id])
        ]) { (error) in
            if let e = error {
                print("There was an issue saving data to Firestore, \(e).")
            } else {
                print("Successfully unsaved item.")
                self.isSaved = false
            }
        }
    }
    
    // TODO: not yet fully implemented
    func sendNotification() {
        db.collection("users").document(item.sellerId).getDocument(as: User.self) { result in
            switch result {
            case .success(let user):
                self.makeRequest(to: user.token)
            case .failure(let error):
                print("Error decoding user: \(error)")
            }
        }
    }
    
    func makeRequest(to token: String) {
        let messageBody = ["title": "hello", "body": "you have successfully made a bid"]
        let body: [String: Any] = [
            "to": token,
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
                print("successfully sent to \(token)")
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                if let responseJSON = responseJSON as? [String: Any] {
                    print("response: \(responseJSON)")
                }
            }
        }
        
        task.resume()
        
    }
}
