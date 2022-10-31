//
//  ItemModel.swift
//  Campus-Closet
//
//  Created by Olivia Logan on 10/21/22.
//

import Foundation

struct Item: Codable {
    var _id: String = UUID().uuidString
    var title: String = ""
    var picture: String = ""
    var description: String = ""
    var sellerId: String = ""
    var price: String = ""
    var size: String = ""
    var biddingEnabled: Bool = true
    var tags: [String]? = []
    var condition: String? = ""
}

extension Item: Identifiable {
    var id: String { _id }
}
