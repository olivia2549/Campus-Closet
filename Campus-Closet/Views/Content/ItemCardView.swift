//
//  ItemCardView.swift
//  Campus-Closet
//
//  Created by Olivia Logan on 9/30/22.
//

import SwiftUI

struct ItemCardView: View, Identifiable {
    @StateObject private var viewModel = ItemVM()
    
    let maxWidth = UIScreen.main.bounds.width
    let maxHeight = UIScreen.main.bounds.height

    var id: String
    init(for id: String) {
        self.id = id
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            // Clickable image card
            NavigationLink (destination: DetailView<ItemVM>(itemInfoVM: viewModel)){
                if (viewModel.itemImage != nil) {   // render item image
                    Image(uiImage: viewModel.itemImage!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                }
                else {  // no image found
                    Color("LightGrey")
                        .frame(width: maxWidth/2.2, height: maxHeight/3, alignment: .center)
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                }
            }
            PreviewItemInfo(for: id)
        }
        .environmentObject(viewModel)
    }
}

struct PreviewItemInfo: View {
    @EnvironmentObject private var viewModel: ItemVM
    
    var id: String
    init(for id: String) {
        self.id = id
    }

    var body: some View {
        GeometryReader {proxy in
            // Information under the image (title, size, and price)
            HStack(alignment: .top, spacing: 0) {
                VStack(alignment: .leading) {
                    Text(viewModel.item.title)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.black)
                    Text("Size: \(viewModel.item.size)")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.black)
                }
                .frame(maxWidth: proxy.size.width*0.6, alignment: .leading)
                Spacer()
                Text("$\(viewModel.item.price)")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Styles().themePink)
                    .frame(maxWidth: proxy.size.width*0.4, alignment: .trailing)
            }
            .onAppear {
                viewModel.fetchItem(with: id) {}
            }
            .padding(.leading)
            .padding(.trailing)
            .padding(.bottom)
        }
    }
}
