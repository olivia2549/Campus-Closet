//
//  CreateNewMessageView.swift
//  Campus-Closet
//
//  Created by Hilly Yehoshua on 11/10/22.
//

import SwiftUI
import Firebase

struct CreateNewMessageView: View {
    @Environment (\.presentationMode) var presentationMode
    @ObservedObject var viewModel = MessagesVM()
    
    var body: some View {
        NavigationStack{
            ScrollView{
                Text(viewModel.errorMessage)
                
                ForEach(viewModel.users, id: \.self) { id in
                    HStack(spacing: 16) {
                        UserListView(for: id)
                    }
                    .padding (.horizontal)
                    Divider()
                        .padding (.vertical, 8)
                }
            }.navigationTitle("New Message")
                .toolbar{
                    ToolbarItemGroup (placement: .navigationBarLeading){
                        Button{
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Text("Cancel")
                        }
                    }
                }
        }
        .onAppear {
            viewModel.fetchAllUsers()
        }
    }
}

struct UserListView: View, Identifiable {
    @StateObject private var viewModel = ProfileVM()
    var id: String
    
    init(for id: String) {
        self.id = id
    }
    
    var body: some View {
        if viewModel.profilePicture != nil {
            Image(uiImage: viewModel.profilePicture!)
                .resizable()
                .scaledToFit()
                .aspectRatio(contentMode: .fill)
                .frame(width: 50, height: 50)
                .cornerRadius(50)
        }
        else {
            Image("blank-profile")
                .resizable()
                .scaledToFit()
                .frame(width:50, height:50)
                .clipped()
                .cornerRadius(50)
        }
        
        NavigationLink(destination: Chat_Message(partnerId: viewModel.user.id)) {
            Text(viewModel.user.name)
                .foregroundColor(.black)
            Spacer()
                .onAppear(perform: {
                    viewModel.fetchUser(userID: id)
                })
        }
    }
}
