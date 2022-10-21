//
//  SignUpView.swift
//  Campus-Closet
//
//  Created by Lauren on 10/10/22.
//

import SwiftUI
import Firebase

struct SignUpView: View {
    @StateObject private var signupVM = OnboardingVM()
    
    var body: some View {
        ZStack (alignment: .center) {
            NavigationView {
                VStack(spacing: 0) {
                    Logo()
                    Title()
                    SignUpFormBox()
                }
                .padding(.all, 20)
                .navigationTitle("")
                .navigationBarHidden(true)
            }
            .statusBar(hidden: true)
            MessageView()
        }
        .environmentObject(signupVM)
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
    @EnvironmentObject private var viewModel: OnboardingVM
    
    var body: some View{
        VStack (alignment: .leading, spacing: 16){
            Text("Email")
                .font(.callout).bold()
            TextField("email", text: $viewModel.email)
                .autocapitalization(.none)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Text("Create a Password")
                .font(.callout).bold()
            SecureField("password", text: $viewModel.password)
                .autocapitalization(.none)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            NavigationLink(destination: VerifyEmailView(), tag: 1, selection: $viewModel.selection) { EmptyView() }
            Button(action: {viewModel.verifyAndSignup()}){
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

}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
