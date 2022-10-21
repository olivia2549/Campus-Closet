//
//  VerifyEmailView.swift
//  Campus-Closet
//
//  Created by Lauren on 10/11/22.
//

import SwiftUI
import Firebase

struct VerifyEmailView: View {
    //@State var selection: Int? = nil
    @State var successMessage: String = ""

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Text("Welcome to the Campus Closet!")
                .multilineTextAlignment(.center)
                .padding(EdgeInsets(top: 5, leading: 32, bottom: 2, trailing: 32))
                .font(Font.system(size: 36, weight: .bold))
                .foregroundColor(.black)
                .background(.white)
            
            Text("Please verify your email address and return to the login screen.")
                .multilineTextAlignment(.center)
                .padding(EdgeInsets(top: 20, leading: 5, bottom: 20, trailing: 5))
                .font(Font.system(size: 22, weight: .semibold))
                .foregroundColor(Color("Dark Pink"))
                .background(.white)
            
            Button(action: {
                Auth.auth().currentUser?.sendEmailVerification { (error) in
                    successMessage = "Email sent!"
                }
            }, label: {
                Text("Verify Email")
                    .frame(maxWidth: .infinity)
                    .frame(height: 60, alignment: .center)
                    .font(Font.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
            })

            Text(successMessage)
                .padding(EdgeInsets(top: 18, leading: 10, bottom: 18, trailing: 10))
                .frame(maxWidth: .infinity, alignment: .center)
                .font(Font.system(size: 20, weight: .bold))
                .background(.white)
                .foregroundColor(Color("Dark Pink"))
        }
        .navigationBarBackButtonHidden(true)
        .frame(maxWidth: 340)
        .background(Color("Dark Pink"))
        .border(.white, width: 3)
    }
}

struct VerifyEmailView_Previews: PreviewProvider {
    static var previews: some View {
        VerifyEmailView()
    }
}
