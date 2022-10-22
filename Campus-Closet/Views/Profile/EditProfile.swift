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
            
            CustomInput(  // name input field
                for: "Name",
                autocapitalization: .words,
                input: $viewModel.user.name
            ) {
                viewModel.updateUser()
            }
            .padding(.top)
            
            CustomInput(  // venmo input field
                for: "Venmo",
                autocapitalization: .never,
                input: $viewModel.user.venmo
            ) {
                viewModel.updateUser()
            }
            
            Button("Delete account", action: { viewModel.deleteAccount() })
            Button("Done", action: { viewModel.updateUser() })
            
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

struct EditProfile_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EditProfile()
        }
    }
}
