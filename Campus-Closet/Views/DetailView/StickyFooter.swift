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
    @Binding var offset: CGFloat
    @Binding var height: CGFloat
    @Binding var scrollHeight: CGFloat

    var body: some View {
        VStack(spacing: 10) {
            HStack(alignment: .center) {
                // Item title and Vandy creator tag
                GeometryReader { geo in
                    HStack(alignment: .center) {
                        Text(viewModel.item.title)
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.black)
                            .padding(.top, 20)
                        if viewModel.item.studentCreated {
                            Image(systemName: "v.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20)
                                .foregroundStyle(Color("Dark Pink"))
                        }
                    }
                    .frame(maxWidth: geo.size.width*0.7, alignment: .leading)
                }
                
                Spacer()
                
                // Button at right
                if !viewModel.isSeller {
                    NavigationLink(destination: BidItem()) {
                        Text("Place Bid $\(viewModel.item.price)")
                            .frame(maxWidth: 120, alignment: .center)
                    }

//                    Button(action: {
//                        print("Place Bid")
//                    }){
//                        Text("Place Bid $\(viewModel.item.price)")
//                            .frame(maxWidth: 120, alignment: .center)
//                    }
                    .padding(10)
                    .background(Styles().themePink)
                    .cornerRadius(10)
                    .foregroundColor(.white)
                }
                else {
                    NavigationLink(destination: EditItem().environmentObject(viewModel)) {
                        Text("Edit Item")
                            .frame(maxWidth: 120, alignment: .center)
                    }
                    .padding(10)
                    .background(Styles().themePink)
                    .cornerRadius(10)
                    .foregroundColor(.white)
                }
            }
            .padding(.top, 10)
            
            Seller()
            Spacer()
        }
        .frame(height: viewModel.isSeller ? 100 : 160)
        .padding(EdgeInsets(
            top: 0,
            leading: 15,
            bottom: UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 30,
            trailing: 15)
        )
        .if(offset >= scrollHeight - height + 1) { view in
            view.background(Color.white.shadow(radius: 10).mask(Rectangle().padding(.top, -20)))
        }
        .if(offset < height - scrollHeight + 1) { view in
            view.background(Color.white)
        }
    }
    
}
