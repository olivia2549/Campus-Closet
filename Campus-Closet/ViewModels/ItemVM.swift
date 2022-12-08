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

// Class for a view model that manages item interactions with the database.
@MainActor class ItemVM: ObservableObject {
    @Published var item = Item()
    var itemPublisher: Published<Item>.Publisher { $item }
    @Published var chosenPrice = ""
    @Published var isEditing = true
    @Published var itemImage: UIImage?
    @Published var isSeller = false
    @Published var isSaved = false
    @Published var isBidder = false
    private var db = Firestore.firestore()
    
    // Function that fetches item data, including the ID of its seller.
    func fetchSeller(for itemId: String, curUser: User, completion: @escaping () -> Void) {
        fetchItem(itemID: itemId) {
            self.db.collection("users").document(self.item.sellerId).getDocument(as: User.self) { result in
                switch result {
                case .success(let user):
                    self.isSaved = curUser.saved.contains(itemId)
                    completion()
                case .failure(let error):
                    print("Error decoding user: \(error)")
                }
            }
        }
    }
    
    // Function that fetches item data from the database.
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
    
    // Sell an item
    func sellItem(bid: Bid) {
        db.collection("items").document(item.id).updateData([
            "isSold": true
        ]) { error in
            if let e = error {
                print("There was an issue saving data to Firestore, \(e).")
            } else {
                print("Successfully sold.")
                removeBids()
            }
        }
        
        // Go through each bidder and remove from their bids.
        func removeBids() {
            var sentToBidder = false
            for bidData in item.bidHistory {
                db.collection("users").document(bidData.key).updateData([
                    "bids": FieldValue.arrayRemove([item.id])
                ]) { error in
                    if let e = error {
                        print("There was an issue saving data to Firestore, \(e).")
                    } else {
                        print("Successfully removed item from each bidder.")
                        // Send according push notifications
                        if (bidData.key == bid.bidderId && !sentToBidder) {
                            sentToBidder = true
                            sendOfferAccepted()
                        }
                        else {
                            sendItemSold()
                        }
                    }
                }
            }
        }
        
        func sendOfferAccepted() {
            NotificationsVM()
                .sendItemNotification(
                    to: bid.bidderId,
                    type: "Offer Accepted",
                    itemName: self.item.title,
                    price: bid.offer
                )
        }
        
        func sendItemSold() {
            NotificationsVM()
                .sendItemNotification(
                    to: bid.bidderId,
                    type: "Item Sold",
                    itemName: self.item.title,
                    price: bid.offer
                )
        }
    }
    
    // Function that adds an item to the current user's saved items.
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
    
    // Function that removes an item from the current user's saved items.
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
    
    // Function that deletes a bid placed by the current user.
    func removeBid() {
        guard let myId = Auth.auth().currentUser?.uid else {return}
        // Remove from the buyer's bids and remove from their saved.
        db.collection("users").document(myId).updateData([
            "bids": FieldValue.arrayRemove([item.id]),
        ]) { (error) in
            if let e = error {
                print("There was an issue removing your bid, \(e).")
            } else {
                print("Successfully removed bid.")
            }
        }
        
        // Get the bid's ID and remove from bids collection.
        let itemRef = db.collection("items").document(item.id)
        itemRef.getDocument { document, error in
            if let document = document, document.exists {
                let bidHistory = document.get("bidHistory") as! [String:String]
                if let bidId = bidHistory["\(myId)"] {
                    self.db.collection("bids").document(bidId).delete()
                    // Remove from the item's bid history.
                    itemRef.updateData([
                        "bidHistory.\(myId)": FieldValue.delete(),
                    ]) { (error) in
                        if let e = error {
                            print("There was an issue removing from the item's bid history, \(e).")
                        } else {
                            print("Successfully removed bid.")
                            // Notify seller that the bid was removed.
                            NotificationsVM()
                                .sendItemNotification(
                                    to: self.item.sellerId,
                                    type: "Offer Removed",
                                    itemName: self.item.title,
                                    price: ""
                                )
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
