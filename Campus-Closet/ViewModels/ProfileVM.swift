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
    @Published var name = ""
    @Published var venmo = ""
    @Published var rating = ""
    
    func getProfileData() {
        let db = Firestore.firestore()
        let userID = Auth.auth().currentUser!.uid
        let profileRef = db.collection("users").document(userID)
        
        profileRef.getDocument { (document, error) in
            if let document = document, document.exists {
                guard document.get("name") == nil else { self.name = String(describing: document.get("name")!); return }
                guard document.get("venmo") == nil else { self.venmo = String(describing: document.get("venmo")!); return }
                guard document.get("rating") == nil else { self.rating = String(describing: document.get("rating")!); return }
            } else {
                print("Error: Profile does not exist.")
            }
        }
    }
}
