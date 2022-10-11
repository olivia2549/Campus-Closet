//
//  SignUpView.swift
//  Campus-Closet
//
//  Created by Lauren on 10/10/22.
//

import SwiftUI
import Firebase

struct SignUpView: View {
    @State private var isError: Bool = false
    @State private var message: String = ""
    
    var body: some View {
        ZStack (alignment: .center) {
            NavigationView {
                VStack(spacing: 0) {
                    Logo()
                    Title()
                    SignUpFormBox(isError: $isError, message: $message)
                }
                .padding(.all, 20)
                .navigationTitle("")
                .navigationBarHidden(true)
            }
            .statusBar(hidden: true)
            MessageView(showMessage: $isError, message: message)
        }
    }
}

struct Title: View {
    var body: some View {
        VStack (alignment: .leading, spacing: 16){
            Text("Create Your Account")
                .font(.system(size: 26)).bold()
        }
        .padding(.all, 6)
        .foregroundColor(Color("Dark Pink"))
        .offset(y: -160)
    }
}

struct SignUpFormBox: View {
    @State var email: String = ""
    @State var password: String = ""
    @Binding var isError: Bool
    @Binding var message: String
    
    var body: some View{
        VStack (alignment: .leading, spacing: 16){
            Text("Email")
                .font(.callout).bold()
            TextField("email", text: $email)
                .autocapitalization(.none)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Text("Create a Password")
                .font(.callout).bold()
            SecureField("password", text: $password)
                .autocapitalization(.none)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button(action: {verifyCredentials()}){
                HStack{
                    Text("Sign Up")
                        .frame(maxWidth: .infinity, alignment: .center)
                    Spacer()
                }
            }
            .padding(10)
            .background(Color("Dark Pink"))
            .cornerRadius(10)
            .foregroundColor(Color.white)
        }
        .padding (.all, 36)
        .background(Color(UIColor.systemGray6))
        .cornerRadius (20)
        .offset(y: -140)
    }
    
    func verifyCredentials() {
        if email.isEmpty || password.isEmpty {
            isError.toggle()
            message = "Please enter your email and password."
        }
        else if !email.hasSuffix("@vanderbilt.edu") {
            isError.toggle()
            message = "Please enter your Vanderbilt email."
        }
        else {
            signUp()
        }
    }
    
    func signUp() {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if error != nil {
                return self.handleError(error: error!)
            }
            print("Welcome to the Campus Closet!")
        }
    }
    
    func handleError(error: Error) {
        let authError = AuthErrorCode.Code.init(rawValue: error._code)
        isError.toggle()
        
        switch authError {
        case .invalidEmail:
            message = "Please enter a valid email address."
        case .emailAlreadyInUse:
            message = "This email is already in use."
        default:
            message = "Oops! An unexpected error occurred."
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
