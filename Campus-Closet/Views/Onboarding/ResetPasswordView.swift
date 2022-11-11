//
//  ResetPasswordView.swift
//  Campus-Closet
//
//  Created by Lauren Scott on 11/9/22.
//

import SwiftUI

struct ResetPasswordView: View {
    @StateObject private var resetPasswordVM = OnboardingVM()
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Text("Reset Password")
                .multilineTextAlignment(.center)
                .padding(EdgeInsets(top: 5, leading: 32, bottom: 2, trailing: 32))
                .font(Font.system(size: 36, weight: .bold))
                .foregroundColor(.black)
            
            Text("Please enter the email address for your account.")
                .multilineTextAlignment(.center)
                .padding(EdgeInsets(top: 20, leading: 8, bottom: 15, trailing: 8))
                .font(Font.system(size: 22, weight: .semibold))
                .foregroundColor(Styles().themePink)
            
            TextField("email", text: $resetPasswordVM.email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .disableAutocorrection(true)
                .textInputAutocapitalization(.never)
            
            Button(action: { resetPasswordVM.verifyAndResetPassword() }){
                HStack{
                    Text("Submit")
                        .frame(maxWidth: .infinity, alignment: .center)
                    Spacer()
                }
            }
            .buttonStyle(Styles.PinkButton())
            
            Button(action: {
                if let window = UIApplication.shared.windows.first {
                    window.rootViewController = UIHostingController(rootView: LogInView())
                    window.makeKeyAndVisible()
                }
            }){
                HStack{
                    Text("Return to Login")
                        .frame(maxWidth: .infinity, alignment: .center)
                    Spacer()
                }
            }
            .buttonStyle(Styles.PinkButton())
            
            if resetPasswordVM.isEmailSent {
                Text("We sent you a link to reset your password!")
                    .multilineTextAlignment(.center)
                    .padding(EdgeInsets(top: 20, leading: 8, bottom: 15, trailing: 8))
                    .font(Font.system(size: 16, weight: .semibold))
                    .foregroundColor(Styles().themePink)
            }
        }
        .frame(maxWidth: 340)
        .border(.white, width: 3)
        .environmentObject(resetPasswordVM)
    }
}
