//
//  SmallView.swift
//  Campus-Closet
//
//  Created by Olivia Logan on 9/30/22.
//

import SwiftUI
import FirebaseAuth

struct StickyFooter: View {
    @EnvironmentObject private var viewModel: ItemVM

    var body: some View {
        VStack(spacing: 10) {
            HStack(alignment: .center) {
                // Item title and Vandy creator tag
                GeometryReader { geo in
                    HStack(alignment: .center) {
                        Text(viewModel.item.title)
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.black)
                            .padding(.top, 10)
                        if viewModel.item.studentCreated {
                            Image(systemName: "v.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20)
                                .foregroundStyle(Color("Dark Pink"))
                        }
                    }
                    .frame(maxWidth: geo.size.width*0.6, alignment: .leading)
                }
                
                Spacer()
                
                // Button at right
                if !viewModel.isSeller {
                    Button(action: {
                        print("Place Bid")
                    }){
                        Text("Place Bid $45\(viewModel.item.price)")
                            .frame(maxWidth: 120, alignment: .center)
                    }
                    .padding(10)
                    .background(Styles().themePink)
                    .cornerRadius(10)
                    .foregroundColor(.white)
                }
                else {
                    NavigationLink(destination: EditItem().environmentObject(viewModel)) {
                        Text("Edit Item")
                            .frame(maxWidth: 100, alignment: .center)
                    }
                    .padding(10)
                    .background(Styles().themePink)
                    .cornerRadius(10)
                    .foregroundColor(.white)
                }
            }
            
            Seller()
        }
        .padding()
        .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 15)
        .frame(height: viewModel.isSeller ? 100 : 175)
        .background(.white)
    }
    
}
