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
    func postItem()
}

struct DetailView: View {
    @StateObject private var itemViewModel = ItemVM()
    @StateObject private var profileViewModel = ProfileVM()
    
    var id: String
    init(for id: String) {
        self.id = id
    }
    var body: some View {
        VStack (spacing: 0){
            HeaderDetail()
            ScrollView {
                VStack (alignment: .leading, spacing: 0){
                    DetailItemView()
                    Spacer()
                    
                    DetailDescription()
                    Spacer()
                    
                    if !itemViewModel.isSeller {
                        Divider()
                            .frame(height: 1)
                            .overlay(Color("Dark Gray"))
                        
                        if itemViewModel.item.sellerId != "" {
                            SellerInfo()
                                .onAppear {
                                    profileViewModel.fetchUser(userID: itemViewModel.item.sellerId)
                                }
                        }
                        
                        Button(action: {
                            print("Place Bid")
                        }){
                            Text("Place Bid")
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .font(.system(size: 18))
                                .padding()
                                .foregroundColor(.white)
                                .overlay (
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(Color.white, lineWidth:15)
                                )
                        }
                        .background(Color("Dark Pink"))
                        .cornerRadius(25)
                    }
                    else {
                        NavigationLink(destination: EditItem().environmentObject(itemViewModel)) {
                            Text("Edit Item")
                        }
                        .buttonStyle(Styles.PinkButton())
                    }
                }
            }
            .environmentObject(itemViewModel)
            .environmentObject(profileViewModel)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .onAppear {
            itemViewModel.fetchItem(with: id)
        }
    }
}

struct HeaderDetail: View{
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View{
        VStack(spacing: 0) {
            HStack {
                Styles.BackButton(presentationMode: self.presentationMode)
                Spacer()
                Spacer().frame(maxWidth: 10)
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 50, alignment: .leading)
                Spacer()
                Image(systemName: "heart")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25)
                    .padding(7)
                Image(systemName: "bell")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25)
            }
            .padding(.leading)
            .padding(.trailing)
        }
    }
}

struct ButtonRow: View{
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

struct DetailDescription: View{
    @EnvironmentObject private var viewModel: ItemVM
    var body: some View {
        VStack(alignment: .leading) {
            Text("Details")
                .underline()
                .font(.system(size: 18))
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(viewModel.item.description ?? "")
            Spacer()
        }
        .padding()
    }
}

struct SellerInfo: View {
    @EnvironmentObject private var viewModel: ProfileVM
    
    var body: some View {
        VStack (alignment: .leading, spacing: 0) {
            HStack{
                if (viewModel.profilePicture != nil) {
                    Image (uiImage: viewModel.profilePicture!)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .cornerRadius(50)
                        .padding(EdgeInsets(top: 15, leading: 20, bottom: 0, trailing: 0))
                }
                
                VStack(spacing: 0) {
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
                    Image (systemName: "ellipsis.message.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                        .foregroundColor(Color("Dark Pink"))
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 30))
                }
            }
        }
    }
}
