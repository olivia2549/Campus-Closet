//
//  MessageModel.swift
//  Campus-Closet
//
//  Created by Hilly Yehoshua on 10/23/22.
//

import Foundation

// Structure representing a message exchanged between two users.
struct Message: Identifiable, Codable {
    var id: String
    var text: String
    var sender: String // ID of the user who sent the message.
    var recipient: String // ID of the user who received the message.
    var received: Bool
    var timestamp: Date
}
