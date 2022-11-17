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
        NavigationView{
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
            Image (systemName: "person.fill") // fixme: profile picture
                .font(.system(size:34, weight: .heavy))
            VStack(alignment: .leading, spacing: 4){
                Text(profileVM.user.name)
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
            
            ForEach(0..<10, id: \.self){ num in
                VStack{
                    HStack (spacing: 16){
                        Image(systemName: "person.fill")
                            .font(.system(size: 32))
                            .padding(8)
                            .overlay(RoundedRectangle(cornerRadius: 44)
                            .stroke(Color.black, lineWidth: 1))
                        
                        VStack (alignment: .leading){
                            Text("Username")
                                .font(.system(size:16, weight: .bold))
                            Text("Message sent to user")
                                .font(.system(size:14))
                                .foregroundColor(Color(.lightGray))
                        }
                        Spacer()

                        Text("22d")
                            .font(.system(size: 14, weight: .semibold))
                    }
                }
                Divider()
                    .padding(.vertical, 8)
                
            }
            .padding(.horizontal)
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
    var message: String
    @State var messageText: String = ""
    
    init(for id: String, for message: String) {
        self.id = id
        self.message = message
    }
    
    var body: some View {
        Image(systemName: "person.crop.circle.fill") // fixme: populate with profie picture
            .resizable()
            .scaledToFit()
            .frame(width:50, height:50)
            .clipped()
            .cornerRadius(50)
            .overlay(RoundedRectangle(cornerRadius: 50).stroke(Color(.label), lineWidth: 2))
        Text(profileVM.message) // fixme: populate with message
            .foregroundColor(.black)
        Spacer()
            .onAppear(perform: {
                profileVM.fetchUser(userID: id)
                profileVM.fetchLastMessage(messageId: message)
            })
    }
}

//struct UserMessageView<ViewModel>: View, Identifiable where ViewModel: MessagesVM {
//    @EnvironmentObject private var messagesVM: ViewModel
//    @StateObject private var profileVM = ProfileVM()
//    var id: String
//    var message: String
//    @State var messageText: String = ""
//
//    init(for id: String, for message: String) {
//        self.id = id
//        self.message = message
//    }
//
//    var body: some View {
//        Image(systemName: "person.crop.circle.fill") // fixme: populate with profie picture
//            .resizable()
//            .scaledToFit()
//            .frame(width:50, height:50)
//            .clipped()
//            .cornerRadius(50)
//            .overlay(RoundedRectangle(cornerRadius: 50).stroke(Color(.label), lineWidth: 2))
//        Text(message) // fixme: populate with message
//            .foregroundColor(.black)
//        Spacer()
//            .onAppear(perform: {
//                profileVM.fetchUser(userID: id)
//                self.messageText = messagesVM.fetchLastMessage(messageId: message)
//                // fixme: get message from id
//            })
//    }
//}

struct MainMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MainMessagesView()
            .preferredColorScheme(.dark)
        MainMessagesView()
    }
}
