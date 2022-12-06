//
//  PostView.swift
//  Campus-Closet
//
//  Created by Olivia Logan on 9/29/22.
//

import SwiftUI

// Overarching structure that manages item posting screens.
struct PostView: View {
    @StateObject private var postVM = PostVM()
    @EnvironmentObject var session: OnboardingVM
    @Binding var tabSelection: Int
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationStack {
            ChoosePicture(tabSelection: $tabSelection, presentationMode: presentationMode)
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

// First screen in item posting. User uploads a picture from camera roll.
struct ChoosePicture: View {
    @EnvironmentObject private var viewModel: PostVM
    @EnvironmentObject var session: OnboardingVM
    var tabSelection: Binding<Int>
    var presentationMode: Binding<PresentationMode>
    @State var pickerShowing = false
    @State var chosenPicture: UIImage?
    @State var loadingPicturePicker = false
    @State private var presentInfoScreen: Bool = false
    
    init(tabSelection: Binding<Int>, presentationMode: Binding<PresentationMode>) {
        self.tabSelection = tabSelection
        self.presentationMode = presentationMode
    }
    
    var body: some View {
        VStack {
            if (chosenPicture == nil) {
                Button(action: {
                    pickerShowing = true
                    loadingPicturePicker = true
                }){
                    Image(systemName: ("square.and.arrow.up"))
                        .resizable()
                        .frame(width: maxWidth*0.18, height:maxWidth*0.22)
                    
                    Text("Choose a picture")
                        .font(Font.system(size: 20, weight: .semibold))
                }
                .buttonStyle(Styles.PinkTextButton())
            } else {
                Button(action: {
                    pickerShowing = true
                    loadingPicturePicker = true
                }){
                    VStack {
                        Image(uiImage: chosenPicture!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(RoundedRectangle(cornerRadius: 25))
                        Text("Tap image to change")
                            .font(Font.system(size: 20, weight: .semibold))
                            .foregroundColor(Styles().themePink)
                    }
                }
                NavigationLink(destination: BasicInfo(viewModel: viewModel, tabSelection: tabSelection, presentationMode: presentationMode, prevPresentationMode: presentationMode), isActive: $presentInfoScreen) {
                    Text("Next")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .onTapGesture {
                            self.presentInfoScreen = true
                        }
                }
                .buttonStyle(Styles.PinkButton())
                .padding()
            }
            
            if loadingPicturePicker {
                Text("Loading...")
            }
            Spacer().frame(height: maxHeight*0.2)
        }
        .sheet(isPresented: $pickerShowing, onDismiss: nil, content: {
            viewModel.choosePicture(chosenPicture: $chosenPicture, pickerShowing: $pickerShowing, isLoading: $loadingPicturePicker)
        })
        .onChange(of: chosenPicture) { newPicture in
            viewModel.chosenPicture = newPicture
        }
        .environmentObject(session)
    }
}

// Second screen in item posting. User enters required information with error checking.
struct BasicInfo: View {
    @ObservedObject var viewModel: PostVM
    @EnvironmentObject var session: OnboardingVM
    @State private var isMissingRequiredInfo: Bool = false
    @State var showDeleteConfirmation = false
    @Binding var tabSelection: Int
    var presentationMode: Binding<PresentationMode>
    var prevPresentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack(alignment: .leading) {
            CustomInput(
                for: "Item Name*",
                imageName: "tshirt",
                autocapitalization: .sentences,
                input: $viewModel.item.title
            ) {}
            
            HStack {
                CustomInput(
                    for: "Price*",
                    imageName: "dollarsign.circle",
                    autocapitalization: .never,
                    input: $viewModel.chosenPrice
                ) {}
                
                CustomInput(
                    for: "Size*",
                    imageName: "ruler",
                    autocapitalization: .never,
                    input: $viewModel.item.size
                ) {}
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
                            .frame(height: maxHeight*0.07)
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
            ) {}
            
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
                NavigationLink(destination: OptionalInfo(tabSelection: $tabSelection, prevPresentationMode: prevPresentationMode)) {
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
        .onTapGesture { hideKeyboard() }
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

// Third screen in error checking. User can input optional information about the item.
struct OptionalInfo: View {
    @EnvironmentObject private var postVM: PostVM
    @EnvironmentObject var session: OnboardingVM
    @StateObject var itemVM = ItemVM()
    var tabSelection: Binding<Int>
    var prevPresentationMode: Binding<PresentationMode>
    
    init(tabSelection: Binding<Int>, prevPresentationMode: Binding<PresentationMode>) {
        self.tabSelection = tabSelection
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
            
            Button(action: {
                postVM.postItem() { itemId in
                    itemVM.fetchSeller(for: itemId, curUser: session.currentUser) {
                        self.prevPresentationMode.wrappedValue.dismiss()
                    }
                }
                tabSelection.wrappedValue = 2
            }) {
                Text("Post Item!")
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .buttonStyle(Styles.PinkButton())
            
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
