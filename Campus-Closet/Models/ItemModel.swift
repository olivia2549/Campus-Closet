//
//  ItemModel.swift
//  Campus-Closet
//
//  Created by Olivia Logan on 10/21/22.
//

import Foundation
import FirebaseAuth

// Structure representing an item listed in the marketplace.
struct Item: Codable {
    var _id: String = UUID().uuidString
    var title: String = ""
    var picture: String = ""
    var description: String = ""
    var sellerId: String = Auth.auth().currentUser!.uid
    var isSold: Bool = false
    var price: Float = 0.0
    var size: String = ""
    var condition: String = ""
    var biddingEnabled: Bool = true
    var tags: [String]? = []
    var studentCreated: Bool = false
    var bidHistory: [String: String] = [:]
    var timestamp = Date.now
}

extension Item: Identifiable {
    var id: String { _id }
}
