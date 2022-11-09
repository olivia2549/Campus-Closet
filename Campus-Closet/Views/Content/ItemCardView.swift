//
//  ItemCardView.swift
//  Campus-Closet
//
//  Created by Olivia Logan on 9/30/22.
//

import SwiftUI

struct ItemCardView: View, Identifiable {
    @StateObject private var viewModel = ItemVM()
    
    var id: String
    init(for id: String) {
        self.id = id
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            // Clickable image card
            NavigationLink (destination: DetailView(for: id)){
                if (viewModel.itemImage != nil) {   // render item image
                    Image(uiImage: viewModel.itemImage!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                }
                else {  // no image found
                    Color("LightGrey")
                        .frame(width: 175, height: 200, alignment: .center)
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                }
            }
            
            // Information under the image (title, size, and price)
            HStack(alignment: .top, spacing: 0) {
                VStack(alignment: .leading) {
                    Text(viewModel.item.title)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.black)
                        .frame(maxWidth: 250, alignment: .leading)
                    Text("Size: \(viewModel.item.size)")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.black)
                        .frame(maxWidth: 200, alignment: .leading)
                }
                Spacer()
                Text("$\(viewModel.item.price)")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Styles().themePink)
                    .frame(maxWidth: 100, alignment: .trailing)
            }
            .onAppear {
                viewModel.fetchItem(with: id)
            }
            .padding(.leading)
            .padding(.trailing)
        }
    }
}
