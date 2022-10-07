//
//  LogInView.swift
//  Campus-Closet
//
//  Created by Hilly Yehoshua on 10/6/22.
//

import SwiftUI

struct LogInView: View {
    
    var body: some View {
        VStack(spacing: 0) {
            Logo()
            FormBox()
            

            

            
        }
        .padding(.all, 20)
        
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

struct FormBox: View {
    @State var email: String = ""
    @State var password: String = ""
    var body: some View{
        VStack (alignment: .leading, spacing: 16){
            Text("Email")
                .font(.callout).bold()
            TextField("example@example.com", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Text("Password")
                .font(.callout).bold()
            SecureField("password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Button(action: {print ("Hello Button")}){
                HStack{
                    Text("Sign In")
                    Spacer()
                }
            }
            .padding()
            .background(Color("Dark Pink"))
            .cornerRadius(10)
            .foregroundColor(Color.white)
   
        }
        .padding (.all, 36)
        .background(Color(UIColor.systemGray6))
        .cornerRadius (20)
        .offset(y: -140)
    }
    
}


struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}
