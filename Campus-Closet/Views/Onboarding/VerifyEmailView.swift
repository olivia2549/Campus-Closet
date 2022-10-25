//
//  VerifyEmailView.swift
//  Campus-Closet
//
//  Created by Lauren on 10/11/22.
//

import SwiftUI
import Firebase

struct VerifyEmailView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Text("Welcome to the Campus Closet!")
                .multilineTextAlignment(.center)
                .padding(EdgeInsets(top: 5, leading: 32, bottom: 2, trailing: 32))
                .font(Font.system(size: 36, weight: .bold))
                .foregroundColor(.black)
                .background(.white)
            
            Text("A verification email has been sent. Please verify your email and return to login.")
                .multilineTextAlignment(.center)
                .padding(EdgeInsets(top: 20, leading: 5, bottom: 20, trailing: 5))
                .font(Font.system(size: 22, weight: .semibold))
                .foregroundColor(Styles().themePink)
                .background(.white)
            Button(action: {
                if let window = UIApplication.shared.windows.first {
                    window.rootViewController = UIHostingController(rootView: LogInView())
                    window.makeKeyAndVisible()
                }
            }){
                HStack{
                    Text("Done")
                        .frame(maxWidth: .infinity, alignment: .center)
                    Spacer()
                }
            }
            .buttonStyle(Styles.PinkButton())
        }
        .frame(maxWidth: 340)
        .background(Styles().themePink)
        .border(.white, width: 3)
    }
}

struct VerifyEmailView_Previews: PreviewProvider {
    static var previews: some View {
        VerifyEmailView()
    }
}
