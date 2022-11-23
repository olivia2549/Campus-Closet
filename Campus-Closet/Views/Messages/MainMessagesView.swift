//
//  MainMessagesView.swift
//  Campus-Closet
//
//  Created by Hilly Yehoshua on 11/10/22.
//

import SwiftUI
import Firebase

class MainMessagesViewModel: ObservableObject{
    init(){
        fetchCurrentUser()
    }
    private func fetchCurrentUser(){
        
    }
}

struct MainMessagesView: View {
    @State var shouldShowLogOutOptions = false
    @State var shouldShowNewMessageScreen = false
    @StateObject private var profileVM = ProfileVM()
    @StateObject private var messagesVM = MessagesVM()

    var body: some View {
        NavigationStack{
            VStack{
                // Custom navigation bar
                customNavBar
                // Message history
                messagesView
            }
            .overlay(newMessageButton, alignment: .bottom)
            .navigationBarHidden(true)
        }
    }
    
    private var customNavBar: some View{
        HStack(spacing: 16) {
            if profileVM.profilePicture != nil {
                Image(uiImage : profileVM.profilePicture!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .cornerRadius(50)
            } else {
                Image("blank-profile")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .cornerRadius(50)
            }
            VStack(alignment: .leading, spacing: 4){
                Text(profileVM.user.name.isEmpty ? profileVM.user.email : profileVM.user.name)
                    .font (.system(size: 24, weight: .bold) )
                    //.opacity(getNameOpacity())
                HStack{
                    Circle()
                        .foregroundColor(.green)
                        .frame (width: 14, height: 14)
                    Text("online")
                        .font (.system(size: 12))
                        .foregroundColor(Color(.lightGray))
                }
            }
            Spacer()
            
            Button{
                shouldShowLogOutOptions.toggle()
            } label:{
                Image(systemName: "gear")
                    .font(.system(size: 24, weight: .bold))
            }
        }
        .padding()
        .onAppear {
            profileVM.getProfileData()
        }
        .actionSheet(isPresented: $shouldShowLogOutOptions) {
            .init(
                title: Text("Settings"),
                message: Text("What do you want to do?"),
                buttons: [.default(Text("DEFAULT BUTTON")), .cancel()]
            )
        }
    }
    
    private var messagesView: some View {
        ScrollView{
            ForEach(messagesVM.recentMessages.sorted(by: >), id: \.key) { key, value in // fixme: sort in vm
                HStack(spacing: 16) {
                    MessageShortcutView(for: key, for: value)
                }
                .padding (.horizontal)
                Divider()
                    .padding (.vertical, 8)
            }
        }
        .padding(.bottom, 50)
    }
    
    private var newMessageButton: some View{
        Button {
            shouldShowNewMessageScreen.toggle()
        } label: {
            HStack{
                Spacer()
                Text("+ New Message")
                    .font (.system(size: 16, weight: .bold))
                Spacer()
            }
            .foregroundColor(.white)
            .padding(.vertical)
            .background(Color("Dark Pink"))
            .cornerRadius(32)
            .padding(.horizontal)
            .shadow(radius: 15)
        }
        .fullScreenCover(isPresented: $shouldShowNewMessageScreen){
            CreateNewMessageView()
        }
    }
}

struct MessageShortcutView: View, Identifiable {
    @StateObject private var profileVM = ProfileVM()
    var id: String
    var messageId: String
    @State var myUser: User
    
    init(for id: String, for messageId: String) {
        self.id = id
        self.messageId = messageId
        self.myUser = User()
    }
    
    var body: some View {
        VStack{
            HStack (spacing: 16){
                if (profileVM.profilePicture != nil) {
                    Image(uiImage: profileVM.profilePicture!)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .cornerRadius(50)
                }
                else {
                    Image("blank-profile")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .cornerRadius(50)
                }
                
                NavigationLink(destination: Chat_Message(partnerId: profileVM.user.id)) {
                    VStack (alignment: .leading){
                        Text(profileVM.user.name.isEmpty ? profileVM.user.email : profileVM.user.name)
                            .font(.system(size:16, weight: .bold))
                        Text(profileVM.message)
                            .font(.system(size:14))
                            .foregroundColor(Color(.lightGray))
                    }
                    Spacer()
                }
            }
        }
        .onAppear(perform: {
            profileVM.fetchUser(userID: id)
            profileVM.fetchLastMessage(messageId: messageId)
        })
        Divider()
            .padding(.vertical, 8)
    }
}

struct MainMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MainMessagesView()
            .preferredColorScheme(.dark)
        MainMessagesView()
    }
}
