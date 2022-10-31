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
import FirebaseStorage
import FirebaseFirestoreSwift

@MainActor class ProfileVM: ObservableObject {
    @Published var user = User()
    @Published var profilePicture: UIImage?
    let db = Firestore.firestore()
    
    func getProfileData() {
        let userID = Auth.auth().currentUser!.uid
        let profileRef = db.collection("users").document(userID)
        
        profileRef.getDocument(as: User.self) { result in
            switch result {
            case .success(let user):
                print("User: \(user)")
                self.user = user
                let pictureRef = Storage.storage().reference(withPath: self.user.picture)
                // Download profile picture with max size of 30MB.
                pictureRef.getData(maxSize: 30 * 1024 * 1024) { (data, error) in
                    if let err = error {
                        print(err)
                    } else if data != nil {
                        if let picture = UIImage(data: data!) {
                            self.profilePicture = picture
                        }
                    }
                }
            case .failure(let error):
                print("Error decoding user: \(error)")
            }
        }
    }
    
}
