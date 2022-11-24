//
//  ProfileView.swift
//  Campus-Closet
//
//  Created by Olivia Logan on 9/29/22.
//

import SwiftUI
import SegmentedPicker

struct ProfileView: View {
    @StateObject private var viewModel = ProfileVM()
    @EnvironmentObject var session: OnboardingVM
    @State var offset: CGFloat = 0
    var maxHeight: CGFloat = (UIDevice.current.userInterfaceIdiom == .phone) ?
    UIScreen.main.bounds.height / 2.6 : UIScreen.main.bounds.height / 2.0
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 10) {
                GeometryReader{ proxy in
                    ProfileInfo(offset: $offset, proxy: proxy)
                        .frame(maxWidth: .infinity)
                        .frame(height: getHeaderHeight(proxy: proxy), alignment: .bottom)
                        .overlay(
                            ProfileHeader(
                                offset: $offset,
                                proxy: proxy
                            )
                            ,alignment: .top
                        )
                }
                .frame(height: maxHeight)
                .offset(y: -offset)
                .zIndex(1)
                
                if viewModel.viewingMode == ViewingMode.buyer {
                    ToggleView(maxHeight: maxHeight, tabs: ["Bids (\(viewModel.user.bids.count))", "Saved (\(viewModel.user.saved.count))"])
                        .zIndex(0)
                }
                else {
                    ToggleView(maxHeight: maxHeight, tabs: ["Listings (\(viewModel.user.listings.count))", "Sold (\(viewModel.user.sold.count))"])
                        .zIndex(0)
                }
            }
            .modifier(OffsetModifier(offset: $offset))
        }
        .environmentObject(viewModel)
        .environmentObject(session)
        .coordinateSpace(name: "SCROLL")
        .onAppear(perform: {
            if session.isLoggedIn {
                viewModel.getProfileData()
            }
        })
        .navigationBarHidden(true)
    }
    
    func getHeaderHeight(proxy: GeometryProxy) -> CGFloat {
        let topHeight = maxHeight + offset
        return topHeight > proxy.size.height*0.15 ? topHeight : proxy.size.height*0.15
    }
    
}

struct ProfileHeader: View {
    @EnvironmentObject private var viewModel: ProfileVM
    @Binding var offset: CGFloat
    var proxy: GeometryProxy
    
    var body: some View {
        HStack {
            Text(viewModel.user.name)
                .font(.system(size: 20, weight: .semibold))
                .frame(maxWidth: .infinity)
                .opacity(getNameOpacity(proxy: proxy))
            VStack(alignment: .center) {
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: proxy.size.width * 0.3)
            }
            .opacity(getOpacity(proxy: proxy))
            .frame(maxWidth: .infinity)
            VStack(alignment: .trailing) {
                NavigationLink(destination: EditProfile().environmentObject(viewModel)) {
                    Image(systemName: "pencil.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: proxy.size.width * 0.06, alignment: .trailing)
                        .padding(.leading, proxy.size.width * 0.06)
                        .foregroundColor(.black)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .ignoresSafeArea()
        .frame(height: proxy.size.height * 0.15)
        .frame(maxWidth: .infinity)
        .background(.white)
    }
    
    func getOpacity(proxy: GeometryProxy) -> CGFloat {
        let progress = -offset/(maxHeight*0.1)
        let opacity = 1-progress
        return offset < 0 ? opacity : 1
    }
    
    func getNameOpacity(proxy: GeometryProxy) -> CGFloat {
        let progress = -offset/(maxHeight*0.6)
        return progress
    }
    
}

struct ProfileInfo: View {
    @EnvironmentObject private var viewModel: ProfileVM
    @EnvironmentObject var session: OnboardingVM
    @Binding var offset: CGFloat
    var proxy: GeometryProxy
    
    var body: some View {
        VStack {
            if (viewModel.profilePicture != nil) {
                Image(uiImage: viewModel.profilePicture!)
                    .resizable()
                    .frame(width: proxy.size.width*0.4, height: proxy.size.width*0.4, alignment: .center)
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
            }
            else {
                Image("blank-profile")
                    .resizable()
                    .frame(width: proxy.size.width*0.4, height: proxy.size.width*0.4, alignment: .center)
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
            }
            Text(viewModel.user.name)
                .font(.system(size: 24, weight: .medium))
            HStack(alignment: .center) {
                Image(systemName: "star.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: proxy.size.width*0.06)
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
                if session.isLoggedIn {
                    viewModel.getProfileData()
                }
            })
            .pickerStyle(.segmented)
        }
        .ignoresSafeArea()
        .frame(maxWidth: .infinity)
        .opacity(getOpacity())
        .background(.white)
    }
    
    func getOpacity() -> CGFloat {
        let progress = -offset/90
        let opacity = 1-progress
        return offset < 0 ? opacity : 1
    }
    
}

struct ToggleView: View {
    @EnvironmentObject var viewModel: ProfileVM
    @EnvironmentObject var session: OnboardingVM
    @State var offset: CGFloat = 0
    var maxHeight: CGFloat
    var tabs: [String]
    var selection: Binding<Data.Index?> {
        Binding(
            get: { viewModel.position.rawValue },
            set: {
                if session.isLoggedIn {
                    viewModel.getProfileData()
                }
                viewModel.position = Position(rawValue: $0!) ?? Position.first
            }
        )
    }
    
    var body: some View {
        VStack {
            SegmentedPicker(
                tabs,
                selectedIndex: selection,
                selectionAlignment: .bottom,
                content: { item, isSelected in
                    HStack {
                        VStack(spacing: 0) {
                            Text(item)
                                .foregroundColor(isSelected ? Styles().themePink : Color.gray )
                                .font(.system(size: 20, weight: .semibold))
                                .padding(.vertical, 8)
                            if !isSelected {
                                Color("Search Bar").frame(height: 1)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                },
                selection: {
                    HStack {
                        VStack(spacing: 0) {
                            Spacer()
                            Styles().themePink.frame(height: 1)
                        }
                    }
                    .frame(maxWidth: .infinity)
                })
                .animation(.easeInOut(duration: 0.3))
            Masonry<ProfileVM>()
                .zIndex(0)
        }
        .onAppear {
            if session.isLoggedIn {
                viewModel.getProfileData()
            }
        }
        .environmentObject(session)
        .environmentObject(viewModel)
    }
    
    func getPosition() -> CGFloat {
        return offset < maxHeight ? (80 - offset) : (maxHeight - offset)
    }
    
}
