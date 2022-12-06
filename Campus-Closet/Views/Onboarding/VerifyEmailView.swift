//
//  VerifyEmailView.swift
//  Campus-Closet
//
//  Created by Lauren Scott on 10/11/22.
//

import SwiftUI
import Firebase

// Structure for a screen that notifies a user about their verification email.
struct VerifyEmailView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Text("Welcome to the Campus Closet!")
                .multilineTextAlignment(.center)
                .padding(EdgeInsets(top: 5, leading: 32, bottom: 2, trailing: 32))
                .font(Font.system(size: 36, weight: .bold))
                .foregroundColor(.black)
            
            Text("A verification email has been sent to you! Please verify your email and return to login.")
                .multilineTextAlignment(.center)
                .padding(EdgeInsets(top: 20, leading: 8, bottom: 15, trailing: 8))
                .font(Font.system(size: 22, weight: .semibold))
                .foregroundColor(Styles().themePink)
            
            // Button that returns a user to the login screen.
            Button(action: {
                if let window = UIApplication.shared.windows.first {
                    window.rootViewController = UIHostingController(rootView: LogInView())
                    window.makeKeyAndVisible()
                }
            }){
                HStack {
                    Text("Done")
                        .frame(maxWidth: .infinity, alignment: .center)
                    Spacer()
                }
            }
            .buttonStyle(Styles.PinkButton())
        }
        .frame(maxWidth: 340)
        .border(.white, width: 3)
    }
}
