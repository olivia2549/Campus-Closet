//
//  LogInView.swift
//  Campus-Closet
//
//  Created by Hilly Yehoshua on 10/6/22.
//

import SwiftUI
import Firebase

struct LogInView: View {
    @State private var isError: Bool = false
    @State private var message: String = ""

    var body: some View {
        ZStack (alignment: .center) {
            NavigationView {
                VStack(spacing: 0) {
                    Logo()
                    LogInFormBox(isError: $isError, message: $message)
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

struct Logo: View {
    var body: some View {
        Color ("LightGrey")
        Image("logo_grey")
            .resizable()
            .offset(y: -50)
            .background(Color("LightGrey"))
            .frame(width: 400, height:400)
    }
}

struct LogInFormBox: View {
    @State var email: String = ""
    @State var password: String = ""
    @State var selection: Int? = nil
    @Binding var isError: Bool
    @Binding var message: String
    
    var body: some View {
        VStack (alignment: .leading, spacing: 16) {
            Text("Email")
                .font(.callout).bold()
            TextField("email", text: $email)
                .autocapitalization(.none)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Text("Password")
                .font(.callout).bold()
            SecureField("password", text: $password)
                .autocapitalization(.none)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            NavigationLink(destination: ContentView(), tag: 1, selection: $selection) { EmptyView() }
            Button(action: {verifyCredentials()}){
                HStack{
                    Text("Log In")
                        .frame(maxWidth: .infinity, alignment: .center)
                    Spacer()
                }
            }
            .padding(10)
            .background(Color("Dark Pink"))
            .cornerRadius(10)
            .foregroundColor(Color.white)
            
            NavigationLink(destination: SignUpView(), tag: 2, selection: $selection) { EmptyView() }
            Button(action: {self.selection = 2}){
                HStack{
                    Text("Sign Up")
                        .underline()
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundColor(Color ("Dark Pink"))
                    Spacer()
                }
            }
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
            logIn()
        }
    }
    
    func logIn() {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                return self.handleError(error: error!)
            }
            else if (Auth.auth().currentUser?.isEmailVerified == false) {
                isError.toggle()
                message = "Please verify your email address to continue."
            }
            else {
                self.selection = 1
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

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LogInView()
        }
    }
}
