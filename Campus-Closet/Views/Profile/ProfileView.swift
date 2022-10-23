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

struct ProfileInfo: View {
    @EnvironmentObject private var viewModel: ProfileVM

    var body: some View {
        Text(viewModel.name)
            .font(.system(size: 32, weight: .medium))
        HStack(alignment: .center) {
            Image(systemName: "star.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 25, height: 25)
                .foregroundColor(Shared().themePink)
            Text(viewModel.rating)
            Text("(12 Reviews)")
            Text("|")
            Image(systemName: "dollarsign.circle")
                .foregroundColor(Shared().themePink)
            Text(viewModel.venmo)
        }
        .frame(maxWidth: .infinity)
    }
}

struct ToggleView: View {
    @State private var tabIndex = 0
    var body: some View {
        VStack {
            SlidingTabView(
                selection: $tabIndex,
                tabs: ["Listed", "Sold", "Purchased"],
                font: .system(size: 20, weight: .medium),
                animation: .easeInOut,
                activeAccentColor: Shared().themePink,
                inactiveAccentColor: .gray,
                selectionBarColor: Shared().themePink
            )
            if (tabIndex == 0) {
                Text("No listings yet")
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
