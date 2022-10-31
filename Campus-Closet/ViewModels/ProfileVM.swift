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
    @Published var numRatings = 0
    @Published var averageRating = 0.0
    @Published var profilePicture: UIImage?
    let db = Firestore.firestore()
    
    func getProfileData() {
        fetchUser(userID: Auth.auth().currentUser!.uid)
    }
    
    func fetchUser(userID: String) {
        let profileRef = db.collection("users").document(userID)
        
        profileRef.getDocument(as: User.self) { result in
            switch result {
            case .success(let user):
                self.user = user
                self.numRatings = user.ratings!.count
                self.averageRating = user.ratings!.count == 0 ? 0 : Double(user.ratings!.reduce(0, +)) / Double(user.ratings!.count)
                
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
