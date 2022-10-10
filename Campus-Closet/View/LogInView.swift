//
//  LogInView.swift
//  Campus-Closet
//
//  Created by Hilly Yehoshua on 10/6/22.
//

import SwiftUI
import Firebase

struct LogInView: View {
    var body: some View {
        VStack(spacing: 0) {
            Logo()
            LogInFormBox()
        }
        .padding(.all, 20)
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
    
    var body: some View{
        VStack (alignment: .leading, spacing: 16){
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
            
            Button(action: {verifyCredentials()}) {
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
            
            Button(action: {print ($email)}){ // FIXME: Navigate to sign up screen.
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
        if self.email == "" || password == "" {
            print("Please enter your name and password.")
        }
        else if !email.hasSuffix("@vanderbilt.edu") {
            print("Please enter your Vanderbilt email address.")
        }
        else {
            print("Authenticate with Firebase.") // FIXME: Add Firebase logic.
        }
    }
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}
