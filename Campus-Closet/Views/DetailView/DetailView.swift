//
//  DetailView.swift
//  Campus-Closet
//
//  Created by Hilly Yehoshua on 10/25/22.
//

import SwiftUI
import FirebaseAuth

@MainActor protocol ItemInfoVM: ObservableObject {
    var itemPublisher: Published<Item>.Publisher { get }
    var isEditing: Bool { get set }
    func verifyInfo() -> Bool
    func deleteItem()
    func postItem()
}

let maxWidth = UIScreen.main.bounds.width
let maxHeight = UIScreen.main.bounds.height

struct DetailView<ItemInfo:ItemInfoVM>: View {
    @StateObject private var itemViewModel = ItemVM()
    @ObservedObject var itemInfoVM: ItemInfo
    @State var scrollOffset: CGFloat = 0
    @State var innerHeight: CGFloat = 0
    @State var offset: CGFloat = 0
    @State var scrollHeight: CGFloat = 0
    @State var sellerId = ""
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    ItemImage()
                    DetailDescription()
                    if itemViewModel.isSeller {
                        Text("Bidders").font(.system(size: 16, weight: .semibold))
                        Bidders()
                    }
                }
                .modifier(OffsetModifier(offset: $scrollOffset))
                .modifier(HeightModifier(height: $innerHeight))
                .environmentObject(itemViewModel)
            }
            .modifier(HeightModifier(height: $scrollHeight))
            .coordinateSpace(name: "SCROLL")
            .scrollIndicators(.hidden)
            .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 15)
            .padding(.bottom, itemViewModel.isSeller ? maxHeight*0.1 : maxHeight*0.18)
            
            VStack(spacing: 0) {
                Spacer()
                StickyFooter(
                    offset: $scrollOffset,
                    height: $innerHeight,
                    scrollHeight: $scrollHeight
                )
            }
        }
        .onReceive(itemInfoVM.itemPublisher, perform: { item in
            itemViewModel.fetchItem(with: item.id) {}
        })
        .environmentObject(itemViewModel)
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

struct Bidders: View {
    @EnvironmentObject private var itemViewModel: ItemVM

    var body: some View {
        LazyVStack {
            ForEach(itemViewModel.item.bidders, id: \.self) { userID in
                BiddersInfo(userId: userID)
                    .environmentObject(itemViewModel)
            }
        }
        .padding()
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
    @StateObject private var profileViewModel = ProfileVM()
    @EnvironmentObject private var itemViewModel: ItemVM
    @State var sellerId = ""
    
    var body: some View {
        VStack (alignment: .leading, spacing: 0) {
            HStack(alignment: .center) {
                if (profileViewModel.profilePicture != nil) {
                    Image (uiImage: profileViewModel.profilePicture!)
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
                    Text(profileViewModel.user.name)
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
                        Text ("\(String(format: "%.2f", profileViewModel.averageRating)) (\(profileViewModel.numRatings) Reviews)")
                            .font(.system(size: 12))
                    }
                }
                Spacer()
                
                if (itemViewModel.isSeller) {
                    Button(action: {
                        itemViewModel.sellItem()
                        profileViewModel.sellItem(with: itemViewModel.item.id)
                    }) {
                        Text("Accept")
                            .frame(maxWidth: maxWidth*0.3, alignment: .center)
                    }
                    .buttonStyle(Styles.PinkButton())
                }
                else {
                    NavigationLink(destination: Chat_Message(partnerId: sellerId)) {
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
            sellerId = item.sellerId
            profileViewModel.fetchUser(userID: item.sellerId)
        })
    }
}

struct BiddersInfo: View {
    @StateObject private var profileViewModel = ProfileVM()
    @EnvironmentObject private var itemViewModel: ItemVM
    var userId: String
    
    var body: some View {
        VStack (alignment: .leading, spacing: 0) {
            HStack(alignment: .center) {
                if (profileViewModel.profilePicture != nil) {
                    Image (uiImage: profileViewModel.profilePicture!)
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
                    Text(profileViewModel.user.name)
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
                        Text ("\(String(format: "%.2f", profileViewModel.averageRating)) (\(profileViewModel.numRatings) Reviews)")
                            .font(.system(size: 12))
                    }
                }
                Spacer()
                
                if (itemViewModel.isSeller) {
                    Button(action: {
                        itemViewModel.sellItem()
                        profileViewModel.sellItem(with: itemViewModel.item.id)
                    }) {
                        Text("Accept")
                            .frame(maxWidth: maxWidth*0.3, alignment: .center)
                    }
                    .buttonStyle(Styles.PinkButton())
                }
                else {
                    NavigationLink(destination: Chat_Message(partnerId: userId)) {
                        Image(systemName: "ellipsis.message.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                            .foregroundColor(Color("Dark Pink"))
                    }
                }
            }
        }
        .onAppear {
            profileViewModel.fetchUser(userID: userId)
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
