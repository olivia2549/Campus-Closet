//
//  Chat_Message.swift
//  Campus-Closet
//
//  Created by Hilly Yehoshua on 10/23/22.
//

import SwiftUI

struct Chat_Message: View {
    @StateObject var messagesVM = MessagesVM()
    @EnvironmentObject var session: OnboardingVM
    @State var partnerId: String
    
    var body: some View {
        VStack {
            VStack{
                ChatView(userId: $partnerId)
                ScrollViewReader { proxy in
                    ScrollView{
                        ForEach(messagesVM.messages.sorted(by: { $0.timestamp.compare($1.timestamp) == .orderedAscending }), id: \.id) { message in
                            MessageBubble(message: message)
                        }
                    }
                    .padding(.top, 10)
                    .background(.white)
                    .cornerRadius(30, corners: [.topLeft, .topRight])
                    .onChange(of: messagesVM.lastMessageID){ id in
                        withAnimation{
                            proxy.scrollTo(id, anchor: .bottom)
                        }
                    }
                }
            }
            .background(Color("Dark Pink"))
            
            MessageField(recipient: partnerId)
                .environmentObject(messagesVM)
                .environmentObject(session)
        }
        .onTapGesture { hideKeyboard() }
        .onAppear {
            messagesVM.getConversation(partnerId: partnerId)
        }
    }
}
