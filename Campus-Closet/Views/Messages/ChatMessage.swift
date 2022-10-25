//
//  Chat_Message.swift
//  Campus-Closet
//
//  Created by Hilly Yehoshua on 10/23/22.
//
import SwiftUI

struct Chat_Message: View {
    @StateObject var messagesVM = MessagesVM()

    var body: some View {
        VStack {
            VStack{
                ChatView()

                ScrollView{
                    ForEach(messagesVM.messages, id: \.id) { message in
                        MessageBubble(message: message)
                    }
                }
                .padding(.top, 10)
                .background(.white)
                .cornerRadius(30, corners: [.topLeft, .topRight])
            }
            .background(Color("Dark Pink"))

            MessageField()
                .environmentObject(messagesVM)
        }
    }
}

struct Chat_Message_Previews: PreviewProvider {
    static var previews: some View {
        Chat_Message()
    }
}
