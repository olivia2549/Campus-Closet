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
    @State private var partnerId = ""
    var id: String
    
    init(for id: String) {
        self.id = id
    }
    
    var body: some View {
        if viewModel.profilePicture != nil {
            Image(uiImage: viewModel.profilePicture!)
                .resizable()
                .scaledToFit()
                .frame(width:50, height:50)
                .clipped()
                .cornerRadius(50)
                .overlay(RoundedRectangle(cornerRadius: 50).stroke(Color(.label), lineWidth: 2))
        }
        else {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width:50, height:50)
                .clipped()
                .cornerRadius(50)
                .overlay(RoundedRectangle(cornerRadius: 50).stroke(Color(.label), lineWidth: 2))
        }
        
        NavigationLink(destination: Chat_Message(partnerId: $partnerId)) {
            Text(viewModel.user.name)
                .foregroundColor(.black)
            Spacer()
                .onAppear(perform: {
                    viewModel.fetchUser(userID: id)
                    partnerId = viewModel.user.id
                })
        }
    }
}
