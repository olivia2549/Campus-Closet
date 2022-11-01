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
import FirebaseStorage

@MainActor class OnboardingVM: ObservableObject {
    @Published var isError: Bool = false
    @Published var message: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var user: User = User()
    
    func verifyAndLogin() { if verify() {logIn()} }
    
    func verifyAndSignup() { if verify() {signUp()} }

    func verify() -> Bool {
        if email.isEmpty || password.isEmpty {
            isError.toggle()
            message = "Please enter your email and password."
            return false
        }
        else if String(email.suffix(14)).caseInsensitiveCompare("@vanderbilt.edu") == .orderedSame {
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
            
            if let curUser = Auth.auth().currentUser {
                if let email = curUser.email {
                    let id = curUser.uid
                    db.collection("users").document(id).setData([
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
    }
    
    func deleteAccount() {
        if let user = Auth.auth().currentUser {
            user.delete { error in
              if let error = error {
                print("error \(error)")
              } else {
                print("successfully deleted.")
              }
            }
        }
                
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = UIHostingController(rootView: LogInView())
            window.makeKeyAndVisible()
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
