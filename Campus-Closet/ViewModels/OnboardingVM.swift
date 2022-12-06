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

// Class for a view model that manages user authentication and onboarding.
@MainActor class OnboardingVM: ObservableObject, ErrorVM {
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
    
    // Function to track if the user is logged in or a guest.
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
    
    // Function that logs a user out of their account.
    func logOut() {
        do {
            try Auth.auth().signOut()
            self.isLoggedIn = false
        } catch let error {
            debugPrint(error.localizedDescription)
        }
    }
    
    // Function that verifies credentials. If valid, logs in the user.
    func verifyAndLogin() { if verify(withPassword: true) {logIn()} }
    
    // Function that verifies credentials. If valid, signs up the user.
    func verifyAndSignup() { if verify(withPassword: true) {signUp()} }
    
    // Function that verifies user email. If valid, sends a password reset email.
    func verifyAndResetPassword() { if verify(withPassword: false) {resetPassword()} }
    
    // Validate input user vredentials.
    func verify(withPassword: Bool) -> Bool {
        if email.isEmpty || (withPassword && password.isEmpty) {
            // User did not enter both email and password.
            isError.toggle()
            message = "Please submit your credentials."
            return false
        }
        else if !email.lowercased().hasSuffix("@vanderbilt.edu") && email != "admin@campuscloset.com" {
            // User entered invalid email address.
            isError.toggle()
            message = "Please enter your Vanderbilt email."
            return false
        }
        
        // User entered valid credentials.
        return true
    }
    
    // Function that logs in a user.
    func logIn() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if error != nil {
                // Error occurred in login request.
                return self.handleError(error: error!)
            } else if (Auth.auth().currentUser?.isEmailVerified == false && self.email != "admin@campuscloset.com") {
                // User has not verified account via email.
                self.isError.toggle()
                self.message = "Please verify your email address to continue."
            }
        }
    }
    
    // Function that logs in a user as a guest with limited permissions.
    func guestLogIn() {
        Auth.auth().signIn(withEmail: "guest@campuscloset.com", password: "GuestAccount123!") { result, error in
            if error != nil {
                // Error occurred in guest login request.
                return self.handleError(error: error!)
            }
            // Guest login was successful.
        }
    }
    
    // Function that signs up a new user.
    func signUp() {
        let db = Firestore.firestore()
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if error != nil {
                // Error occurred in creating new user.
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
                        // Error in creating new Firestore entry for the user.
                        print("There was an issue saving data to Firestore, \(error).")
                    }
                }
            }
        }
    }
    
    // Function that sends a user a reset password email.
    func resetPassword() {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                // Error occurred in sending reset password email.
                print("Error in sending password reset email \(error)")
                return
            } else {
                // Reset password email sent to user.
                self.isEmailSent = true
                print("Password reset email successfully sent.")
            }
        }
    }
    
    // Function that handles credential errors and selects a descriptive error message.
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
