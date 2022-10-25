//
//  Message.swift
//  Campus-Closet
//
//  Created by Hilly Yehoshua on 10/23/22.
//

import Foundation

struct Message: Identifiable, Codable{
    var id: String
    var text: String
    var received: Bool
    var timestamp: Date
}
