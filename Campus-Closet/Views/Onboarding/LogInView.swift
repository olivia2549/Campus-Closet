//
//  LogInView.swift
//  Campus-Closet
//
//  Created by Hilly Yehoshua on 10/6/22.
//

import SwiftUI

struct LogInView: View {
    @StateObject private var loginVM = OnboardingVM()

    var body: some View {
        NavigationView {
            ZStack(alignment: .center) {
                VStack(spacing: 0) {
                    Logo()
                    LogInFormBox()
                }
                .padding(20)
                ErrorView()
            }
            .navigationTitle("")
            .navigationBarHidden(true)
            .onTapGesture { hideKeyboard() }
        }
        .statusBar(hidden: true)
        .environmentObject(loginVM)
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
    @EnvironmentObject private var viewModel: OnboardingVM
    
    var body: some View {
        VStack (alignment: .leading, spacing: 15) {
            Text("Email")
                .font(.callout).bold()
            TextField("email", text: $viewModel.email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .disableAutocorrection(true)
                .textInputAutocapitalization(.never)
            Text("Password")
                .font(.callout).bold()
            SecureField("password", text: $viewModel.password)
                .autocapitalization(.none)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .textInputAutocapitalization(.never)
            
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
            
            Button(action: {viewModel.verifyAndLogin()}){
                HStack{
                    Text("Log In")
                        .font(Font.system(size: 16, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .center)
                    Spacer()
                }
            }
            .buttonStyle(Styles.PinkButton())
            
            NavigationLink(destination: SignUpView()) {
                HStack{
                    Text("Sign Up")
                        .underline()
                        .font(Font.system(size: 16, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundColor(Styles().themePink)
                    Spacer()
                }
            }
            
        }
        .padding (.all, 36)
        .background(Color(UIColor.systemGray6))
        .cornerRadius (20)
        .offset(y: -140)
        .ignoresSafeArea()
    }
    
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}
