//
//  BidsVM.swift
//  Campus-Closet
//
//  Created by Olivia Logan on 11/22/22.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

// Class for a view model that manages bids and their database interactions.
class BidsVM: ObservableObject, ErrorVM {
    let db = Firestore.firestore()
    @Published var isError = false
    @Published var message = "Oops! There has been a problem placing your bid. Your bid price may be lower than the current listed price."
    @Published private(set) var bids: [Bid] = []
    
    func placeBid(item: Item, offer: String) {
        guard let myId = Auth.auth().currentUser?.uid else {
            isError = true
            return
        }
        let bidId = "\(UUID())"

        guard let bidPrice = Float(offer) else {
            isError = true
            return
        }
        if (bidPrice < Float(item.price)) {
            isError = true
            return
        }
        
        // Store new bid in Firebase.
        let newBid = Bid(
            _id: bidId,
            itemId: item.id,
            bidderId: myId,
            offer: offer,
            timestamp: Date()
        )
        do {
            try db.collection("bids").document(newBid.id).setData(from: newBid)
        } catch {
            print ("Error adding bid to Firestore: \(error)")
            isError = true
            return
        }

        // Add to the buyer's bids and remove from their saved.
        db.collection("users").document(myId).updateData([
            "bids": FieldValue.arrayUnion([item.id]),
            "saved": FieldValue.arrayRemove([item.id])
        ]) { (error) in
            if let e = error {
                print("There was an issue saving data to Firestore, \(e).")
            } else {
                print("Successfully bid item.")
                return
            }
        }
        
        // Add user to the item's bid history.
        db.collection("items").document(item.id).updateData([
            "bidHistory.\(myId)": bidId,
        ]) { (error) in
            if let e = error {
                print("There was an issue saving data to Firestore, \(e).")
            } else {
                print("Successfully bid item.")
                return
            }
        }
        
        // Notify seller that bid was placed.
        NotificationsVM()
            .sendItemNotification(
                to: item.sellerId,
                type: "Bid Placed",
                itemName: item.title,
                price: newBid.offer
            )
    }
    
    func getBids(for itemId: String) {
        if bids.isEmpty {
            // Fetch all bids for the item.
            let bids = db.collection("bids")
                .whereField("itemId", isEqualTo: itemId)
            getBids(with: bids)
            
            // Order bids in chronological order.
            self.bids.sort {
                $0.timestamp < $1.timestamp
            }
        }
    }
    
    func getBids(with query: Query) {
        query.getDocuments() { querySnapshot, err in
            if let err = err {
                print("Error fetching bids: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    do {
                        // Convert each document into the Bid model.
                        try self.bids.append(document.data(as: Bid.self))
                    } catch {
                        print("Error decoding document into Bid: \(error)")
                    }
                }
            }
        }
    }
    
    func fetchLastBid(bidId: String) -> String {
        let profileRef = db.collection("bids").document(bidId)
        var offer = ""
        
        profileRef.getDocument(as: Bid.self) { result in
            switch result {
            case .success(let bid):
                offer = bid.offer
            case .failure(let error):
                print("Error decoding message: \(error)")
            }
        }
        return offer
    }
}
