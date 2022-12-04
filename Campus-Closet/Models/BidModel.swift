//
//  BidModel.swift
//  Campus-Closet
//
//  Created by Olivia Logan on 11/22/22.
//

import Foundation

// Structure representing a bid placed on an item.
struct Bid: Codable {
    var _id: String = ""
    var itemId: String = ""
    var bidderId: String = ""
    var offer: String = ""
    var timestamp: Date = Date.now
}

extension Bid: Identifiable {
    var id: String { _id }
}
