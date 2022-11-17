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
//        fetchAllUsers()
        fetchAllRecentMessages()
//        fetchAllContacts()
//        fetchAllUsers()
//        getMyMessages()
//        getMyMessageHistory()
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
        let otherId = "eyG6aeR5EpO0sY46wFIaNVg9qSw2"
        let messageId = "\(UUID())"
        
        do {
            let newMessage = Message(
                id: messageId,
                text: text,
                sender: myId,
                recipient: "",
                received: false,
                timestamp: Date())
            try db.collection("Messages").document(newMessage.id).setData(from: newMessage)
        } catch {
            print ("Error adding message to Firestore: \(error)")
        }
//
//        db.collection("users").document(myId).updateData([
//            "contacts": FieldValue.arrayUnion([messageId])
//        ])
//        db.collection("users").document(otherId).updateData([
//            "contacts": FieldValue.arrayUnion([messageId])
//        ])
    }
    
    func fetchAllRecentMessages() {
        let myId = Auth.auth().currentUser!.uid
        let db = Firestore.firestore()
        
        db.collection("users").document(myId).getDocument(as: User.self) { result in
            switch result {
            case .success(let user):
                for userId in user.messageHistory {
                    
                    self.recentMessages[userId.key] = userId.value
                    print(userId.value)
//                    print(userId.key)
//                    self.recentMessages[userId.key] = userId.value
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
