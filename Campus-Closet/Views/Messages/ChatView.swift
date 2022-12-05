//
//  ChatView.swift
//  Campus-Closet
//
//  Created by Olivia Logan on 9/29/22.
//

import SwiftUI

struct ChatView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject var viewModel = ProfileVM()
    @Binding var userId: String
    
    var body: some View {
        HStack(spacing: 0){
            Styles.BackButton(presentationMode: self.presentationMode)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            
            if viewModel.profilePicture != nil {
                Image(uiImage: viewModel.profilePicture!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .cornerRadius(50)
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 15))
            } else {
                Image("blank-profile")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .cornerRadius(50)
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 15))
            }
            
            Text(viewModel.user.name.isEmpty ? viewModel.user.email : viewModel.user.name)
                .font(.title).bold()
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .onAppear {
            viewModel.fetchUser(userID: userId)
        }
        .navigationBarHidden(true)
        .padding()
    }
    
}

//struct ChatView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatView()
//            .background(Color("Dark Pink"))
//    }
//}
