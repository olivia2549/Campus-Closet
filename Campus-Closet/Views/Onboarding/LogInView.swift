//
//  LogInView.swift
//  Campus-Closet
//
//  Created by Hilly Yehoshua on 10/6/22.
//

import SwiftUI

struct LogInView: View {
    @StateObject private var loginVM = LoginVM()

    var body: some View {
        ZStack (alignment: .center) {
            NavigationView {
                VStack(spacing: 0) {
                    Logo()
                    LogInFormBox()
                }
                .padding(.all, 20)
                .navigationTitle("")
                .navigationBarHidden(true)
            }
            .statusBar(hidden: true)
            MessageView()
        }
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
    @EnvironmentObject private var viewModel: LoginVM
    
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
            
            NavigationLink(destination: ContentView().navigationBarHidden(true)
                            .navigationTitle("")
                            .navigationBarBackButtonHidden(true), tag: 1, selection: $viewModel.selection) {
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
            }
              
            NavigationLink(destination: SignUpView(), tag: 2, selection: $viewModel.selection) {
                Button(action: {viewModel.selection = 2}){
                    HStack{
                        Text("Sign Up")
                            .underline()
                            .frame(maxWidth: .infinity, alignment: .center)
                            .foregroundColor(Color ("Dark Pink"))
                        Spacer()
                    }
                }
                .navigationBarHidden(true)
                .navigationTitle("")
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
        NavigationView {
            LogInView()
        }
    }
}
