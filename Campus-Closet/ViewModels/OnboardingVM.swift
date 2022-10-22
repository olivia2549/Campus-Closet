//
//  OnboardingVM.swift
//  Campus-Closet
//
//  Created by Olivia Logan on 10/21/22.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

@MainActor class OnboardingVM: ObservableObject {
    @Published var isError: Bool = false
    @Published var message: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var fieldInput: String = ""
    
    func verifyAndLogin() { if verify() {logIn()} }
    
    func verifyAndSignup() { if verify() {signUp()} }

    func verify() -> Bool {
        if email.isEmpty || password.isEmpty {
            isError.toggle()
            message = "Please enter your email and password."
            return false
        }
        else if !email.hasSuffix("@vanderbilt.edu") {
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
            else if (Auth.auth().currentUser?.isEmailVerified == false) {
                self.isError.toggle()
                self.message = "Please verify your email address to continue."
            }
            else {
                if let window = UIApplication.shared.windows.first {
                    window.rootViewController = UIHostingController(rootView: ContentView())
                    window.makeKeyAndVisible()
                }
            }
        }
    }
    
    func signUp() {
        let db = Firestore.firestore()
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if error != nil {
                return self.handleError(error: error!)
            }
            
            Auth.auth().currentUser?.sendEmailVerification()
            if let window = UIApplication.shared.windows.first {
                window.rootViewController = UIHostingController(rootView: VerifyEmailView())
                window.makeKeyAndVisible()
            }
            
            if let email = Auth.auth().currentUser?.email {
                db.collection("users").addDocument(data: [
                    "email": email,
                ]) { (error) in
                    if let e = error {
                        print("There was an issue saving data to Firestore, \(e).")
                    } else {
                        print("Successfully saved data.")
                    }
                }
            }
        }
    }
    
    func updateUser(with inputType: String) {
        let db = Firestore.firestore()
        if let user = Auth.auth().currentUser {
            let uid = user.uid
            db.collection("users").document(uid).setData([
                inputType: fieldInput
            ], merge: true) { err in
                if let error = err {
                    print("There was an issue saving data to Firestore, \(error).")
                } else {
                    print("Successfully saved data.")
                }
            }
        }
    }
    
    func deleteAccount() {
        let user = Auth.auth().currentUser

        user?.delete { error in
          if let error = error {
            print("error \(error)")
          } else {
            print("successfully deleted.")
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
        default:
            message = "Oops! An unexpected error occurred."
        }
    }

}
