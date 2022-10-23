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
            .onTapGesture { hideKeyboard() }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Shared.CancelButton(presentationMode: self.presentationMode)
                }
                ToolbarItem(placement: .principal) {
                    Text("Post An Item")
                        .font(.system(size: 24, weight: .semibold))
                }
            }
            .gesture(
                DragGesture().onEnded { value in
                    if value.location.y - value.startLocation.y > 150 {
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
                Text("Next")
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .buttonStyle(Shared.PinkButton())
            
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
            .buttonStyle(Shared.PinkButton())
            
            Spacer()
        }
        .padding()
        .navigationBarBackButtonHidden(true)
        .environmentObject(viewModel)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Shared.BackButton(presentationMode: self.presentationMode)
            }
            ToolbarItem(placement: .principal) {
                Text("Post An Item")
                    .font(.system(size: 24, weight: .semibold))
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Shared.CancelButton(presentationMode: self.prevPresentationMode)
            }
        }
        .gesture(
            DragGesture().onEnded { value in
                if value.location.y - value.startLocation.y > 150 {
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
