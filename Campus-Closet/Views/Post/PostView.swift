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
                ChoosePicture(presentationMode: presentationMode)
            }
            .onTapGesture { hideKeyboard() }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Styles.CancelButton(presentationMode: self.presentationMode)
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

struct ChoosePicture: View {
    @EnvironmentObject private var viewModel: PostVM
    var presentationMode: Binding<PresentationMode>
    @State var pickerShowing = false
    @State var chosenPicture: UIImage?
    @State private var presentInfoScreen: Bool = false
    
    init(presentationMode: Binding<PresentationMode>) {
        self.presentationMode = presentationMode
    }
    
    var body: some View {
        VStack {
            if chosenPicture != nil {
                Image(uiImage: chosenPicture!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
            }
            
            Button(action: {
                pickerShowing = true
            }){
                Image(systemName: ("square.and.arrow.up"))
                    .resizable()
                    .frame(width: 80, height:100, alignment: .center)
                
                Text(chosenPicture == nil ? "Choose a Picture" : "Change Picture")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .font(Font.system(size: chosenPicture == nil ? 20 : 16, weight: .semibold))
            }
            .buttonStyle(Styles.PinkTextButton())
            
            if chosenPicture != nil {
                NavigationLink(destination: BasicInfo<PostVM>(presentationMode: presentationMode), isActive: $presentInfoScreen) {
                    Text("Next")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .onTapGesture {
                            viewModel.chosenPicture = chosenPicture
                            self.presentInfoScreen = true
                        }
                }
                .buttonStyle(Styles.PinkButton())
            }
        }
        .sheet(isPresented: $pickerShowing, onDismiss: nil, content: {
            viewModel.choosePicture(chosenPicture: $chosenPicture, pickerShowing: $pickerShowing)
        })
    }
}

struct BasicInfo<ViewModel>: View where ViewModel: ItemInfoVM {
    @EnvironmentObject private var viewModel: ViewModel
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
                for: "Condition*",
                imageName: "clock",
                autocapitalization: .never,
                input: $viewModel.item.condition
            ) {
                
            }
            
            CustomInput(
                for: "Description",
                imageName: "pencil",
                autocapitalization: .sentences,
                input: $viewModel.item.description
            ) {
                
            }
            
            if viewModel.isEditing {
                Button(action: {
                    viewModel.postItem()
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Done")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .buttonStyle(Styles.PinkButton())
            }
            else {
                NavigationLink(destination: OptionalInfo(prevPresentationMode: presentationMode)) {
                    Text("Next")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .buttonStyle(Styles.PinkButton())
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
            VStack(alignment: .leading) {
                Text("Help buyers find your item")
                    .font(.system(size: 20, weight: .semibold))
                TagPicker<PostVM>(menuText: "Add Tag")
                TagsList<PostVM>()
            }
            
            Text("Options")
                .font(.system(size: 20, weight: .semibold))
                .padding(.top)
            
            Toggle("Allow Bidding", isOn: $viewModel.item.biddingEnabled)
                .padding(.trailing, 200)
            
            Toggle("Make Post Anonymous", isOn: $viewModel.sellerIsAnonymous)
                .padding(.trailing, 200)
            
            Button(action: {
                viewModel.postItem()
                self.prevPresentationMode.wrappedValue.dismiss()
            }) {
                Text("Post Item!")
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .buttonStyle(Styles.PinkButton())
            
            Spacer()
        }
        .padding()
        .navigationBarBackButtonHidden(true)
        .environmentObject(viewModel)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Styles.BackButton(presentationMode: self.presentationMode)
            }
            ToolbarItem(placement: .principal) {
                Text("Post An Item")
                    .font(.system(size: 24, weight: .semibold))
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Styles.CancelButton(presentationMode: self.prevPresentationMode)
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

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView()
    }
}
