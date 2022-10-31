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

@MainActor class ProfileVM: ObservableObject {
    @Published var user = User()
    @Published var profilePicture: UIImage?
    @Published var listingsPictures = [UIImage]()
    
    func getProfileData() {
        let db = Firestore.firestore()
        let userID = Auth.auth().currentUser!.uid
        let profileRef = db.collection("users").document(userID)
        
        profileRef.getDocument { (document, error) in
            if let document = document, document.exists {
                if document.get("name") != nil {
                    self.user.name = String(describing: document.get("name")!)
                }
                
                if document.get("venmo") != nil {
                    self.user.venmo = String(describing: document.get("venmo")!)
                }
                
                if document.get("picture") != nil {
                    self.user.picture = String(describing: document.get("picture")!)
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
                }
                
                if document.get("listings") != nil {
                    let listingIDs = document.get("listings") as? [String]
                    
                    listingIDs!.forEach {
                        db.collection("items").document($0).getDocument { (document, error) in
                            if let document = document, document.exists {
                                if document.get("picture") != nil {
                                    let pictureRef = Storage.storage().reference(withPath: String(describing: document.get("picture")!))

                                    // Download item picture with max size of 30MB.
                                    pictureRef.getData(maxSize: 30 * 1024 * 1024) { (data, error) in
                                        if let err = error {
                                            print(err)
                                        } else if data != nil {
                                            if let picture = UIImage(data: data!) {
                                                self.listingsPictures.append(picture)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
            } else {
                print("Error: Profile does not exist.")
            }
        }
    }
}
