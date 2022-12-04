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
    @Published var isBidder = false
    private var db = Firestore.firestore()
    
    func verifyInfo() -> Bool {
        return !item.title.isEmpty && !item.price.isEmpty && !item.size.isEmpty && !item.condition.isEmpty && hasValidPrice()
    }
    
    private func hasValidPrice() -> Bool {
        let price = Float(item.price)
        return price != nil && price! < 1000
    }
    
    func fetchSeller(with id: String, completion: @escaping () -> Void) {
        fetchItem(itemID: id) {
            self.db.collection("users").document(self.item.sellerId).getDocument(as: User.self) { result in
                switch result {
                case .success(let user):
                    self.isSaved = user.saved.contains(id)
                    self.isSold = user.sold.contains(id)
                    completion()
                case .failure(let error):
                    print("Error decoding user: \(error)")
                }
            }
        }
    }
    
    func fetchItem(itemID: String, completion: @escaping () -> Void) {
        guard let myId = Auth.auth().currentUser?.uid else {return}
        db.collection("items").document(itemID).getDocument(as: Item.self) { result in
            switch result {
            case .success(let item):
                self.item = item
                self.isSeller = (item.sellerId == Auth.auth().currentUser?.uid)
                self.isBidder = (item.bidHistory[myId] != nil)
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
    
    func removeBid() {
        guard let myId = Auth.auth().currentUser?.uid else {return}
        // Remove from the buyer's bids and remove from their saved
        db.collection("users").document(myId).updateData([
            "bids": FieldValue.arrayRemove([item.id]),
        ]) { (error) in
            if let e = error {
                print("There was an issue removing your bid, \(e).")
            } else {
                print("Successfully removed bid.")
            }
        }
        
        // Get the bid's id and remove from bids collection
        let itemRef = db.collection("items").document(item.id)
        itemRef.getDocument { document, error in
            if let document = document, document.exists {
                let bidHistory = document.get("bidHistory") as! [String:String]
                if let bidId = bidHistory["\(myId)"] {
                    self.db.collection("bids").document(bidId).delete()
                    // Remove from the item's bid history
                    itemRef.updateData([
                        "bidHistory.\(myId)": FieldValue.delete(),
                    ]) { (error) in
                        if let e = error {
                            print("There was an issue removing from the item's bid history, \(e).")
                        } else {
                            print("Successfully removed bid.")
                            // TODO: Send notification to seller
                        }
                    }
                } else {
                    print("Couldn't find bid to delete.")
                }
            } else {
                print("Document does not exist")
            }
        }
        
    }
    
}
