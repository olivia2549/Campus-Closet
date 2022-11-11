//
//  CreateNewMessageView.swift
//  Campus-Closet
//
//  Created by Hilly Yehoshua on 11/10/22.
//

import SwiftUI
import Firebase




class CreateNewMessageViewModel : ObservableObject{
    @Published var users =  [User]()
    @Published var errorMessage = ""
    
    init(){
        fetchAllUsers()
    }
    
    private func fetchAllUsers(){
        let db = Firestore.firestore()
        db.collection("users").getDocuments{ documentsSnapshot, error in
            if let error = error {
                self.errorMessage = "Failed to fetch users: \(error)"
                print ("Failed to fetch users: \(error)")
                return
            }
            documentsSnapshot?.documents.forEach({ snapshot in
                let data = snapshot.data()
                //self.users.append(snapshot.)

                
            })
            self.errorMessage = "Fetched successfully"
        }
    }
}

//const querySnapshot = await getDocs(collection(db, "cities"));
//querySnapshot.forEach((doc) => {
//  // doc.data() is never undefined for query doc snapshots
//  console.log(doc.id, " => ", doc.data());
//});

struct CreateNewMessageView: View {
    @Environment (\.presentationMode) var presentationMode
    @ObservedObject var vm = CreateNewMessageViewModel()
    var body: some View {
        NavigationView{
            ScrollView{
                Text(vm.errorMessage)
                ForEach(0..<10){ num in
                    Text("new user")
                }
            }.navigationTitle("New Message")
                .toolbar{
                    ToolbarItemGroup (placement: .navigationBarLeading){
                        Button{
                            presentationMode.wrappedValue.dismiss()
                        }label: {
                            Text("Cancel")
                        }
                    }
                }
        }
    }
}

struct CreateNewMessageView_Previews: PreviewProvider {
    static var previews: some View {
        //CreateNewMessageView()
        MainMessagesView()
    }
}
