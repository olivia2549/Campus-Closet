//
//  MessageBubble.swift
//  Campus-Closet
//
//  Created by Hilly Yehoshua on 10/23/22.
//

import SwiftUI
import FirebaseAuth

struct MessageBubble: View {
    var message: Message
    @State private var showTime = false
    @State var received: Bool = true

    var body: some View {
        VStack (alignment: received ? .leading: .trailing){
            HStack{
                Text(message.text)
                    .padding()
                    .background(received ? Color("LightGrey") : Color ("Dark Pink"))
                    .cornerRadius(30)
            }
            .frame(maxWidth: 300, alignment: received ? .leading : .trailing)
            .onTapGesture {
                showTime.toggle()
            }
            if showTime {
                Text("\(message.timestamp.formatted(.dateTime.hour().minute()))")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(received ? .leading : .trailing, 25)
            }
        }
        .frame(maxWidth: .infinity, alignment: received ? .leading : .trailing)
        .padding(received ? .leading : .trailing)
        .padding(.horizontal, 10)
        .onAppear {
            received = message.recipient == Auth.auth().currentUser!.uid
        }
    }
}
