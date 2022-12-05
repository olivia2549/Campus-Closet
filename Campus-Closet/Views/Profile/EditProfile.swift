//
//  EditProfile.swift
//  Campus-Closet
//
//  Created by Olivia Logan on 10/6/22.
//

import SwiftUI

struct EditProfile: View {
    @EnvironmentObject private var session: OnboardingVM
    @EnvironmentObject private var profileVM: ProfileVM
    @State var chosenPicture: UIImage?
    @State var pickerShowing = false
    @State var loadingPicturePicker = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            ZStack(alignment: .bottomTrailing) { // profile picture selection
                NewProfileImage(chosenPicture: $chosenPicture)
                CameraIcon(pickerShowing: $pickerShowing)
            }
            .onTapGesture { hideKeyboard() }
            
            CustomInput(  // name input field
                for: "Name",
                imageName: "person",
                autocapitalization: .words,
                input: $profileVM.user.name
            ) {
                profileVM.updateUser(chosenPicture: chosenPicture)
            }
            .padding(.top)
            
            CustomInput(  // venmo input field
                for: "Venmo",
                imageName: "v.circle",
                autocapitalization: .never,
                input: $profileVM.user.venmo
            ) {
                profileVM.updateUser(chosenPicture: chosenPicture)
            }
            
            Button("Done", action: {
                profileVM.updateUser(chosenPicture: chosenPicture)
                self.presentationMode.wrappedValue.dismiss()
            })
            .buttonStyle(Styles.PinkButton())
            
            Button("Sign out", action: { session.logOut() })
                .buttonStyle(Styles.PinkTextButton())
            
            Button("Delete account", action: { session.deleteAccount() })
                .buttonStyle(Styles.PinkTextButton())
            
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
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
        .sheet(isPresented: $pickerShowing, onDismiss: nil, content: {
            profileVM.choosePicture(chosenPicture: $chosenPicture, pickerShowing: $pickerShowing, isLoading: $loadingPicturePicker)
        })
        .onChange(of: chosenPicture, perform: { newValue in
            profileVM.profilePicture = chosenPicture
        })
        .environmentObject(profileVM)
    }
}

struct NewProfileImage: View {
    @EnvironmentObject private var viewModel: ProfileVM
    @Binding var chosenPicture: UIImage?
    
    var body: some View {
        if chosenPicture != nil {
            Image(uiImage: chosenPicture!)
                .resizable()
                .frame(width: 175, height: 175, alignment: .center)
                .aspectRatio(contentMode: .fit)
                .clipShape(Circle())
        }
        else if viewModel.profilePicture != nil {
            Image(uiImage: viewModel.profilePicture!)
                .resizable()
                .frame(width: 175, height: 175, alignment: .center)
                .aspectRatio(contentMode: .fit)
                .clipShape(Circle())
        }
        else {
            Image("blank-profile")
                .resizable()
                .frame(width: 175, height: 175, alignment: .center)
                .aspectRatio(contentMode: .fit)
                .clipShape(Circle())
        }
    }
}

struct CameraIcon: View {
    @EnvironmentObject private var viewModel: ProfileVM
    @Binding var pickerShowing: Bool
    
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
        .onTapGesture {
            pickerShowing = true
        }
    }
}

struct EditProfile_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            EditProfile()
        }
    }
}
