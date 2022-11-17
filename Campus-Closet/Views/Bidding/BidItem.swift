//
//  BidItem.swift
//  Campus-Closet
//
//  Created by Hilly Yehoshua on 11/6/22.
//

import SwiftUI

struct BidItem: View {
    @State private var price: String = ""
    @State private var showAlert = false
    @Binding var showBidView: Bool
    @EnvironmentObject private var viewModel: ItemVM
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(alignment: .center){
            Text("Make an offer")
                .fontWeight(.semibold)
                .font(.system(size: 45))
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            Text("Current Bid Price: \(viewModel.item.price)")
                .fontWeight(.semibold)
                .font(.system(size: 20))
                .foregroundColor(Color("Dark Gray"))
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 25, trailing: 0))
            //viewmodel.item.picture - holds the name of the id that is in storage,
            //Image("flower")
            if (viewModel.itemImage != nil) {   // render item image
                            Image(uiImage: viewModel.itemImage!)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .clipShape(RoundedRectangle(cornerRadius: 25))
                        }
//                .resizable()
//                .scaledToFit()
//                .frame(width: 300)
//                .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
            Text("Your offer")
                .fontWeight(.semibold)
                .foregroundColor(Color("Dark Pink"))
                .font(.system(size: 25))
            VStack(alignment: .center) {
                HStack(alignment: .center){
                    Text("$")
                        .font(.system(size:80))
                        .padding (.leading)
                    TextField("0", text: $price)
                        .font(.system(size:100))
                        .padding (.leading)
                }
            }
            HStack {
                Spacer()
                                Button(action: {
                                    if (!viewModel.bidItem(price: price)) {
                                        showAlert = true
                                    }
                                    showBidView = false
                                }) {
                
                                    Text("Send Bid Offer")
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
                
                
                
                
                Spacer()
            }
            
            Spacer()
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Oops! There's been a problem placing your bid"),
                message: Text("Your bid price may be lower than the current listed price"),
                dismissButton: .default(Text("Ok"))
            )
        }
        .navigationBarHidden(true)
        
    }
    
}
