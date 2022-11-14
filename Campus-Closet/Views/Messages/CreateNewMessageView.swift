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
    @ObservedObject var vm = MessagesVM()
    
    var body: some View {
        NavigationView{
            ScrollView{
                Text(vm.errorMessage)
                
                ForEach(vm.users, id: \.self) { id in
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
    }
}

struct UserListView: View, Identifiable {
    @StateObject private var viewModel = ProfileVM()
    var id: String
    
    init(for id: String) {
        self.id = id
    }
    
    var body: some View {
        Image(systemName: "person.crop.circle.fill")
            .resizable()
            .scaledToFit()
            .frame(width:50, height:50)
            .clipped()
            .cornerRadius(50)
            .overlay(RoundedRectangle(cornerRadius: 50).stroke(Color(.label), lineWidth: 2))
        Text(viewModel.user.name)
            .foregroundColor(.black)
        Spacer()
            .onAppear(perform: { viewModel.fetchUser(userID: id) })
    }
}
