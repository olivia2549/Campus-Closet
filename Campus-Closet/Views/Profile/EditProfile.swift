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
            Button("Done", action: { viewModel.updateUser() })
            
            Spacer()
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    ZStack {
                        Circle()
                            .strokeBorder()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.gray)
                        Image(systemName: "arrow.backward")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 15, height: 15)
                            .foregroundColor(.black)
                    }
                }
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

struct EditProfile_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EditProfile()
        }
    }
}

// allow user to swipe back
extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
