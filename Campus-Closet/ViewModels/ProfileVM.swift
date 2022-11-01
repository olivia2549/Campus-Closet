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

@MainActor class ProfileVM: ObservableObject, RenderContentVM {
    @Published var user = User()
    @Published var numRatings = 0
    @Published var averageRating = 0.0
    @Published var profilePicture: UIImage?
    @Published var sortedColumns: [[String]] = []
    let db = Firestore.firestore()
    let maxHeight = UIScreen.main.bounds.height / 2.5
    
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
                self.sortedColumns = []
                var itemIdsCol1: [String] = []
                var itemIdsCol2: [String] = []
                var col1 = true
                user.listings?.forEach({ listing in
                    col1 ? itemIdsCol1.append(listing) :
                        itemIdsCol2.append(listing)
                    col1.toggle()
                })
                self.sortedColumns.append(itemIdsCol1)
                self.sortedColumns.append(itemIdsCol2)
            case .failure(let error):
                print("Error decoding user: \(error)")
            }
        }
    }
    
    func choosePicture(chosenPicture: Binding<UIImage?>, pickerShowing: Binding<Bool>) -> some UIViewControllerRepresentable {
        return PicturePicker(chosenPicture: chosenPicture, pickerShowing: pickerShowing)
    }
    
    func uploadPicture(chosenPicture: UIImage?) -> String {
        if chosenPicture == nil {
            return user.picture
        }
        
        let storageRef = Storage.storage().reference()
        let pictureData = chosenPicture!.pngData()
        var picturePath: String = "user-pictures/\(UUID().uuidString).png"
        
        if pictureData != nil {
            let pictureRef = storageRef.child(picturePath)
            
            let upload = pictureRef.putData(pictureData!, metadata: nil) { metadata, error in
                if error != nil || metadata == nil {
                    picturePath = ""
                }
            }
        }
        
        return picturePath
    }
    
    func updateUser(chosenPicture: UIImage?) {
        let newPicturePath = uploadPicture(chosenPicture: chosenPicture)
        
        let db = Firestore.firestore()
        if let userId = Auth.auth().currentUser?.uid {
            print("id: \(userId)")
            db.collection("users").document(userId).setData([
                "name": user.name,
                "picture": newPicturePath,
                "venmo": user.venmo
            ], merge: true) { err in
                if let error = err {
                    print("There was an issue saving data to Firestore, \(error).")
                } else {
                    print("Successfully saved data.")
                }
            }
        }
    }
    
}
