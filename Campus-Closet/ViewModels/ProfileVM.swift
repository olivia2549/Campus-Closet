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
    @Published var sortedColumns: [[String]] = []
    @Published var viewingMode: ViewingMode = ViewingMode.buyer
    @Published var position: Position = Position.first
    
    let db = Firestore.firestore()
    let maxHeight = UIScreen.main.bounds.height / 2.5
    
    func getProfileData() -> User {
        return fetchUser(userID: Auth.auth().currentUser!.uid)
    }
    
    func fetchUser(userID: String) -> User {
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
        return self.user
    }
    
    func fetchItems() {
        var data: [String] = []
        self.sortedColumns = []
        var itemIdsCol1: [String] = []
        var itemIdsCol2: [String] = []
        var col1 = true
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
        // sort data into 2 columns
        if data.count == 0 {
            return
        }
        data.forEach({ item in
            col1 ? itemIdsCol1.append(item) :
                itemIdsCol2.append(item)
            col1.toggle()
        })
        self.sortedColumns.append(itemIdsCol1)
        self.sortedColumns.append(itemIdsCol2)
    }
    
    // move item from listings to sold
    func sellItem(with id: String) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        db.collection("users").document(userID).updateData([
            "listings": FieldValue.arrayRemove([id]),
            "sold": FieldValue.arrayUnion([id])
        ]) { (error) in
            if let e = error {
                print("There was an issue saving data to Firestore, \(e).")
            } else {
                print("Successfully moved item from listings to sold.")
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
        let pictureData = chosenPicture!.jpegData(compressionQuality: 0)
        var picturePath: String = "user-pictures/\(UUID().uuidString).jpeg"
        
        if pictureData != nil {
            let pictureRef = storageRef.child(picturePath)
            let _ = pictureRef.putData(pictureData!, metadata: nil) { metadata, error in
                if error != nil || metadata == nil {
                    picturePath = ""
                }
            }
        }
        
        return picturePath
    }
        
    func updateUser(chosenPicture: UIImage?) {
        getPictureReference()

        func getPictureReference() {
            updateUser(){
                Storage.storage().reference(withPath: self.user.picture).getData(maxSize: 60 * 1024 * 1024) { (data, error) in
                    if let err = error {
                        print(err)
                    } else if data != nil {
                        if let picture = UIImage(data: data!) {
                            self.profilePicture = picture
                        }
                    }
                }
            }
        }

        func updateUser(completion: @escaping () -> Void) {
            uploadNewPicture() {
                let db = Firestore.firestore()
                if let userId = Auth.auth().currentUser?.uid {
                    db.collection("users").document(userId).setData([
                        "name": self.user.name,
                        "picture": self.user.picture,
                        "venmo": self.user.venmo
                    ], merge: true) { err in
                        if let error = err {
                            print("There was an issue saving data to Firestore, \(error).")
                        } else {
                            print("Successfully saved data.")
                            completion()
                        }
                    }
                }
            }
        }
        
        func uploadNewPicture(completion: @escaping () -> Void) {
            if chosenPicture == nil {
                completion()
                return
            }
            
            let storageRef = Storage.storage().reference()
            let pictureData = chosenPicture!.jpegData(compressionQuality: 0)
            var picturePath: String = "user-pictures/\(UUID().uuidString).jpeg"

            if pictureData != nil {
                let pictureRef = storageRef.child(picturePath)
                let _ = pictureRef.putData(pictureData!, metadata: nil) { metadata, error in
                    if error != nil || metadata == nil {
                        picturePath = ""
                    }
                    else {
                        self.user.picture = picturePath
                        completion()
                    }
                }
            }
        }
    }
}
