//
//  ProfileView.swift
//  Campus-Closet
//
//  Created by Olivia Logan on 9/29/22.
//

import SwiftUI
import SlidingTabView

struct ProfileView: View {
    @StateObject private var viewModel = ProfileVM()
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 10) {
                ProfileHeader()
                ProfileImage()
                ProfileInfo()
                ToggleView()
                .padding(.top)
                Spacer()
            }
            .onAppear(perform: {
                viewModel.getProfileData()
            })
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
        .statusBar(hidden: true)
        .environmentObject(viewModel)
    }
}

struct ProfileHeader: View {
    var body: some View {
        HStack {
            Spacer().frame(maxWidth: .infinity)
            VStack(alignment: .center) {
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150)
            }
            .frame(maxWidth: .infinity)
            VStack(alignment: .trailing) {
                NavigationLink(destination: EditProfile()) {
                    Image(systemName: "pencil.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30, alignment: .trailing)
                        .padding(.leading, 30)
                        .foregroundColor(.black)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity)
    }
}

struct ProfileImage: View {
    @EnvironmentObject private var viewModel: ProfileVM
    
    var body: some View {
        if (viewModel.profilePicture != nil) {
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

struct ProfileInfo: View {
    @EnvironmentObject private var viewModel: ProfileVM

    var body: some View {
        Text(viewModel.user.name)
            .font(.system(size: 32, weight: .medium))
        HStack(alignment: .center) {
            Image(systemName: "star.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 25, height: 25)
                .foregroundColor(Styles().themePink)
            Text("4.5")
            Text("(12 Reviews)")
            Text("|")
            Image(systemName: "dollarsign.circle")
                .foregroundColor(Styles().themePink)
            Text(viewModel.user.venmo ?? "")
        }
        .frame(maxWidth: .infinity)
    }
}

struct ToggleView: View {
    @EnvironmentObject private var viewModel: ProfileVM
    @State private var tabIndex = 0
    
    var body: some View {
        VStack {
            SlidingTabView(
                selection: $tabIndex,
                tabs: ["Listed", "Sold", "Purchased"],
                font: .system(size: 20, weight: .medium),
                animation: .easeInOut,
                activeAccentColor: Styles().themePink,
                inactiveAccentColor: .gray,
                selectionBarColor: Styles().themePink
            )
            if (tabIndex == 0) {
                ForEach(viewModel.user.listings ?? [], id: \.self) { id in
                    ItemCardView(for: id)
                }
            } else {
                Text("None yet")
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
