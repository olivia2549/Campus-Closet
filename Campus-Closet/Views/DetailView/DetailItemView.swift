//
//  ItemCardView.swift
//  Campus-Closet
//
//  Created by Olivia Logan on 9/30/22.
//

import SwiftUI
import FirebaseAuth

struct DetailItemView: View {
    @EnvironmentObject private var viewModel: ItemVM

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            if (viewModel.itemImage != nil) {
                Image(uiImage: viewModel.itemImage!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding(10)
                    .overlay(alignment: .topTrailing){
                        if !viewModel.isSeller {
                            Button(action: {
                                print("Add to favorites")
                            }){
                                Image(systemName: "heart")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 30)
                                    .foregroundStyle(Color("Dark Pink"))
                                
                            }.offset(x: -18, y: 20)
                        }
                    }
            }
            VStack{
                HStack(alignment: .top, spacing: 0) {
                    if viewModel.item.studentCreated {
                        Text(viewModel.item.title)
                            .font(.system(size: 30))
                            .foregroundColor(.black)
                        Spacer()
                        Image(systemName: "v.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20)
                            .foregroundStyle(Color("Dark Pink"))
                            .frame(maxWidth: 250, alignment: .leading)
                    }
                    else {
                        Text(viewModel.item.title)
                            .font(.system(size: 30))
                            .foregroundColor(.black)
                            .frame(maxWidth: 250, alignment: .leading)
                        Spacer()
                    }
                    
                    Text("$\(viewModel.item.price)")
                        .font(.system(size: 30))
                        .foregroundColor(Styles().themePink)
                        .frame(maxWidth: 100, alignment: .trailing)
                    Spacer()
                }
            }
            .padding(.leading)
            .padding(.trailing)
        }
    }
    
}
