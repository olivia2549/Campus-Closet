//
//  NotificationsVM.swift
//  Campus-Closet
//
//  Created by Olivia Logan on 12/4/22.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

class NotificationsVM: ObservableObject {
    let db = Firestore.firestore()
    var itemName: String
    var price: String

    init(itemName: String, price: String) {
        self.itemName = itemName
        self.price = price
    }
    
    // Send push notification
    func sendNotification(to userId: String, type: String) {
        let messageBody = generateBody(type: type)
        db.collection("users").document(userId).getDocument(as: User.self) { result in
            switch result {
            case .success(let user):
                self.makeRequest(to: user.token, messageBody: messageBody)
            case .failure(let error):
                print("Error decoding user: \(error)")
            }
        }
    }
    
    private func makeRequest(to token: String, messageBody: [String:String]) {
        let body: [String: Any] = [
            "to": token,
            "notification": messageBody,
            "data": ["dummy":"dummyValue"]
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: body, options: [.prettyPrinted])
        let url = URL(string: "https://fcm.googleapis.com/fcm/send")!
        let serverKey = "AAAA_IxReKc:APA91bEq-CiQa_N6FrcdR5N0BnYXK5TLGzQ9WKcPCY8YDgOgFVNoS7viBitcoHahfdMXPlb17ryx1t4P2vPtFXfocTauxYjRsTaE-Tpre6-mcXvxn60BQD66v1Vk5oIwWyBBVqA_YKtU"
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=\(serverKey)", forHTTPHeaderField: "Authorization")
        
        URLSession(configuration: .default).dataTask(with: request) { data, response, error in
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
                else {
                    print("no response")
                }
            }
        }
        .resume()
    }
    
    private func generateBody(type: String) -> [String:String] {
        var body: [String:String] = ["title": "\(type)", "body": ""]
        switch type {
        case "Bid Placed":
            body["body"] = "A bid of $\(price) has been placed on your item \"\(itemName)\"."
        case "Offer Accepted":
            body["body"] = "Your offer of \(price) for the item \"\(itemName)\" has been accepted."
        case "Offer Removed":
            body["body"] = "A bid has been removed from your item \"\(itemName)\"."
        case "Item Sold":
            body["body"] = "The item \"\(itemName)\" has been sold to another bidder."
        default:
            body["body"] = ""
        }
        return body
    }

}
