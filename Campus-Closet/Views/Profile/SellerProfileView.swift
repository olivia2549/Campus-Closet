//
//  SellerProfileView.swift
//  Campus-Closet
//
//  Created by Lauren Scott on 12/2/22.
//

import SwiftUI
import SegmentedPicker

// Structure for the overarching view for the screen that shows a seller's profile.
struct SellerProfileView: View {
    @EnvironmentObject private var viewModel: ProfileVM
    @EnvironmentObject var session: OnboardingVM
    @Binding var tabSelection: Int
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var offset: CGFloat = 0
    var maxHeight: CGFloat = (UIDevice.current.userInterfaceIdiom == .phone) ?
    UIScreen.main.bounds.height / 3 : UIScreen.main.bounds.height / 2.4
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 10) {
                GeometryReader{ proxy in
                    SellerProfileInfo(offset: $offset, proxy: proxy)
                        .frame(maxWidth: .infinity)
                        .frame(height: getHeaderHeight(proxy: proxy), alignment: .bottom)
                        .overlay(
                            SellerProfileHeader(
                                presentationMode: presentationMode,
                                offset: $offset,
                                proxy: proxy
                            )
                            ,alignment: .top
                        )
                }
                .frame(height: maxHeight)
                .offset(y: -offset)
                .zIndex(1)
                
                SellerToggleView(tabSelection: $tabSelection, maxHeight: maxHeight, tabs: ["Listings (\(viewModel.user.listings.count))", "Sold (\(viewModel.user.sold.count))"])
                    .zIndex(0)
            }
            .modifier(OffsetModifier(offset: $offset))
        }
        .environmentObject(viewModel)
        .environmentObject(session)
        .coordinateSpace(name: "SCROLL")
        .navigationBarHidden(true)
    }
    
    func getHeaderHeight(proxy: GeometryProxy) -> CGFloat {
        let topHeight = maxHeight + offset
        return topHeight > proxy.size.height*0.15 ? topHeight : proxy.size.height*0.15
    }
    
}

// Structure for the seller's profile header containing their name.
struct SellerProfileHeader: View {
    @EnvironmentObject private var viewModel: ProfileVM
    var presentationMode: Binding<PresentationMode>
    
    @Binding var offset: CGFloat
    var proxy: GeometryProxy
    
    var body: some View {
        HStack {
            Styles.BackButton(presentationMode: presentationMode).padding()
            Text(viewModel.user.name)
                .font(.system(size: 20, weight: .semibold))
                .opacity(getNameOpacity(proxy: proxy))
            Spacer()
        }
        .ignoresSafeArea()
        .frame(height: proxy.size.height * 0.15)
        .frame(maxWidth: .infinity)
        .background(.white)
    }
        
    func getNameOpacity(proxy: GeometryProxy) -> CGFloat {
        let progress = -offset/(maxHeight*0.4)
        return progress
    }
}

// Structure containing information about the seller.
struct SellerProfileInfo: View {
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
                Text("(\(viewModel.numRatings) \(viewModel.numRatings == 1 ? "Rating" : "Ratings"))")
                Text("|")
                Image(systemName: "dollarsign.circle")
                    .foregroundColor(Styles().themePink)
                Text(viewModel.user.venmo)
            }
        }
        .ignoresSafeArea()
        .frame(maxWidth: .infinity)
        .opacity(getOpacity())
        .background(.white)
    }
    
    func getOpacity() -> CGFloat {
        let progress = -offset/60
        let opacity = 1-progress
        return offset < 0 ? opacity : 1
    }
}

// The seller can only be seen as a seller, not as a buyer.
struct SellerToggleView: View {
    @EnvironmentObject var viewModel: ProfileVM
    @EnvironmentObject var session: OnboardingVM
    @State var offset: CGFloat = 0
    @Binding var tabSelection: Int
    var maxHeight: CGFloat
    var tabs: [String]
    var selection: Binding<Data.Index?> {
        Binding(
            get: { viewModel.position.rawValue },
            set: {
                if session.isLoggedIn {
                    viewModel.fetchUser(userID: viewModel.user.id)
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
            Masonry<ProfileVM>(tabSelection: $tabSelection)
                .zIndex(0)
        }
        .environmentObject(session)
        .environmentObject(viewModel)
    }
    
    func getPosition() -> CGFloat {
        return offset < maxHeight ? (80 - offset) : (maxHeight - offset)
    }
}
