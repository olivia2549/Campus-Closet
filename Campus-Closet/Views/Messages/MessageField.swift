//
//  MessageField.swift
//  Campus-Closet
//
//  Created by Hilly Yehoshua on 10/23/22.
//

import SwiftUI

// Structure for the input field where users type messages.
struct MessageField: View {
    @EnvironmentObject var messagesVM: MessagesVM
    @EnvironmentObject var session: OnboardingVM
    
    @State private var message = ""
    var recipient: String

    var body: some View {
        HStack {
            // Custom text field created below.
            CustomTextField(placeholder: Text("Enter your message here"), text: $message)
                .frame(height: 52)
                .disableAutocorrection(true)
            Button {
                messagesVM.sendMessage(recipient: recipient, text: message, senderName: session.currentUser.name)
                message = ""
                hideKeyboard()
                } label: {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color("Dark Pink"))
                        .cornerRadius(50)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            .background(Color("LightGrey"))
            .cornerRadius(50)
            .padding()
        }
}

// Structure for a text field with custom design.
struct CustomTextField : View {
    var placeholder: Text
    @Binding var text: String
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }
    var body: some View {
        ZStack(alignment: .leading) {
            // If text is empty, show the placeholder on top of the TextField.
            if text.isEmpty {
                placeholder
                .opacity(0.5)
            }
            TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit)
        }
    }
}
