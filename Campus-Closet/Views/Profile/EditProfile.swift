//
//  EditProfile.swift
//  Campus-Closet
//
//  Created by Olivia Logan on 10/6/22.
//

import SwiftUI

struct EditProfile: View {
    @StateObject private var viewModel = OnboardingVM()
    
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
            )
            .padding(.top)
            
            Input(  // venmo input field
                for: "Venmo",
                autocapitalization: .never
            )
            
            Button("Delete account", action: { viewModel.deleteAccount() })
            
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
        .environmentObject(viewModel)
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
    @EnvironmentObject private var viewModel: OnboardingVM
    
    let inputLabel: String
    let autocapitalization: TextInputAutocapitalization
    
    init(
        for inputLabel: String,
        autocapitalization: TextInputAutocapitalization
    ){
        self.inputLabel = inputLabel
        self.autocapitalization = autocapitalization
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            VStack(alignment: .leading, spacing: 20) {
                Text(inputLabel)
                    .font(.system(size: 20, weight: .semibold))
                TextField("", text: $viewModel.fieldInput)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.gray)
                            .frame(height: 50)
                    )
                    .textInputAutocapitalization(autocapitalization)
                    .onSubmit {
                        viewModel.updateUser(with: inputLabel)
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
