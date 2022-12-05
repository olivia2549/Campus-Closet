//
//  OnboardingVM.swift
//  Campus-Closet
//
//  Created by Olivia Logan on 10/21/22.
//

import Foundation
import Combine
import SwiftUI
import Firebase
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

@MainActor class OnboardingVM: ObservableObject {
    @Published var isError: Bool = false
    @Published var isEmailSent: Bool = false
    @Published var message: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var currentUser: User = User()
    @Published var isLoggedIn = false
    @Published var isGuest = false

    var handle: AuthStateDidChangeListenerHandle?
    let db = Firestore.firestore()
    
    func listenAuthenticationState() {
        handle = Auth.auth().addStateDidChangeListener({ [weak self] (auth, user) in
            if let user = user {
                let userRef = self!.db.collection("users").document(user.uid)
                userRef.getDocument(as: User.self) { result in
                    switch result {
                    case .success(let currentUser):
                        self!.currentUser = currentUser
                    case .failure(let error):
                        print("Error decoding user: \(error)")
                    }
                }
                self!.isLoggedIn = true
                self!.isGuest = user.uid == "iR0c0aZXPoRsw5DN3cpmf9mzUEK2"
                print("logged in, isGuest: \(self?.isGuest)")
            } else {
                self!.isLoggedIn = false
                self?.isGuest = false
                print("not logged in, isGuest: \(self?.isGuest)")
            }
        })
    }
    
    func logOut() {
        do {
            try Auth.auth().signOut()
            self.isLoggedIn = false
        } catch let error {
            debugPrint(error.localizedDescription)
        }
    }
    
    func verifyAndLogin() { if verify(withPassword: true) {logIn()} }
    
    func verifyAndSignup() { if verify(withPassword: true) {signUp()} }
    
    func verifyAndResetPassword() { if verify(withPassword: false) {resetPassword()} }
    
    func verify(withPassword: Bool) -> Bool {
        if email.isEmpty || (withPassword && password.isEmpty) {
            isError.toggle()
            message = "Please submit your credentials."
            return false
        }
        else if !email.lowercased().hasSuffix("@vanderbilt.edu") && email != "admin@campuscloset.com" {
            isError.toggle()
            message = "Please enter your Vanderbilt email."
            return false
        }
        return true
    }
    
