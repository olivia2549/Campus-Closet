//
//  DetailView.swift
//  Campus-Closet
//
//  Created by Hilly Yehoshua on 10/25/22.
//

import SwiftUI
import FirebaseAuth

@MainActor protocol ItemInfoVM: ObservableObject {
    var item: Item { get set }
    var isEditing: Bool { get set }
    func verifyInfo() -> Bool
    func deleteItem()
    func postItem()
}

let maxWidth = UIScreen.main.bounds.width
let maxHeight = UIScreen.main.bounds.height

struct DetailView: View {
    @StateObject private var itemViewModel = ItemVM()
    @StateObject private var profileViewModel = ProfileVM()
    @State var scrollOffset: CGFloat = 0
    @State var innerHeight: CGFloat = 0
    @State var offset: CGFloat = 0
    @State var scrollHeight: CGFloat = 0
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var id: String
    init(for id: String) {
        self.id = id
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    ItemImage()
                    DetailDescription()
                }
                .modifier(OffsetModifier(offset: $scrollOffset))
                .modifier(HeightModifier(height: $innerHeight))
            }
            .modifier(HeightModifier(height: $scrollHeight))
            .coordinateSpace(name: "SCROLL")
            .scrollIndicators(.hidden)
            .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 15)
            .padding(.bottom, itemViewModel.isSeller ? maxHeight*0.1 : maxHeight*0.18)
            
            VStack(spacing: 0) {
                Spacer()
                StickyFooter(offset: $scrollOffset, height: $innerHeight, scrollHeight: $scrollHeight)
            }
        }
        .ignoresSafeArea(.all, edges: .bottom)
        .environmentObject(itemViewModel)
        .environmentObject(profileViewModel)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            itemViewModel.fetchItem(with: id)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Styles.BackButton(presentationMode: self.presentationMode)
                    .foregroundColor(.white)
            }
        }

    }
}

struct ItemImage: View {
    @EnvironmentObject private var itemViewModel: ItemVM
    
    var body: some View {
        if (itemViewModel.itemImage != nil) {
            Image(uiImage: itemViewModel.itemImage!)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .cornerRadius(20, corners: [.topLeft, .topRight])
                .overlay(alignment: .topTrailing){
                    if !itemViewModel.isSeller {
                        Button(action: {
                            itemViewModel.isSaved ? itemViewModel.unsaveItem() : itemViewModel.saveItem()
                        }){
                            itemViewModel.isSaved ?
                                Image(systemName: "heart")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 30)
                                    .foregroundStyle(Color("Dark Pink"))
                            : Image(systemName: "heart.fill")
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

struct Seller: View {
    @EnvironmentObject private var itemViewModel: ItemVM
    @EnvironmentObject private var profileViewModel: ProfileVM

    var body: some View {
        VStack {
            // Show seller
            if !itemViewModel.isSeller && itemViewModel.item.sellerId != "" {
                SellerInfo()
                    .onAppear {
                        profileViewModel.fetchUser(userID: itemViewModel.item.sellerId)
                    }
            }
        }
    }
}

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

struct SellerInfo: View {
    @EnvironmentObject private var viewModel: ProfileVM
    
    var body: some View {
        VStack (alignment: .leading, spacing: 0) {
            HStack(alignment: .center) {
                if (viewModel.profilePicture != nil) {
                    Image (uiImage: viewModel.profilePicture!)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .cornerRadius(50)
                }
                else {
                    Circle()
                        .frame(width: 50, height: 50)
                        .foregroundColor(Color("LightGrey"))
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    Text(viewModel.user.name)
                        .font(.system(size: 18))
                    Text("@\(viewModel.user.venmo)")
                        .foregroundColor(Color("Dark Gray"))
                        .font(.system(size: 14))
                    HStack (spacing: 2){
                        Image(systemName: "star.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 15, height: 15)
                            .foregroundColor(Color("Dark Pink"))
                        Text ("\(String(format: "%.2f", viewModel.averageRating)) (\(viewModel.numRatings) Reviews)")
                            .font(.system(size: 12))
                    }
                }
                Spacer()
                
                NavigationLink(destination: Chat_Message()) {
                    Image(systemName: "ellipsis.message.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                        .foregroundColor(Color("Dark Pink"))
                }
            }
        }
    }
}

struct ButtonRow: View {
    var body: some View{
        VStack (alignment: .leading){
            HStack { //fit to text
                Button(action: {
                    print("Tag")
                }){
                    Text("Sweater")
                        .frame(minWidth: 0, maxWidth: 100)
                        .font(.system(size: 18))
                        .padding()
                        .foregroundColor(.white)
                        .overlay (
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.white, lineWidth: 24)
                        )
                }
                .background(Color("Dark Gray"))
                .cornerRadius(25)
                
                Button(action: {
                    print("Condition")
                }){
                    Text("New")
                        .frame(minWidth: 0, maxWidth: 50)
                        .font(.system(size: 18))
                        .padding()
                        .foregroundColor(.white)
                        .overlay (
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.white, lineWidth:24)
                        )
                }
                .background(Color("Dark Gray"))
                .cornerRadius(25)
            }
        }
    }
}
