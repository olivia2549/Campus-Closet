//
//  MainMessagesView.swift
//  Campus-Closet
//
//  Created by Hilly Yehoshua on 11/10/22.
//

import SwiftUI
import Firebase

struct MainMessagesView: View {
    @State var shouldShowLogOutOptions = false
    @State var shouldShowNewMessageScreen = false
    @State var isLoaded = false
    @StateObject private var profileVM = ProfileVM()
    @StateObject private var messagesVM = MessagesVM()
    @EnvironmentObject var session: OnboardingVM

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
        // Displays current user
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
            }
            Spacer()
        }
        .padding()
        .onAppear {
            profileVM.getProfileData()
        }
    }
    
    private var messagesView: some View {
        ScrollView{
            if isLoaded {
                ForEach(messagesVM.recentMessages.sorted(by: >), id: \.key) { key, value in
                    HStack(spacing: 16) {
                        MessageShortcutView(for: key, for: value)
                            .environmentObject(session)
                            .environmentObject(messagesVM)
                    }
                    .padding (.horizontal)
                    Divider()
                        .padding (.vertical, 8)
                }
            }
        }
        .onReceive(messagesVM.$recentMessages, perform: { recentMessages in
            isLoaded = true
        })
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
                .environmentObject(session)
                .environmentObject(messagesVM)
        }
    }
}

struct MessageShortcutView: View, Identifiable {
    @StateObject private var profileVM = ProfileVM()
    @EnvironmentObject var session: OnboardingVM
    @EnvironmentObject var messagesVM: MessagesVM
    var id: String
    var messageId: String
    
    init(for id: String, for messageId: String) {
        self.id = id
        self.messageId = messageId
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
                
                NavigationLink(destination: Chat_Message(partnerId: profileVM.user.id).environmentObject(session).environmentObject(messagesVM)) {
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
