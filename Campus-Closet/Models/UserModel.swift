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
    var listings: [String]? = []   // ids of items
}
