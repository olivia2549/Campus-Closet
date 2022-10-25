//
//  EditProfile.swift
//  Campus-Closet
//
//  Created by Olivia Logan on 10/6/22.
//

import SwiftUI

struct EditProfile: View {
    @StateObject private var viewModel = OnboardingVM()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            ZStack(alignment: .bottomTrailing) {
                ProfileImage()
                CameraIcon()
            }
            .onTapGesture { hideKeyboard() }
            
            CustomInput(  // name input field
                for: "Name",
                imageName: "person",
                autocapitalization: .words,
                input: $viewModel.user.name
            ) {
                viewModel.updateUser()
            }
            .padding(.top)
            
            CustomInput(  // venmo input field
                for: "Venmo",
                imageName: "v.circle",
                autocapitalization: .never,
                input: $viewModel.user.venmo
            ) {
                viewModel.updateUser()
            }
            
            Button("Delete account", action: { viewModel.deleteAccount() })
                .buttonStyle(Styles.PinkButton())
            
            Button("Done", action: { viewModel.updateUser() })
                .buttonStyle(Styles.PinkButton())
            
            Spacer()
        }
        .onTapGesture { hideKeyboard() }
        .padding()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Styles.BackButton(presentationMode: self.presentationMode)
            }
            ToolbarItem(placement: .principal) {
                Text("Edit Profile")
                    .font(.system(size: 24, weight: .semibold))
            }
        }
        .navigationBarBackButtonHidden(true)
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

struct CameraIcon: View {
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(.white)
                .frame(width: 45, height: 45)
            Circle()
                .strokeBorder()
                .foregroundColor(.gray)
                .frame(width: 45, height: 45)
            Image(systemName: "camera.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 25, height: 25)
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
