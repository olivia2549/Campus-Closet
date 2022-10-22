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
                MessageView()
            }
            .navigationTitle("")
            .navigationBarHidden(true)
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
        VStack (alignment: .leading, spacing: 16) {
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
            
            Button(action: {viewModel.verifyAndLogin()}){
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
            
            NavigationLink(destination: SignUpView()) {
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
        .ignoresSafeArea()
    }
    
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}
