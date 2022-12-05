//
//  LogInView.swift
//  Campus-Closet
//
//  Created by Hilly Yehoshua on 10/6/22.
//

import SwiftUI

// Structure for the login screen.
struct LogInView: View {
    @StateObject private var loginVM = OnboardingVM()
    
    var body: some View {
        GeometryReader { proxy in
            NavigationStack {
                ZStack(alignment: .center) {
                    VStack(spacing: 0) {
                        LogoLogin(proxy: proxy)
                        LogInFormBox(proxy: proxy)
                        GuestLogin(proxy: proxy)
                    }
                    .padding(proxy.size.width*0.02)
                    ErrorView()
                }
                .navigationBarHidden(true)
                .onTapGesture { hideKeyboard() }
            }
            .statusBar(hidden: true)
            .environmentObject(loginVM)
        }
        .background(Color("LightGrey"), ignoresSafeAreaEdges: .all)
    }
}

// Structure that contains the formatted VFW logo to display on the screen.
struct LogoLogin: View {
    var proxy: GeometryProxy
    
    var body: some View {
        Image("logo")
            .resizable()
            .offset(y: -proxy.size.height*0.07)
            .frame(width: proxy.size.width*0.6, height:proxy.size.height*0.2)
    }
}

// Structure for the input box where a user inputs their account information.
struct LogInFormBox: View {
    @EnvironmentObject private var viewModel: OnboardingVM
    var proxy: GeometryProxy
    
    var body: some View {
        VStack (alignment: .leading, spacing: proxy.size.height*0.02) {
            // Email input field.
            Text("Email")
                .font(.callout).bold()
            TextField("email", text: $viewModel.email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .disableAutocorrection(true)
                .textInputAutocapitalization(.never)
            
            // Password input field.
            Text("Password")
                .font(.callout).bold()
            SecureField("password", text: $viewModel.password)
                .autocapitalization(.none)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .textInputAutocapitalization(.never)
            
            // Directs user to a screen to request a password reset email.
            Button(action: {
                if let window = UIApplication.shared.windows.first {
                    window.rootViewController = UIHostingController(rootView: ResetPasswordView())
                    window.makeKeyAndVisible()
                }
            }){
                Text("Forgot password?")
                    .font(Font.system(size: 15, weight: .semibold))
                    .foregroundColor(Styles().themePink)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            
            // Verifies user input. If valid, logs a user into their account.
            Button(action: {viewModel.verifyAndLogin()}){
                HStack {
                    Text("Log In")
                        .font(Font.system(size: 16, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .center)
                    Spacer()
                }
            }
            .buttonStyle(Styles.PinkButton())
            
            // Directs user to the sign up screen.
            NavigationLink(destination: SignUpView()) {
                HStack {
                    Text("Sign Up")
                        .underline()
                        .font(Font.system(size: 16, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundColor(Styles().themePink)
                    Spacer()
                }
            }
        }
        .padding (.all, proxy.size.width*0.1)
        .background(Color(UIColor.systemGray6))
        .cornerRadius(20)
        .offset(y: -proxy.size.height*0.07)
        .ignoresSafeArea()
    }
}

// Structure for a button that lets a user access the marketplace as a guest.
struct GuestLogin: View {
    @EnvironmentObject private var viewModel: OnboardingVM
    var proxy: GeometryProxy
    
    var body: some View {
        VStack(alignment: .leading, spacing: proxy.size.height*0.01) {
            // Directs user to the marketplace with restricted guest permissions.
            Button(action: {
                viewModel.guestLogIn()
            }){
                Text("Browse as Guest")
                    .font(Font.system(size: 16, weight: .semibold))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(Styles().themePink)
            }
        }
        .padding (.all, proxy.size.width*0.1)
        .cornerRadius(20)
        .offset(y: -proxy.size.height*0.1)
        .ignoresSafeArea()
    }
}
