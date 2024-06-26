//
//  UserModel.swift
//  Campus-Closet
//
//  Created by Lauren Scott on 10/3/22.
//

import Foundation

// Structure representing a user stored in the database.
struct User: Codable {
    var _id: String = UUID().uuidString
    var email: String = ""
    var name: String = ""
    var picture: String = ""
    var venmo: String = ""
    var saved: [String] = [] // IDs of items saved by the user (buyer)
    var bids: [String] = [] // IDs of items bid by the user (buyer)
    var listings: [String] = [] // IDs of items listed by the user (seller)
    var sold: [String] = [] // IDs of items sold by the user (seller)
    var ratings: [Int] = []
    var token: String = ""
    var messageHistory: [String: String] = [:]
}

extension User: Identifiable {
    var id: String { _id }
}
