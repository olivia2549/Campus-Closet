//
//  SmallView.swift
//  Campus-Closet
//
//  Created by Olivia Logan on 9/30/22.
//

import SwiftUI
import FirebaseAuth

// Structure for a footer that persists at the bottom of the item detail page.
struct StickyFooter: View {
    @EnvironmentObject private var itemVM: ItemVM
    @EnvironmentObject var session: OnboardingVM
    @EnvironmentObject private var profileVM: ProfileVM
    @StateObject private var postVM = PostVM()
    @Binding var offset: CGFloat
    @Binding var height: CGFloat
    @Binding var scrollHeight: CGFloat
    @Binding var tabSelection: Int
    @State var presentEditScreen = false
    @State var isLoaded = false
    @State var showBidView = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                // Item title and Vandy creator tag.
                GeometryReader { proxy in
                    VStack(alignment: .leading) {
                        // Name of item.
                        HStack(alignment: .top) {
                            Text(itemVM.item.title)
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundColor(.black)
                            if itemVM.item.studentCreated { // Student created logo.
                                Image(systemName: "v.circle.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 20)
                                    .foregroundStyle(Color("Dark Pink"))
                            }
                        }
                        // Listed price.
                        Text(String(format: "Listed Price: $%.2f", itemVM.item.price))
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(Styles().darkGray)
                            .frame(alignment: .leading)
                    }
                }
                
                Spacer()
                
                // Button at right.
                if !session.isGuest && !itemVM.item.isSold {
                    if !itemVM.isSeller && !itemVM.isBidder {
                        Button(action: {
                            showBidView = true
                            presentationMode.wrappedValue.dismiss()
                            tabSelection = 2
                        }){
                            Text("Place Bid")
                                .frame(maxWidth: maxWidth*0.3, alignment: .center)
                        }
                        .padding(10)
                        .background(Styles().themePink)
                        .cornerRadius(10)
                        .foregroundColor(.white)
                    }
                    else if itemVM.isBidder {
                        Button(action: {
                            itemVM.removeBid()
                            presentationMode.wrappedValue.dismiss()
                        }){
                            Text("Remove Bid")
                                .frame(maxWidth: maxWidth*0.3, alignment: .center)
                        }
                        .padding(10)
                        .background(Styles().themePink)
                        .cornerRadius(10)
                        .foregroundColor(.white)
                    }
                    else {
                        // is the seller
                        Text("Edit Item")
                            .frame(maxWidth: maxWidth*0.3, alignment: .center)
                            .onTapGesture {
                                if (isLoaded) {
                                    self.presentEditScreen = true
                                    isLoaded = false
                                }
                            }
                            .sheet(isPresented: $presentEditScreen, onDismiss: {
                                self.presentationMode.wrappedValue.dismiss()
                            }) {
                                BasicInfo(viewModel: postVM, showDeleteConfirmation: false, tabSelection: $tabSelection, presentationMode: presentationMode, prevPresentationMode: presentationMode)
                                    .environmentObject(session)
                            }
                            .padding(10)
                            .background(Styles().themePink)
                            .cornerRadius(10)
                            .foregroundColor(.white)
                    }
                }
            }
            .padding(.top, 10)
            
            if !itemVM.isSeller {
                SellerInfo(tabSelection: $tabSelection)
            }
            Spacer()
        }
        .onReceive(itemVM.itemPublisher, perform: { item in
            // create a post object for editing once the item is loaded
            postVM.item = item
            postVM.isEditing = true
            postVM.chosenPrice = String(itemVM.item.price)
            isLoaded = true
        })
        .frame(height: itemVM.isSeller ? maxHeight*0.1 : maxHeight*0.18)
        .padding(EdgeInsets(
            top: 0,
            leading: 15,
            bottom: UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 30,
            trailing: 15)
        )
        .if(offset >= scrollHeight - height + 1) { view in
            view.background(Color.white.shadow(radius: 10).mask(Rectangle().padding(.top, -20)))
        }
        .if(offset < height - scrollHeight + 1) { view in
            view.background(Color.white)
        }
        .sheet(isPresented: $showBidView) {
            BidItem(showBidView: $showBidView)
                .environmentObject(itemVM)
        }
    }
}
