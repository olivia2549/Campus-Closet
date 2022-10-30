//
//  ItemVM.swift
//  Campus-Closet
//
//  Created by Hilly Yehoshua on 10/30/22.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

@MainActor class ItemVM: ObservableObject {
    @Published var items = [ItemModel]()
    private var db = Firestore.firestore()
    func fetchData(){
        db.collection("items").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else{
                print ("No Documents")
                return
            }
            self.items = documents.map { (queryDocumentSnapshot) -> ItemModel in
                let data = queryDocumentSnapshot.data()
                let id = data["_id"] as? String ?? ""
                let title = data["title"]  as? String ?? ""
                let description = data["description"]  as? String ?? ""
                let sellerId = data["sellerId"]  as? String ?? ""
                let price = data["price"] as? String ?? ""
                let size = data["size"]   as? String ?? ""
                let biddingEnabled = data["biddingEnabled"] as? Bool ?? (0 != 0)
                let tags = data["tags"] as? [String] ?? [""]
                let condition = data["condition"]  as? String ?? ""
                
                let itemModel = ItemModel(id: id, title: title, description: description, sellerId: sellerId, price: price, size: size, biddingEnabled: biddingEnabled, tags: tags, condition: condition)
                
                return itemModel
            }
            
        }
    }
    
}



//
//@MainActor class OnboardingVM: ObservableObject {
//    @Published var isError: Bool = false
//    @Published var message: String = ""
//    @Published var email: String = ""
//    @Published var password: String = ""
//    @Published var user: User = User()
//
//    func verifyAndLogin() { if verify() {logIn()} }
//
//    func verifyAndSignup() { if verify() {signUp()} }
//
//    func verify() -> Bool {
//        if email.isEmpty || password.isEmpty {
//            isError.toggle()
//            message = "Please enter your email and password."
//            return false
//        }
//        else if String(email.suffix(14)).caseInsensitiveCompare("@vanderbilt.edu") == .orderedSame {
//            isError.toggle()
//            message = "Please enter your Vanderbilt email."
//            return false
//        }
//        return true
//    }
//
//    func logIn() {
//        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
//            if error != nil {
//                return self.handleError(error: error!)
//            }
//            else if (Auth.auth().currentUser?.isEmailVerified == false) {
//                self.isError.toggle()
//                self.message = "Please verify your email address to continue."
//            }
//            else {
//                if let window = UIApplication.shared.windows.first {
//                    window.rootViewController = UIHostingController(rootView: ContentView())
//                    window.makeKeyAndVisible()
//                }
//            }
//        }
//    }
//
//    func signUp() {
//        let db = Firestore.firestore()
//        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
//            if error != nil {
//                return self.handleError(error: error!)
//            }
//
//            Auth.auth().currentUser?.sendEmailVerification()
//            if let window = UIApplication.shared.windows.first {
//                window.rootViewController = UIHostingController(rootView: VerifyEmailView())
//                window.makeKeyAndVisible()
//            }
//
//            if let curUser = Auth.auth().currentUser {
//                if let email = curUser.email {
//                    let id = curUser.uid
//                    db.collection("users").document(id).setData([
//                        "email": email,
//                    ]) { (error) in
//                        if let e = error {
//                            print("There was an issue saving data to Firestore, \(e).")
//                        } else {
//                            print("Successfully saved data.")
//                        }
//                    }
//                }
//            }
//        }
//    }
//
//    func choosePicture(chosenPicture: Binding<UIImage?>, pickerShowing: Binding<Bool>) -> some UIViewControllerRepresentable {
//        return PicturePicker(chosenPicture: chosenPicture, pickerShowing: pickerShowing)
//    }
//
//    func uploadPicture(chosenPicture: UIImage?) -> String {
//        if chosenPicture == nil {
//            return user.picture
//        }
//
//        let storageRef = Storage.storage().reference()
//        let pictureData = chosenPicture!.pngData()
//        var picturePath: String = "user-pictures/\(UUID().uuidString).png"
//
//        if pictureData != nil {
//            let pictureRef = storageRef.child(picturePath)
//
//            let upload = pictureRef.putData(pictureData!, metadata: nil) { metadata, error in
//                if error != nil || metadata == nil {
//                    picturePath = ""
//                }
//            }
//        }
//
//        return picturePath
//    }
//
//    func updateUser(chosenPicture: UIImage?) {
//        let newPicturePath = uploadPicture(chosenPicture: chosenPicture)
//
//        let db = Firestore.firestore()
//        if let userId = Auth.auth().currentUser?.uid {
//            print("id: \(userId)")
//            db.collection("users").document(userId).setData([
//                "name": user.name,
//                "picture": newPicturePath,
//                "venmo": user.venmo
//            ], merge: true) { err in
//                if let error = err {
//                    print("There was an issue saving data to Firestore, \(error).")
//                } else {
//                    print("Successfully saved data.")
//                }
//            }
//        }
//    }
//
//    func deleteAccount() {
//        let user = Auth.auth().currentUser
//
//        user?.delete { error in
//          if let error = error {
//            print("error \(error)")
//          } else {
//            print("successfully deleted.")
//          }
//        }
//    }
//
//    func handleError(error: Error) {
//        let authError = AuthErrorCode.Code.init(rawValue: error._code)
//        isError.toggle()
//
//        switch authError {
//        case .invalidEmail:
//            message = "Please enter a valid email address."
//        case .wrongPassword:
//            message = "That password is incorrect."
//        case .userNotFound:
//            message = "User not found. Please sign up!"
//        case .emailAlreadyInUse:
//            message = "That email is already in use. Please log in!"
//        default:
//            message = "Oops! An unexpected error occurred."
//        }
//    }
//
//}
