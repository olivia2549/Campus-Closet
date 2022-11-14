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
    @Published private(set) var lastMessageID = ""
    @Published var errorMessage: String = ""
    let db = Firestore.firestore()

    init() {
        fetchAllUsers()
        // getMessages()
        getConversation()
    }
    
    func getConversation() {
        let currentId = Auth.auth().currentUser!.uid
        let otherId = "eyG6aeR5EpO0sY46wFIaNVg9qSw2"
        
        let sentMessages = db.collection("Messages")
            .whereField("sender", isEqualTo: currentId)
            .whereField("recipient", isEqualTo: otherId)
        let receivedMessages = db.collection("Messages")
            .whereField("sender", isEqualTo: otherId)
            .whereField("recipient", isEqualTo: currentId)
        
        getMessages(query: sentMessages)
        getMessages(query: receivedMessages)
        
        self.messages.sort {
            $0.timestamp < $1.timestamp
        }
        if let id = self.messages.last?.id {
            self.lastMessageID = id
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
        do {
            let newMessage = Message(
                id: "\(UUID())",
                text: text,
                sender: "",
                recipient: "",
                received: false,
                timestamp: Date())
            try db.collection("Messages").document(newMessage.id).setData(from: newMessage)

        } catch{
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
