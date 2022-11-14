//
//  MessagesVM.swift
//  Campus-Closet
//
//  Created by Hilly Yehoshua on 10/24/22.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

class MessagesVM: ObservableObject {
    @Published var users: [String] = []
    @Published private(set) var messages: [Message] = []
    @Published var recentMessages: [String: Message] = [:]
    @Published private(set) var lastMessageID = ""
    @Published var errorMessage: String = ""
    let db = Firestore.firestore()

    init() {
        fetchAllUsers()
        getMyMessages()
        getMyMessageHistory()
    }
    
    func getMyMessages() {
        let currentId = Auth.auth().currentUser!.uid
        
        // Fetch all messages I have sent.
        let sentMessages = db.collection("Messages").whereField("sender", isEqualTo: currentId)
        getMessages(query: sentMessages)
        
        // Fetch all messages I have received.
        let receivedMessages = db.collection("Messages").whereField("recipient", isEqualTo: currentId)
        getMessages(query: receivedMessages)
        
        self.messages.sort {
            $0.timestamp < $1.timestamp
        }
    }
    
    func getMyMessageHistory() {
        let currentId = Auth.auth().currentUser!.uid
        
        for message in self.messages.reversed() {
            let otherUser = message.sender == currentId ? message.recipient : message.sender
            if !self.recentMessages.keys.contains(otherUser) {
                self.recentMessages[otherUser] = message
            }
        }
    }
    
    func getConversation(partnerId: String) {
        let myId = Auth.auth().currentUser!.uid
        
        // Fetch all messages I have sent in this conversation.
        let sentMessages = db.collection("Messages")
            .whereField("sender", isEqualTo: myId)
            .whereField("recipient", isEqualTo: partnerId)
        getMessages(query: sentMessages)
        
        // Fetch all messages I have received in this conversation.
        let receivedMessages = db.collection("Messages")
            .whereField("sender", isEqualTo: partnerId)
            .whereField("recipient", isEqualTo: myId)
        getMessages(query: receivedMessages)
        
        // Order messages in chronological order.
        self.messages.sort {
            $0.timestamp < $1.timestamp
        }
    }
    
    func getMessages(query: Query) {
        query.getDocuments() { querySnapshot, err in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    do {
                        // Convert each document into the Message model.
                        try self.messages.append(document.data(as: Message.self))
                    } catch {
                        print("Error decoding document into Message: \(error)")
                    }
                }
            }
        }
    }
    
    func sendMessage(text: String) {
        let myId = Auth.auth().currentUser!.uid
        
        do {
            let newMessage = Message(
                id: "\(UUID())",
                text: text,
                sender: myId,
                recipient: "",
                received: false,
                timestamp: Date())
            try db.collection("Messages").document(newMessage.id).setData(from: newMessage)
        } catch {
            print ("Error adding message to Firestore: \(error)")
        }
    }

    func fetchAllUsers() {
        let db = Firestore.firestore()
        
        db.collection("users").order(by: "name").addSnapshotListener { querySnapshot, err in
            if let err = err {
                print("Error getting user documents: \(err)")
            } else {
                self.users = []
                for document in querySnapshot!.documents {
                    self.users.append(document.documentID)
                }
            }
        }
    }
}
