//
//  PostView.swift
//  Campus-Closet
//
//  Created by Olivia Logan on 9/29/22.
//

import SwiftUI

struct PostView: View {
    @StateObject private var postVM = PostVM()
    
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Color("Dark Pink"))
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        NavigationView {
            VStack {
                BasicInfo()
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Post An Item")
                        .font(.system(size: 32, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.top, 50)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: OptionalInfo()) {
                        Text("Next")
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .environmentObject(postVM)
    }
}

struct BasicInfo: View {
    @EnvironmentObject private var viewModel: PostVM

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            CustomInput(
                for: "Title*",
                autocapitalization: .sentences,
                input: $viewModel.item.title
            ) {
                
            }
            
            CustomInput(
                for: "Price*",
                autocapitalization: .never,
                input: $viewModel.item.price
            ) {
                
            }
            
            CustomInput(
                for: "Size*",
                autocapitalization: .never,
                input: $viewModel.item.size
            ) {
                
            }
            
            CustomInput(
                for: "Description",
                autocapitalization: .sentences,
                input: $viewModel.item.description
            ) {
                
            }
            
            Spacer()
        }
    }
    
}

struct OptionalInfo: View {
    @EnvironmentObject private var viewModel: PostVM
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            TagsList()
            TagPicker()
            
            Text("Settings")
                .font(.system(size: 20, weight: .semibold))
                .padding(.top)
            
            Toggle("Allow Bidding", isOn: $viewModel.item.biddingEnabled)
                .padding(.trailing, 200)
            
            Toggle("Make Post Anonymous", isOn: $viewModel.sellerIsAnonymous)
                .padding(.trailing, 200)
            
            Button(action: {viewModel.postItem()}) {
                Text("Post Item!")
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding(10)
            .background(Color("Dark Pink"))
            .cornerRadius(10)
            .padding(.top)
            .foregroundColor(.white)
            
            Spacer()
        }
        .padding()
        .environmentObject(viewModel)
    }
}

struct TagPicker: View {
    @EnvironmentObject private var viewModel: PostVM
    @State private var shouldShowDropdown = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Help buyers find your item")
                .font(.system(size: 20, weight: .semibold))
            Menu {
                ForEach(viewModel.tagsLeft.sorted(by: >), id: \.key) { key, value in
                    if (value == 1) {
                        Button(
                            action: { viewModel.addTag(for: key) },
                            label: { Text(key) }
                        )
                    }
                }
            } label: {
                HStack {
                    Text("Choose a tag").foregroundColor(.gray)
                    Image(systemName: self.shouldShowDropdown ? "arrowtriangle.up" : "arrowtriangle.down")
                        .resizable()
                        .frame(width: 9, height: 5)
                        .font(Font.system(size: 9, weight: .medium))
                        .foregroundColor(.gray)
                    Spacer()
                }
            } .onTapGesture {
                self.shouldShowDropdown.toggle()
            }
        }
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView()
    }
}