    func logIn() {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                return self.handleError(error: error!)
            }
            else if (Auth.auth().currentUser?.isEmailVerified == false && self.email != "admin@campuscloset.com") { // User has not verified account via email.
                self.isError.toggle()
                self.message = "Please verify your email address to continue."
            }
        }
    }
    
    func guestLogIn() {
        Auth.auth().signIn(withEmail: "guest@campuscloset.com", password: "GuestAccount123!") { (result, error) in
            if error != nil {
                return self.handleError(error: error!)
            }
        }
    }
    
    func signUp() {
        let db = Firestore.firestore()
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if error != nil {
                return self.handleError(error: error!)
            }
            
            // Send email to user for account verification.
            Auth.auth().currentUser?.sendEmailVerification()
            if let window = UIApplication.shared.windows.first {
                window.rootViewController = UIHostingController(rootView: VerifyEmailView())
                window.makeKeyAndVisible()
            }
            
            // Create new database entry for the user.
            if let curUser = Auth.auth().currentUser {
                if let email = curUser.email {
                    let id = curUser.uid
                    let user = User(_id: curUser.uid, email: email)
                    do {
                        try db.collection("users").document(id).setData(from: user)
                        print("Successfully saved data.")
                    } catch let error {
                        print("There was an issue saving data to Firestore, \(error).")
                    }
                }
            }
        }
    }
    
    func resetPassword() {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                print("Error in sending password reset email \(error)")
                return
            } else {
                self.isEmailSent = true
                print("Password reset email successfully sent.")
            }
        }
    }
    
    func deleteAccount() {
        // Delete user account, bid, message, and item data from database.
        deleteAccountData() {
            // Delete the user account.
            if let user = Auth.auth().currentUser {
                user.delete { error in
                    if let error = error {
                        print("Error in deleting user account \(error)")
                        return
                    } else {
                        print("User account successfully deleted.")
                    }
                }
            }
            
            // Return deleted user to login screen.
            self.isLoggedIn = false
        }
    }
    
    func deleteAccountData(completion: @escaping () -> Void) {
        deleteBids() {
            self.deleteMessages() {
                self.deleteItems() {
                    // Delete account data for this user from the database.
                    self.db.collection("users").document(Auth.auth().currentUser!.uid).delete() { error in
                        if let error = error {
                            print("Error in deleting user \(error)")
                        } else {
                            print("User successfully deleted.")
                            completion()
                        }
                    }
                }
            }
        }
    }
    
    func deleteBids(completion: @escaping () -> Void) {
        updateBidHistories() {
            let userId = Auth.auth().currentUser!.uid
            
            // Remove all bids placed by this user from the database.
            self.db.collection("users").document(userId).getDocument { document, error in
                if let document = document, document.exists {
                    // Get IDs of all items this user has placed a bid on.
                    let placedBids = document.get("bids") as! [String]
                    
                    for bid in placedBids {
                        self.db.collection("bids").document(bid).delete() { error in
                            if let error = error {
                                print("Error in deleting item \(error)")
                            } else {
                                print("Bid successfully deleted.")
                            }
                        }
                    }
                    completion()
                } else {
                    print("Document does not exist")
                }
            }
        }
    }

    func updateBidHistories(completion: @escaping () -> Void) {
        let userId = Auth.auth().currentUser!.uid
        
        db.collection("users").document(userId).getDocument { document, error in
            if let document = document, document.exists {
                // Get IDs of all items this user has placed a bid on.
                let placedBids = document.get("bids") as! [String]
                
                for bid in placedBids {
                    // Remove this user's bid from the item's bid history.
                    self.db.collection("items").document(bid).updateData([
                        "bidHistory.\(userId)": FieldValue.delete()
                    ]) { error in
                        if let e = error {
                            print("There was an issue deleting the bid, \(e)")
                        } else {
                            print("Successfully deleted from bid history.")
                        }
                    }
                }
                
                // All bids placed by user have been removed from item bid histories.
                completion()
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func deleteMessages(completion: @escaping () -> Void) {
        updateMessageHistories() {
            let userId = Auth.auth().currentUser!.uid
            
            self.db.collection("Messages").whereField("sender", isEqualTo: userId).getDocuments() { querySnapshot, err in
                if let err = err {
                    print("Error getting messages: \(err)")
                } else {
                    for message in querySnapshot!.documents {
                        message.reference.delete()
                    }
                }
            }
            
            self.db.collection("Messages").whereField("recipient", isEqualTo: userId).getDocuments() { querySnapshot, err in
                if let err = err {
                    print("Error getting messages: \(err)")
                } else {
                    for message in querySnapshot!.documents {
                        message.reference.delete()
                    }
                }
            }
            
            completion()
        }
    }
    
    func updateMessageHistories(completion: @escaping () -> Void) {
        let userId = Auth.auth().currentUser!.uid
        
        db.collection("users").document(userId).getDocument { document, error in
            if let document = document, document.exists {
                let messageHistory = document.get("messageHistory") as! [String:String]
                
                for user in messageHistory.keys {
                    self.db.collection("users").document(user).updateData([
                        "messageHistory.\(userId)": FieldValue.delete()
                    ]) { error in
                        if let e = error {
                            print("There was an issue deleting the conversation, \(e)")
                        } else {
                            print("Successfully deleted from message history.")
                        }
                    }
                }
                completion()
            } else {
                print("Couldn't find data to delete.")
            }
        }
    }
    
    func deleteItems(completion: @escaping () -> Void) {
        updateItemBids() {
            let userId = Auth.auth().currentUser!.uid
            
            self.db.collection("items").whereField("sellerId", isEqualTo: userId).getDocuments() { querySnapshot, err in
                if let err = err {
                    print("Error getting messages: \(err)")
                } else {
                    for item in querySnapshot!.documents {
                        item.reference.delete()
                    }
                    completion()
                }
            }
        }
    }

    func updateItemBids(completion: @escaping () -> Void) {
        updateItemReferences() {
            let userId = Auth.auth().currentUser!.uid
            
            self.db.collection("items").whereField("sellerId", isEqualTo: userId).getDocuments() { querySnapshot, err in
                if let err = err {
                    print("Error getting messages: \(err)")
                } else {
                    for item in querySnapshot!.documents {
                        let placedBids = item.get("bids") == nil ? [] : item.get("bids") as! [String]
                        
                        for bid in placedBids {
                            self.db.collection("users").whereField("bids", arrayContains: bid).getDocuments() { querySnapshot, err in
                                if err != nil {
                                    print("Error clearing bid history for item to delete.")
                                } else {
                                    for item in querySnapshot!.documents {
                                        item.reference.updateData([
                                            "bids": FieldValue.arrayRemove([bid])
                                        ])
                                    }
                                }
                            }
                            
                            self.db.collection("bids").document(bid).delete() { error in
                                if let e = error {
                                    print("There was an issue deleting the item, \(e)")
                                } else {
                                    print("Successfully deleted from items.")
                                }
                            }
                        }
                        
                        completion()
                    }
                }
            }
        }
    }
    
    func updateItemReferences(completion: @escaping () -> Void) {
        let userId = Auth.auth().currentUser!.uid
            
        self.db.collection("users").document(userId).getDocument { document, error in
            if let document = document, document.exists {
                let listedItems = document.get("listings") as! [String]
                    
                self.db.collection("users").whereField("saved", arrayContainsAny: listedItems).getDocuments() { querySnapshot, err in
                    if let err = err {
                        print("Error getting saved items: \(err)")
                    } else {
                        for item in querySnapshot!.documents {
                            item.reference.updateData([
                                "saved": FieldValue.arrayRemove(listedItems)
                            ])
                        }
                        completion()
                    }
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func handleError(error: Error) {
        let authError = AuthErrorCode.Code.init(rawValue: error._code)
        isError.toggle()
        
        switch authError {
        case .invalidEmail:
            message = "Please enter a valid email address."
        case .wrongPassword:
            message = "That password is incorrect."
        case .userNotFound:
            message = "User not found. Please sign up!"
        case .emailAlreadyInUse:
            message = "That email is already in use. Please log in!"
        default:
            message = "Oops! An unexpected error occurred."
        }
    }

}
