//
//  ProfileVM.swift
//  Campus-Closet
//
//  Created by Lauren Scott on 10/22/22.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

@MainActor class ProfileVM: ObservableObject {
    func getProfile() {
        let userID = Auth.auth().currentUser!.uid
        print("userID is: \(userID)")
    }
}
