//
//  SignUpView.swift
//  Campus-Closet
//
//  Created by Lauren Scott on 10/10/22.
//

import SwiftUI
import Firebase

// Structure for the sign up screen.
struct SignUpView: View {
    @StateObject private var signupVM = OnboardingVM()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .center) {
                VStack(spacing: 0) {
                    LogoSignup(proxy: proxy)
                    Title(proxy: proxy)
                    SignUpFormBox(proxy: proxy)
                }
                .padding(20)
                ErrorView<OnboardingVM>()
            }
            .navigationBarBackButtonHidden(true)
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    Styles.BackButton(presentationMode: presentationMode)
                }
            })
            .onTapGesture { hideKeyboard() }
            .environmentObject(signupVM)
        }
    }
}

// Structure that contains the formatted VFW logo to display on the screen.
struct LogoSignup: View {
    var proxy: GeometryProxy
    
    var body: some View {
        Image("logo")
            .resizable()
            .offset(y: -proxy.size.height*0.03)
            .frame(width: proxy.size.width*0.6, height:proxy.size.height*0.2)
    }
}

// Structure that contains the sign up screen's formatted title.
struct Title: View {
    var proxy: GeometryProxy
    
    var body: some View {
        VStack (alignment: .leading, spacing: 16) {
            Text("Create Your Account")
                .font(.system(size: 26)).bold()
        }
        .padding(.all, 6)
        .foregroundColor(Styles().themePink)
        .offset(y: -proxy.size.height*0.03)
    }
}

// Structure for the input box where a user inputs information for their new account.
struct SignUpFormBox: View {
    @EnvironmentObject private var viewModel: OnboardingVM
    var proxy: GeometryProxy
    
    var body: some View {
        VStack (alignment: .leading, spacing: 16) {
            // Email input field.
            Text("Email")
                .font(.callout).bold()
            TextField("email", text: $viewModel.email)
                .autocapitalization(.none)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            // Password input field.
            Text("Create a Password")
                .font(.callout).bold()
            SecureField("password", text: $viewModel.password)
                .autocapitalization(.none)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            // Verifies user input and creates a new account.
            Button(action: {viewModel.verifyAndSignup()}) {
                HStack {
                    Text("Sign Up")
                        .frame(maxWidth: .infinity, alignment: .center)
                    Spacer()
                }
            }
            .buttonStyle(Styles.PinkButton())
        }
        .padding (.all, 36)
        .background(Color(UIColor.systemGray6))
        .cornerRadius (20)
    }
}
