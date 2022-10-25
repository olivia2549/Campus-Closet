//
//  Chat_Message.swift
//  Campus-Closet
//
//  Created by Hilly Yehoshua on 10/23/22.
//

import SwiftUI

struct Chat_Message: View {
    @StateObject var messagesManager = MessagesManager()
   
    var body: some View {
        VStack {
            VStack{
                ChatView()
                
                ScrollView{
                    ForEach(messagesManager.messages, id: \.id) { message in
                        Message_Bubble(message: message)
                    }
                }
                .padding(.top, 10)
                .background(.white)
                .cornerRadius(30, corners: [.topLeft, .topRight])
            }
            .background(Color("Dark Pink"))
            
            MessageField()
                .environmentObject(messagesManager)
        }
    }
}

struct Chat_Message_Previews: PreviewProvider {
    static var previews: some View {
        Chat_Message()
    }
}
