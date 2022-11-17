//
//  MessageField.swift
//  Campus-Closet
//
//  Created by Hilly Yehoshua on 10/23/22.
//

import SwiftUI

struct MessageField: View {
    @EnvironmentObject var messagesVM: MessagesVM
    @State private var message = ""
    var recipient: String

    var body: some View {
        HStack {
            // Custom text field created below
            CustomTextField(placeholder: Text("Enter your message here"), text: $message)
                .frame(height: 52)
                .disableAutocorrection(true)
            Button {
                print("recipient is \(recipient)")
                messagesVM.sendMessage(recipient: recipient, text: message)
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

//struct MessageField_Previews: PreviewProvider {
//    static var previews: some View {
//        MessageField()
//            .environmentObject(MessagesVM())
//    }
//}

struct CustomTextField : View {
    var placeholder: Text
    @Binding var text: String
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }
    var body: some View {
        ZStack(alignment: .leading) {
            // If text is empty, show the placeholder on top of the TextField
            if text.isEmpty {
                placeholder
                .opacity(0.5)
            }
            TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit)
        }
    }
}
