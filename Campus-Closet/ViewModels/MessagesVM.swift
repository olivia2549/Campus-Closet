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
    @Published var recentMessages: [String: String] = [:]
    @Published private(set) var lastMessageID = ""
    @Published var errorMessage: String = ""
    let db = Firestore.firestore()

    init() {
        fetchAllRecentMessages()
    }
    
    func fetchLastMessage(messageId: String) -> String {
        let profileRef = db.collection("Messages").document(messageId)
        var text = ""
        
        profileRef.getDocument(as: Message.self) { result in
            switch result {
            case .success(let message):
                text = message.text
            case .failure(let error):
                print("Error decoding message: \(error)")
            }
        }
        return text
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
    
    func sendMessage(recipient: String, text: String) {
        let myId = Auth.auth().currentUser!.uid
        let messageId = "\(UUID())"
        
        // Store new message document in Firestore database.
        do {
            let newMessage = Message(
                id: messageId,
                text: text,
                sender: myId,
                recipient: recipient,
                received: false,
                timestamp: Date())
            try db.collection("Messages").document(newMessage.id).setData(from: newMessage)
        } catch {
            print ("Error adding message to Firestore: \(error)")
        }
        
        // Add message to sender's recent message history.
        db.collection("users").document(myId).updateData([
            "messageHistory.\(recipient)": messageId
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
        
        // Add message to recipient's recent message history.
        db.collection("users").document(recipient).updateData([
            "messageHistory.\(myId)": messageId
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    func fetchAllRecentMessages() {
        let myId = Auth.auth().currentUser!.uid
        let db = Firestore.firestore()
        
        db.collection("users").document(myId).getDocument(as: User.self) { result in
            switch result {
            case .success(let user):
                for userId in user.messageHistory {
                    self.recentMessages[userId.key] = userId.value
                }
            case .failure(let error):
                print("Error decoding user: \(error)")
            }
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
