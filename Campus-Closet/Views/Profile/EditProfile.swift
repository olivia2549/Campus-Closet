//
//  EditProfile.swift
//  Campus-Closet
//
//  Created by Olivia Logan on 10/6/22.
//

import SwiftUI

struct EditProfile: View {
    @StateObject private var viewModel = OnboardingVM()
    @State var chosenPicture: UIImage?
    @State var pickerShowing = false
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
                input: $viewModel.user.name
            ) {
                viewModel.updateUser(chosenPicture: chosenPicture)
            }
            .padding(.top)
            
            CustomInput(  // venmo input field
                for: "Venmo",
                imageName: "v.circle",
                autocapitalization: .never,
                input: $viewModel.user.venmo
            ) {
                viewModel.updateUser(chosenPicture: chosenPicture)
            }
            
            Button("Done", action: {
                viewModel.updateUser(chosenPicture: chosenPicture)
                self.presentationMode.wrappedValue.dismiss()
            })
                .buttonStyle(Styles.PinkButton())
            
            Button("Delete account", action: { viewModel.deleteAccount() })
                .buttonStyle(Styles.PinkTextButton())
            
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
        .sheet(isPresented: $pickerShowing, onDismiss: nil, content: {
            viewModel.choosePicture(chosenPicture: $chosenPicture, pickerShowing: $pickerShowing)
        })
        .navigationBarBackButtonHidden(true)
        .environmentObject(viewModel)
    }
}

struct NewProfileImage: View {
    @EnvironmentObject private var viewModel: OnboardingVM
    @Binding var chosenPicture: UIImage?
    
    var body: some View {
        if chosenPicture != nil {
            Image(uiImage: chosenPicture!)
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
    @EnvironmentObject private var viewModel: OnboardingVM
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
        NavigationView {
            EditProfile()
        }
    }
}
