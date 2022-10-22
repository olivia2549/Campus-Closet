//
//  ItemModel.swift
//  Campus-Closet
//
//  Created by Olivia Logan on 10/21/22.
//

import Foundation

struct ItemModel {
    var id: String = UUID().uuidString
    var title: String = ""
    var description: String = ""
    var sellerId: String = ""
    var price: String = ""
    var size: String = ""
    var biddingEnabled: Bool = true
    var tags: [String] = []
    var condition: String = ""
}
