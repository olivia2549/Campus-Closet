//
//  EditItem.swift
//  Campus-Closet
//
//  Created by Olivia Logan on 10/31/22.
//

import SwiftUI

struct EditItem: View {
    @ObservedObject var viewModel: PostVM
    @State private var isMissingRequiredInfo: Bool = false
    @State var showAlert = false
    @Binding var presentEditScreen: Bool
    
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
            
            Button(action: {
                if viewModel.verifyInfo() {
                    viewModel.updateItem { presentEditScreen = false }
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
                showAlert = true
            }) {
                Text("Delete Item")
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .buttonStyle(Styles.PinkButton())
            
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
        .navigationBarBackButtonHidden(true)
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Confirm Deletion"),
                  message: Text("Are you sure you want to remove this item? This action cannot be undone"),
                  primaryButton: .destructive(Text("Delete"), action: {
                    viewModel.deleteItem()
                    presentEditScreen = false
                  }),
                  secondaryButton: .cancel())
        }
    }
    
}
