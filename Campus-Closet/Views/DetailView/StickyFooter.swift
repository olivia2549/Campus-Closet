//
//  SmallView.swift
//  Campus-Closet
//
//  Created by Olivia Logan on 9/30/22.
//

import SwiftUI
import FirebaseAuth

struct StickyFooter: View {
    @EnvironmentObject private var itemVM: ItemVM
    @StateObject private var postVM = PostVM()
    @Binding var offset: CGFloat
    @Binding var height: CGFloat
    @Binding var scrollHeight: CGFloat
    @State var presentEditScreen = false
    @State var isLoaded = false
    @State var showBidView = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                // Item title and Vandy creator tag
                GeometryReader { proxy in
                    HStack(alignment: .top) {
                        Text(itemVM.item.title)
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.black)
                            .padding(.top, 20)
                        if itemVM.item.studentCreated {
                            Image(systemName: "v.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20)
                                .foregroundStyle(Color("Dark Pink"))
                        }
                    }
                }
                
                Spacer()
                
                // Button at right
                if !itemVM.isSeller {
                    Button(action: {
                        showBidView = true
                        
                        
                    }){
                        Text("Place Bid")
                            .frame(maxWidth: maxWidth*0.3, alignment: .center)
                    }
                    .padding(10)
                    .background(Styles().themePink)
                    .cornerRadius(10)
                    .foregroundColor(.white)
                }
                else {
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
                            EditItem(
                                viewModel: postVM,
                                presentEditScreen: $presentEditScreen
                            )
                            .navigationBarHidden(true)
                            .navigationBarBackButtonHidden(true)
                            .toolbar {
                                ToolbarItem(placement: .navigationBarLeading) {
                                    Styles.BackButton(presentationMode: self.presentationMode)
                                        .foregroundColor(.black)
                                }
                            }
                        }
                        .padding(10)
                        .background(Styles().themePink)
                        .cornerRadius(10)
                        .foregroundColor(.white)
                }
            }
            .padding(.top, 10)
            
            if (itemVM.item.bidPrice != "") {
                Text("Current Bid: $\(itemVM.item.bidPrice)")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundColor(Styles().themePink)
                    .frame(alignment: .leading)
            } else {
                Text("Listed Price (0 bids): $\(itemVM.item.price)")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Styles().themePink)
                    .frame(alignment: .leading)
            }
            
            if !itemVM.isSeller {
                SellerInfo()
            }
            Spacer()
        }
        .onReceive(itemVM.itemPublisher, perform: { item in
            // create a post object for editing once the item is loaded
            postVM.item = item
            postVM.isEditing = true
            isLoaded = true
        })
//        .onReceive(postVM.$item, perform: { item in
//            itemVM.item = item
//        })
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
