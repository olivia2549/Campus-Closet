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

enum ViewingMode {
    case buyer, seller
}
enum Position: Int {
    case first = 0, second
}

@MainActor class ProfileVM: ObservableObject, RenderContentVM {
    @Published var user = User()
    @Published var numRatings = 0
    @Published var averageRating = 0.0
    @Published var profilePicture: UIImage?
    @Published var content: [String] = []
    @Published var viewingMode: ViewingMode = ViewingMode.buyer
    @Published var position: Position = Position.first
    
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
                self.numRatings = user.ratings.count
                self.averageRating = self.numRatings == 0 ? 0 : Double(user.ratings.reduce(0, +)) / Double(user.ratings.count)
                
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
                self.fetchItems()
            case .failure(let error):
                print("Error decoding user: \(error)")
            }
        }
    }
    
    func fetchItems() {
        var data: [String] = []
        self.content = []
        // figure out which data to display (based on the selected toggle combination)
        if (self.viewingMode == ViewingMode.buyer) {
            switch (self.position) {
            case .first:
                data = user.bids
            case .second:
                data = user.saved
            }
        } else {
            switch (self.position) {
            case .first:
                data = user.listings
            case .second:
                data = user.sold
            }
        }
        if data.count == 0 {
            return
        }
        self.content = data
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
