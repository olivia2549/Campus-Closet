//
//  MessagesVM.swift
//  Campus-Closet
//
//  Created by Hilly Yehoshua on 10/24/22.
//
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class MessagesVM: ObservableObject {
    @Published private(set) var messages: [Message] = []
    @Published private(set) var lastMessageID = ""
    let db = Firestore.firestore()

    init (){
        getMessages()
    }

    func getMessages(){
        db.collection("Messages").addSnapshotListener{ QuerySnapshot, error in

            guard let documents = QuerySnapshot?.documents else{
                print ("Error fetching documents: \(String(describing: error))")
                return
            }
            // Mapping through the documents
            self.messages = documents.compactMap { document -> Message? in
                do {
                    // Converting each document into the Message model
                    // Note that data(as:) is a function available only in FirebaseFirestoreSwift package - remember to import it at the top
                    return try document.data(as: Message.self)
                } catch {
                    // print error
                    print("Error decoding document into Message: \(error)")

                    // Return nil if we run into an error
                    return nil
                }
            }
            self.messages.sort{
                $0.timestamp < $1.timestamp
            }
            if let id = self.messages.last?.id{
                self.lastMessageID = id
            }
        }
    }

    func sendMessage (text: String){
        do{
            let newMessage = Message (id: "\(UUID())", text: text, received: false, timestamp: Date())
            try db.collection("Messages").document().setData(from: newMessage)

        }catch{
            print ("Error adding message to Firestore: \(error)")
        }
    }

}
