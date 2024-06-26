//
//  DetailView.swift
//  Campus-Closet
//
//  Created by Hilly Yehoshua on 10/25/22.
//

import SwiftUI
import FirebaseAuth

let maxWidth = UIScreen.main.bounds.width
let maxHeight = UIScreen.main.bounds.height

// Structure for an item's detail view page.
struct DetailView: View {
    @EnvironmentObject private var itemVM: ItemVM
    @EnvironmentObject var session: OnboardingVM
    @StateObject private var profileViewModel = ProfileVM()
    @State var scrollOffset: CGFloat = 0
    @State var innerHeight: CGFloat = 0
    @State var offset: CGFloat = 0
    @State var scrollHeight: CGFloat = 0
    @Binding var tabSelection: Int
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    ItemImage()
                    DetailDescription()
                    if !session.isGuest && !itemVM.item.isSold {
                        VStack(alignment: .leading) {
                            if itemVM.isSeller {
                                Text("Bidders").font(.system(size: 16, weight: .semibold))
                                Bids(itemId: itemVM.item.id, tabSelection: $tabSelection, isAnonymous: false, presentationMode: presentationMode)
                            }
                            else {
                                Text("Recent Activity").font(.system(size: 16, weight: .semibold))
                                Bids(itemId: itemVM.item.id, tabSelection: $tabSelection, isAnonymous: true, presentationMode: presentationMode)
                            }
                        }
                        .padding()
                    }
                }
                .modifier(OffsetModifier(offset: $scrollOffset))
                .modifier(HeightModifier(height: $innerHeight))
            }
            .modifier(HeightModifier(height: $scrollHeight))
            .coordinateSpace(name: "SCROLL")
            .scrollIndicators(.hidden)
            .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 15)
            .padding(.bottom, itemVM.isSeller ? maxHeight*0.1 : maxHeight*0.18)
            
            VStack(spacing: 0) {
                Spacer()
                StickyFooter(
                    offset: $scrollOffset,
                    height: $innerHeight,
                    scrollHeight: $scrollHeight,
                    tabSelection: $tabSelection
                )
            }
        }
        .onAppear {
            itemVM.fetchSeller(for: itemVM.item.id, curUser: session.currentUser) {}
        }
        .environmentObject(itemVM)
        .environmentObject(session)
        .environmentObject(profileViewModel)
        .ignoresSafeArea(.all, edges: .bottom)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Styles.BackButton(presentationMode: self.presentationMode)
                    .foregroundColor(.white)
            }
        }
    }
}

// Structure for an item's image and corresponding icons.
struct ItemImage: View {
    @EnvironmentObject private var itemViewModel: ItemVM
    @EnvironmentObject var session: OnboardingVM
    
    var body: some View {
        if (itemViewModel.itemImage != nil) {
            Image(uiImage: itemViewModel.itemImage!)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .cornerRadius(20, corners: [.topLeft, .topRight])
                .overlay(alignment: .topTrailing){
                    if !session.isGuest && !itemViewModel.isSeller && !itemViewModel.isBidder {
                        Button(action: {
                            itemViewModel.isSaved ? itemViewModel.unsaveItem() : itemViewModel.saveItem()
                        }){
                            itemViewModel.isSaved ?
                            Image(systemName: "heart.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30)
                                .foregroundStyle(Color("Dark Pink"))
                            :
                            Image(systemName: "heart")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30)
                                .foregroundStyle(Color("Dark Pink"))
                        }.offset(x: -maxWidth*0.03, y: maxWidth*0.02)
                    }
                }
        }
        else {
            Rectangle()
                .frame(height: maxHeight*0.3)
                .cornerRadius(20, corners: [.topLeft, .topRight])
                .foregroundColor(Color("LightGrey"))
        }
    }
}

// Structure to display item details.
struct DetailDescription: View {
    @EnvironmentObject private var viewModel: ItemVM
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if (viewModel.item.description != "") {
                Text(viewModel.item.description)
            }
            Text(viewModel.item.condition)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Styles().themePink)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
    }
}

// Structure that contains information about the item's seller.
struct SellerInfo: View {
    @EnvironmentObject private var profileViewModel: ProfileVM
    @EnvironmentObject private var itemViewModel: ItemVM
    @EnvironmentObject var session: OnboardingVM
    @Binding var tabSelection: Int
    @State var sellerId = ""
    @State var showRatingView = false
    
    var body: some View {
        VStack (alignment: .leading, spacing: 0) {
            HStack(alignment: .center) {
                NavigationLink(destination: SellerProfileView(tabSelection: $tabSelection).environmentObject(profileViewModel)) {
                    if (profileViewModel.profilePicture != nil) {
                        Image (uiImage: profileViewModel.profilePicture!)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 50, height: 50)
                            .cornerRadius(50)
                    }
                    else {
                        Image("blank-profile")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 50, height: 50)
                            .cornerRadius(50)
                    }
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text(profileViewModel.user.name)
                            .foregroundColor(.black)
                            .font(.system(size: 18))
                        Text("@\(profileViewModel.user.venmo)")
                            .foregroundColor(Color("Dark Gray"))
                            .font(.system(size: 14))
                        HStack (spacing: 2){
                            Image(systemName: "star.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 15, height: 15)
                                .foregroundColor(Color("Dark Pink"))
                            Text ("\(String(format: "%.2f", profileViewModel.averageRating)) (\(profileViewModel.numRatings) \(profileViewModel.numRatings == 1 ? "Rating" : "Ratings"))")
                                .foregroundColor(.black)
                                .font(.system(size: 12))
                        }
                    }
                }
                Spacer()
                
                if !session.isGuest {
                    Button(action: {
                        showRatingView = true
                    }){
                        Image(systemName: "star")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                            .foregroundColor(Color("Dark Pink"))
                    }
                    NavigationLink(destination: Chat_Message(partnerId: sellerId).environmentObject(session).environmentObject(MessagesVM())) {
                        Image(systemName: "ellipsis.message.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                            .foregroundColor(Color("Dark Pink"))
                    }
                }
            }
        }
        .onReceive(itemViewModel.$item, perform: { item in
            if (session.isLoggedIn) {
                sellerId = item.sellerId
                profileViewModel.fetchUser(userID: item.sellerId)
            }
        })
        .sheet(isPresented: $showRatingView) {
            RatingView(sellerID: $itemViewModel.item.sellerId, showRatingView: $showRatingView)
                .environmentObject(profileViewModel)
        }
    }
}
