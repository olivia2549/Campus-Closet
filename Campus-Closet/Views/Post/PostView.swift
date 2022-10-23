//
//  PostView.swift
//  Campus-Closet
//
//  Created by Olivia Logan on 9/29/22.
//

import SwiftUI

struct PostView: View {
    @StateObject private var postVM = PostVM()
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            VStack {
                BasicInfo(presentationMode: presentationMode)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        ZStack(alignment: .center) {
                            Circle()
                                .strokeBorder()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.gray)
                            Text("x")
                                .font(.system(size: 20, weight: .light))
                                .foregroundColor(.black)
                        }
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text("Post An Item")
                        .font(.system(size: 24, weight: .semibold))
                }
            }
            .gesture(
                DragGesture().onEnded { value in
                    if value.location.y - value.startLocation.y > 150 {
                        /// Use presentationMode.wrappedValue.dismiss() for iOS 14 and below
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
            )
        }
        .environmentObject(postVM)
    }
}

struct BasicInfo: View {
    @EnvironmentObject private var viewModel: PostVM
    var presentationMode: Binding<PresentationMode>
    
    init(presentationMode: Binding<PresentationMode>) {
        self.presentationMode = presentationMode
    }

    var body: some View {
        VStack(alignment: .leading) {
            CustomInput(
                for: "Item Name*",
                imageName: "tshirt",
                autocapitalization: .sentences,
                input: $viewModel.item.title
            ) {
                
            }
            
            CustomInput(
                for: "Price*",
                imageName: "dollarsign.circle",
                autocapitalization: .never,
                input: $viewModel.item.price
            ) {
                
            }
            
            CustomInput(
                for: "Size*",
                imageName: "ruler",
                autocapitalization: .never,
                input: $viewModel.item.size
            ) {
                
            }
            
            CustomInput(
                for: "Description",
                imageName: "pencil",
                autocapitalization: .sentences,
                input: $viewModel.item.description
            ) {
                
            }
            
            NavigationLink(destination: OptionalInfo(prevPresentationMode: presentationMode)) {
                HStack {
                    Text("Next")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding(10)
                .background(Color("Dark Pink"))
                .cornerRadius(10)
                .foregroundColor(.white)
            }
            
            Spacer()
        }
        .padding()
    }
    
}

struct OptionalInfo: View {
    @EnvironmentObject private var viewModel: PostVM
    var prevPresentationMode: Binding<PresentationMode>
    init(prevPresentationMode: Binding<PresentationMode>) {
        self.prevPresentationMode = prevPresentationMode
    }
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            TagsList()
            TagPicker()
            
            Text("Options")
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
        .navigationBarBackButtonHidden(true)
        .environmentObject(viewModel)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    ZStack {
                        Circle()
                            .strokeBorder()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.gray)
                        Image(systemName: "arrow.backward")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 15, height: 15)
                            .foregroundColor(.black)
                    }
                }
            }
            ToolbarItem(placement: .principal) {
                Text("Post An Item")
                    .font(.system(size: 24, weight: .semibold))
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    self.prevPresentationMode.wrappedValue.dismiss()
                }) {
                    ZStack(alignment: .center) {
                        Circle()
                            .strokeBorder()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.gray)
                        Text("x")
                            .font(.system(size: 20, weight: .light))
                            .foregroundColor(.black)
                    }
                }
            }
        }
        .gesture(
            DragGesture().onEnded { value in
                if value.location.y - value.startLocation.y > 150 {
                    /// Use presentationMode.wrappedValue.dismiss() for iOS 14 and below
                    self.prevPresentationMode.wrappedValue.dismiss()
                }
            }
        )
    }
}

struct TagPicker: View {
    @EnvironmentObject private var viewModel: PostVM
    @State private var shouldShowDropdown = false

    var body: some View {
        VStack(alignment: .leading) {
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
