//
//  SignUpView.swift
//  Campus-Closet
//
//  Created by Lauren Scott on 10/10/22.
//

import SwiftUI
import Firebase

struct SignUpView: View {
    @StateObject private var signupVM = OnboardingVM()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        GeometryReader {proxy in
            ZStack(alignment: .center) {
                VStack(spacing: 0) {
                    LogoSignup(proxy: proxy)
                    Title(proxy: proxy)
                    SignUpFormBox(proxy: proxy)
                }
                .padding(20)
                ErrorView()
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

struct LogoSignup: View {
    var proxy: GeometryProxy
    
    var body: some View {
        Image("logo")
            .resizable()
            .offset(y: -proxy.size.height*0.03)
            .frame(width: proxy.size.width*0.6, height:proxy.size.height*0.2)
    }
}

struct Title: View {
    var proxy: GeometryProxy
    
    var body: some View {
        VStack (alignment: .leading, spacing: 16){
            Text("Create Your Account")
                .font(.system(size: 26)).bold()
        }
        .padding(.all, 6)
        .foregroundColor(Styles().themePink)
        .offset(y: -proxy.size.height*0.03)
    }
}

struct SignUpFormBox: View {
    @EnvironmentObject private var viewModel: OnboardingVM
    var proxy: GeometryProxy
    
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
            
            Button(action: {viewModel.verifyAndSignup()}){
                HStack{
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

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
