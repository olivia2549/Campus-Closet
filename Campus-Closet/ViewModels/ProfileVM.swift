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
    @Published var user = User()
    
    func getProfileData() {
        let db = Firestore.firestore()
        let userID = Auth.auth().currentUser!.uid
        let profileRef = db.collection("users").document(userID)
        
        profileRef.getDocument { (document, error) in
            if let document = document, document.exists {
                guard document.get("name") == nil else { self.user.name = String(describing: document.get("name")!); return }
                guard document.get("venmo") == nil else { self.user.venmo = String(describing: document.get("venmo")!); return }
            } else {
                print("Error: Profile does not exist.")
            }
        }
    }
}
