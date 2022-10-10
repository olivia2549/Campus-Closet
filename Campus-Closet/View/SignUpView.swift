//
//  SignUpView.swift
//  Campus-Closet
//
//  Created by Lauren on 10/10/22.
//

import SwiftUI
import Firebase

struct SignUpView: View {
    var body: some View {
        VStack(spacing: 0) {
            Logo()
            Title()
            SignUpFormBox()
        }
        .padding(.all, 20)
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
            
            Button(action: {print($email)}) {
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
            
            Button(action: {print($email)}){
                HStack{
                    Text("Return to Log In")
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
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
