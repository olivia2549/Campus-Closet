//
//  ProfileView.swift
//  Campus-Closet
//
//  Created by Olivia Logan on 9/29/22.
//

import SwiftUI
import SlidingTabView

struct ProfileView: View {
    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 10) {
                ViewProfileHeader()
                ProfileImage()
                Text("Gigi Hadid")
                    .font(.system(size: 32, weight: .medium))
                HStack(alignment: .center) {
                    Image(systemName: "star.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 25)
                        .foregroundColor(Color("Dark Pink"))
                    Text("4.8")
                    Text("(12 Reviews)")
                    Text("|")
                    Image(systemName: "dollarsign.circle")
                        .foregroundColor(Color("Dark Pink"))
                    Text("@gigi-hadid")
                }
                .frame(maxWidth: .infinity)
                
                ToggleView()
                .padding(.top)
                Spacer()
            }
            .navigationTitle("")
            .navigationBarHidden(true)
        }
        .statusBar(hidden: true)
    }
}

struct ViewProfileHeader: View {
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
                        .frame(width: 20, height: 20, alignment: .trailing)
                        .padding(.leading, 30)
                        .foregroundColor(.black)
                }
            }
            .frame(maxWidth: .infinity)
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
                activeAccentColor: Color("Dark Pink"),
                inactiveAccentColor: .gray,
                selectionBarColor: Color("Dark Pink")
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
