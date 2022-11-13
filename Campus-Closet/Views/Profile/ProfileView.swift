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
    @State var offset: CGFloat = 0

<<<<<<< Updated upstream
    let maxHeight = UIScreen.main.bounds.height / 2.5
=======
    let maxHeight = UIScreen.main.bounds.height / 2.1
    @State var headerHeight: CGFloat = 0
>>>>>>> Stashed changes
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .center, spacing: 10) {
                    GeometryReader{ proxy in
                        ProfileInfo(offset: $offset)
                            .frame(maxWidth: .infinity)
                            .frame(height: getHeaderHeight(), alignment: .bottom)
                            .overlay(
                                ProfileHeader(
                                    offset: $offset,
                                    maxHeight: maxHeight
                                )
                                ,alignment: .top
                            )
                    }
                    .frame(height: maxHeight)
                    .offset(y: -offset)
                    .zIndex(1)
                    
                    if viewModel.viewingMode == ViewingMode.buyer {
                        ToggleView(maxHeight: maxHeight, tabs: ["Bids", "Saved"])
                            .padding(.top)
                            .zIndex(0)
                    }
                    else {
                        ToggleView(maxHeight: maxHeight, tabs: ["Listings", "Sold"])
                            .padding(.top)
                            .zIndex(0)
                    }
                }
                .modifier(OffsetModifier(offset: $offset))
            }
            .coordinateSpace(name: "SCROLL")
            .onAppear(perform: {
                viewModel.getProfileData()
            })
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
        .statusBar(hidden: true)
        .environmentObject(viewModel)
    }
    
    func getHeaderHeight() -> CGFloat {
        let topHeight = maxHeight + offset
        return topHeight > 80 ? topHeight : 80
    }
    
}

struct ProfileHeader: View {
    @EnvironmentObject private var viewModel: ProfileVM
    @Binding var offset: CGFloat
<<<<<<< Updated upstream
    var maxHeight: CGFloat
=======
    @Binding var headerHeight: CGFloat
//    var maxHeig ht: CGFloat
>>>>>>> Stashed changes
    
    var body: some View {
        HStack {
            Text(viewModel.user.name)
                .font(.system(size: 20, weight: .semibold))
                .frame(maxWidth: .infinity)
                .opacity(getNameOpacity())
            VStack(alignment: .center) {
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150)
            }
            .opacity(getOpacity())
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
        .ignoresSafeArea()
        .frame(maxWidth: .infinity)
        .frame(height: 80)
        .background(.white)
    }
    
    func getOpacity() -> CGFloat {
        let progress = -offset/70
        let opacity = 1-progress
        return offset < 0 ? opacity : 1
    }
    
    func getNameOpacity() -> CGFloat {
        let progress = -(offset + 50) / (maxHeight - 80)
        return progress
    }
    
}

struct ProfileInfo: View {
    @EnvironmentObject private var viewModel: ProfileVM
    @Binding var offset: CGFloat
    
    var body: some View {
        VStack {
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
            Text(viewModel.user.name)
                .font(.system(size: 32, weight: .medium))
            HStack(alignment: .center) {
                Image(systemName: "star.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: 25)
                    .foregroundColor(Styles().themePink)
                Text(String(format: "%.2f", viewModel.averageRating))
                Text("(\(viewModel.numRatings) Reviews)")
                Text("|")
                Image(systemName: "dollarsign.circle")
                    .foregroundColor(Styles().themePink)
                Text(viewModel.user.venmo)
            }
            Picker("userType", selection: $viewModel.viewingMode) {
                Text("Buyer").tag(ViewingMode.buyer)
                Text("Seller").tag(ViewingMode.seller)
            }
            .onReceive(viewModel.$viewingMode, perform: { _ in
                viewModel.position = Position.first
                viewModel.getProfileData()
            })
            .pickerStyle(.segmented)
        }
        .ignoresSafeArea()
        .frame(maxWidth: .infinity)
        .opacity(getOpacity())
        .background(.white)
        .padding()
    }
    
    func getOpacity() -> CGFloat {
        let progress = -offset/90
        let opacity = 1-progress
        return offset < 0 ? opacity : 1
    }
    
}

struct ToggleView: View {
    @EnvironmentObject private var viewModel: ProfileVM
    @State var offset: CGFloat = 0
    var maxHeight: CGFloat
    var tabs: [String]
    var selection: Binding<Int> {
        Binding<Int>(
            get: {
                viewModel.position.rawValue
            },
            set: {
                viewModel.getProfileData()
                viewModel.position = Position(rawValue: $0) ?? Position.first
            }
        )
    }
    
    var body: some View {
        VStack {
            SlidingTabView(
                selection: selection,
                tabs: tabs,
                font: .system(size: 20, weight: .medium),
                animation: .easeInOut,
                activeAccentColor: Styles().themePink,
                inactiveAccentColor: .gray,
                selectionBarHeight: 0
            )
            .background(.white)
            .offset(y: getPosition())
            .modifier(OffsetModifier(offset: $offset))
            .zIndex(1)
            Masonry<ProfileVM>()
                .zIndex(0)
        }
        .onAppear {
            viewModel.getProfileData()
        }
        .environmentObject(viewModel)
    }
    
    func getPosition() -> CGFloat {
        return offset < maxHeight ? (80 - offset) : (maxHeight - offset)
    }
    
}



//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileView()
//    }
//}
