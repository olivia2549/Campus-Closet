//
//  UserModel.swift
//  Campus-Closet
//
//  Created by Lauren Scott on 10/3/22.
//

import Foundation

struct User: Codable {
    var name: String = ""
    var picture: String = ""
    var venmo: String = ""
    var saved: [String] = []       // IDs of items saved by user (buyer)
    var bids: [String] = []        // IDs of items bid by user (buyer)
    var listings: [String] = []    // IDs of items listed by user (seller)
    var sold: [String] = []        // IDs of items sold by user (seller)
    var ratings: [Int] = []
    var isSeller: Bool = false
    var token: String = ""
}
