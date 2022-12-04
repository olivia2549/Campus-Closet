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

class BidsVM: ObservableObject {
    let db = Firestore.firestore()
    @Published private(set) var bids: [Bid] = []
    
    func placeBid(itemId: String, offer: String) {
        guard let myId = Auth.auth().currentUser?.uid else {return}
        let bidId = "\(UUID())"

        // TODO: validate that bidPrice is greater than previous bid price
        // guard let bidPrice = Int(offer) else {return}
        
        // Store new bid in firebase
        do {
            let newBid = Bid(
                _id: bidId,
                itemId: itemId,
                bidderId: myId,
                offer: offer,
                timestamp: Date()
            )
            try db.collection("bids").document(newBid.id).setData(from: newBid)
        } catch {
            print ("Error adding bid to Firestore: \(error)")
        }

        // Add to the buyer's bids and remove from their saved
        db.collection("users").document(myId).updateData([
            "bids": FieldValue.arrayUnion([itemId]),
            "saved": FieldValue.arrayRemove([itemId])
        ]) { (error) in
            if let e = error {
                print("There was an issue saving data to Firestore, \(e).")
            } else {
                print("Successfully bid item.")
                // TODO: Send notification to seller
                self.sendNotification(userId: myId)
            }
        }
        
        // Add user to the item's bid history
        db.collection("items").document(itemId).updateData([
            "bidHistory.\(myId)": bidId,
        ]) { (error) in
            if let e = error {
                print("There was an issue saving data to Firestore, \(e).")
            } else {
                print("Successfully bid item.")
                // TODO: Send notification to seller
            }
        }
                
    }
    
    func getBids(for itemId: String) {
        // Fetch all bids for the item.
        let bids = db.collection("bids")
            .whereField("itemId", isEqualTo: itemId)
        getBids(with: bids)
        
        // Order bids in chronological order.
        self.bids.sort {
            $0.timestamp < $1.timestamp
        }
    }
    
    func getBids(with query: Query) {
        query.getDocuments() { querySnapshot, err in
            if let err = err {
                print("Error fetching bids: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    do {
                        // Convert each document into the Message model.
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
    
    // TODO: not yet fully implemented
    func sendNotification(userId: String) {
        db.collection("users").document(userId).getDocument(as: User.self) { result in
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
