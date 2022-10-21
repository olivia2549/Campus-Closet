//
//  EditProfile.swift
//  Campus-Closet
//
//  Created by Olivia Logan on 10/6/22.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

struct EditProfile: View {
    @State private var name: String = ""
    @State private var venmo: String = ""
    
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Color("Dark Pink"))
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            ZStack {
                ProfileImage().padding(.top)
                Text("Choose Image")
                    .font(.system(size: 24))
                    .foregroundColor(.black)
                    .frame(width: 100, alignment: .center)
                    .multilineTextAlignment(.center)
                    .padding(.top)
            }
            
            Input(  // name input field
                for: "Name",
                autocapitalization: .words
            ) {name in
                print("submitted name: \(name)")
                self.name = name
            }
            .padding(.top)
            
            Input(  // venmo input field
                for: "Venmo/Cash App",
                autocapitalization: .never
            ) { venmo in
                print("submitted venmo: \(venmo)")
                self.venmo = venmo
            }
            
            Button("Done", action: {createProfile(name: name, venmo: venmo)})
            
            Spacer()
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Edit Profile")
                    .font(.system(size: 32, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.top, 50)
            }
        }
    }
}

struct ProfileImage: View {
    var body: some View {
        Image("blank-profile")
            .resizable()
            .frame(width: 175, height: 175, alignment: .center)
            .aspectRatio(contentMode: .fit)
            .clipShape(Circle())
    }
}

struct Input: View {
    @State private var fieldInput: String = ""
    let fieldLabel: String
    let autocapitalization: TextInputAutocapitalization
    var completion: (String) -> Void
    
    init(
        for fieldLabel: String,
        autocapitalization: TextInputAutocapitalization,
        completion: @escaping (String) -> Void
    ){
        self.fieldLabel = fieldLabel
        self.autocapitalization = autocapitalization
        self.completion = completion
    }
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            VStack(alignment: .leading, spacing: 20) {
                Text(fieldLabel)
                    .font(.system(size: 20, weight: .semibold))
                TextField("", text: $fieldInput)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.gray)
                            .frame(height: 50)
                    )
                    .textInputAutocapitalization(autocapitalization)
                    .onSubmit {
                        completion(fieldInput)
                    }
            }
            .padding()
        }
    }
}

struct EditProfile_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EditProfile()
        }
    }
}

func createProfile(name: String, venmo: String) {
    let db = Firestore.firestore()
    print("creating...")

    if (name == "" || venmo == "") {
        return
    }
    
    if let user = Auth.auth().currentUser?.email {
        db.collection("users").addDocument(data: [
            "email": user,
            "name": name,
            "venmo": venmo
        ]) { (error) in
            if let e = error {
                print("There was an issue saving data to Firestore, \(e).")
            } else {
                print("Successfully saved data.")
                
                DispatchQueue.main.async {
                    // this is where we update the frontend
                }
            }
        }
    }
}
