//
//  PostView.swift
//  Campus-Closet
//
//  Created by Olivia Logan on 9/29/22.
//

import SwiftUI

struct PostView: View {
    @StateObject private var postVM = PostVM()
    @EnvironmentObject var session: OnboardingVM
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationStack {
            VStack {
                ChoosePicture(presentationMode: presentationMode)
            }
            .onTapGesture { hideKeyboard() }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Post An Item")
                        .font(.system(size: 24, weight: .semibold))
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Styles.CancelButton(presentationMode: self.presentationMode)
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
        .environmentObject(session)
    }
}

struct ChoosePicture: View {
    @EnvironmentObject private var viewModel: PostVM
    @EnvironmentObject var session: OnboardingVM
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
                NavigationLink(destination: BasicInfo(viewModel: viewModel, presentationMode: presentationMode, prevPresentationMode: presentationMode), isActive: $presentInfoScreen) {
                    Text("Next")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .onTapGesture {
                            self.presentInfoScreen = true
                        }
                }
                .buttonStyle(Styles.PinkButton())
            }
        }
        .sheet(isPresented: $pickerShowing, onDismiss: nil, content: {
            viewModel.choosePicture(chosenPicture: $chosenPicture, pickerShowing: $pickerShowing)
        })
        .onChange(of: chosenPicture) { newPicture in
            viewModel.chosenPicture = newPicture
        }
        .environmentObject(session)
    }
}

struct BasicInfo: View {
    @ObservedObject var viewModel: PostVM
    @EnvironmentObject var session: OnboardingVM
    @State private var isMissingRequiredInfo: Bool = false
    @State var showDeleteConfirmation = false
    var presentationMode: Binding<PresentationMode>
    var prevPresentationMode: Binding<PresentationMode>
    
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
                input: $viewModel.chosenPrice
            ) {

            }

            CustomInput(
                for: "Size*",
                imageName: "ruler",
                autocapitalization: .never,
                input: $viewModel.item.size
            ) {

            }

            VStack (alignment: .leading, spacing: 0){
                Menu {
                    Button {
                        viewModel.item.condition = "New"
                        // do something
                    } label: {
                        Text("New")
                    }
                    Button {
                        viewModel.item.condition = "Lightly Used"
                        // do something
                    } label: {
                        Text("Lightly Used")
                    }
                    Button {
                        viewModel.item.condition = "Used"
                        // do something
                    } label: {
                        Text("Used")
                    }
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color("#d7d7d8"), lineWidth: 1)
                            .frame(width: 395, height: 55)
                        HStack{
                            Image(systemName: "clock")
                                .foregroundColor(.black)
                                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                            Divider()
                                .frame(height: 25)
                            viewModel.item.condition == "" ?
                                Text("Condition*")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 20))
                                :
                                Text("\(viewModel.item.condition)")
                                    .foregroundColor(.black)
                                    .font(.system(size: 20))
                            Spacer()
                        }
                    }
                }.padding(.bottom)
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
                    if viewModel.verifyInfo() {
                        viewModel.updateItem { self.presentationMode.wrappedValue.dismiss() }
                    }
                    else {
                        isMissingRequiredInfo = true
                    }
                }) {
                    Text("Done")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .buttonStyle(Styles.PinkButton())
                
                Button(action: {
                    showDeleteConfirmation = true
                }) {
                    Text("Delete Item")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .buttonStyle(Styles.PinkButton())
            }
            else {
                NavigationLink(destination: OptionalInfo(prevPresentationMode: presentationMode)) {
                    Text("Next")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .disabled(!viewModel.verifyInfo())
                .onTapGesture {
                    isMissingRequiredInfo = true
                }
                .buttonStyle(Styles.PinkButton())
            }
            
            if isMissingRequiredInfo {
                Text("Please enter valid information for all required fields.")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .multilineTextAlignment(.center)
                    .padding(EdgeInsets(top: 10, leading: 5, bottom: 20, trailing: 5))
                    .font(Font.system(size: 16, weight: .semibold))
                    .foregroundColor(Styles().themePink)
            }
            Spacer()
        }
        .environmentObject(session)
        .navigationBarBackButtonHidden(true)
        .padding()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Styles.BackButton(presentationMode: self.presentationMode)
            }
        }
        .alert(isPresented: $showDeleteConfirmation) {
            Alert(title: Text("Confirm Deletion"),
                  message: Text("Are you sure you want to remove this item? This action cannot be undone"),
                  primaryButton: .destructive(Text("Delete"), action: {
                    viewModel.deleteItem()
                    self.prevPresentationMode.wrappedValue.dismiss()
                  }),
                  secondaryButton: .cancel())
        }
    }
    
}

struct OptionalInfo: View {
    @State var navigateToDetail = false
    @EnvironmentObject private var postVM: PostVM
    @EnvironmentObject var session: OnboardingVM
    @StateObject var itemVM = ItemVM()
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
            
            Text("Promote Vanderbilt creators")
                .font(.system(size: 20, weight: .semibold))
            Toggle("Was this item created by a student?", isOn: $postVM.item.studentCreated)
            
            Text("Options")
                .font(.system(size: 20, weight: .semibold))
                .padding(.top)
            
            Toggle("Allow Bidding", isOn: $postVM.item.biddingEnabled)
            
            Toggle("Make Post Anonymous", isOn: $postVM.sellerIsAnonymous)
            
            NavigationLink(
                destination: DetailView<ItemVM>(itemInfoVM: itemVM),
                isActive: $navigateToDetail
            ) {
                Button(action: {
                    postVM.postItem() { itemId in
                        itemVM.fetchSeller(with: itemId) {
                            navigateToDetail = true
                        }
                    }
                }) {
                    Text("Post Item!")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .buttonStyle(Styles.PinkButton())
            }
            
            Spacer()
        }
        .environmentObject(session)
        .padding()
        .navigationBarBackButtonHidden(true)
        .environmentObject(postVM)
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
