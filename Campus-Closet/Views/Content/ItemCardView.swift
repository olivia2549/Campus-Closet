//
//  ItemCardView.swift
//  Campus-Closet
//
//  Created by Olivia Logan on 9/30/22.
//

import SwiftUI

// Structure for a clickable item listing widget.
struct ItemCardView: View, Identifiable {
    @StateObject private var viewModel = ItemVM()
    @EnvironmentObject var session: OnboardingVM
    var tabSelection: Binding<Int>
    let maxWidth = UIScreen.main.bounds.width
    let maxHeight = UIScreen.main.bounds.height
    var id: String
    
    init(for id: String, tabSelection: Binding<Int>) {
        self.id = id
        self.tabSelection = tabSelection
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            // Clickable image card.
            NavigationLink (destination: DetailView(tabSelection: tabSelection).environmentObject(viewModel)) {
                if (viewModel.itemImage != nil) {   // render item image
                    Image(uiImage: viewModel.itemImage!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                }
                else { // No image found.
                    Color("LightGrey")
                        .frame(width: maxWidth/2.2, height: maxHeight/3, alignment: .center)
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                }
            }
            PreviewItemInfo(for: id)
        }
        .environmentObject(viewModel)
        .environmentObject(session)
    }
}

// Structure that offers a preview of item listing details.
struct PreviewItemInfo: View {
    @EnvironmentObject private var viewModel: ItemVM
    @EnvironmentObject var session: OnboardingVM
    var id: String
    
    init(for id: String) {
        self.id = id
    }

    var body: some View {
        GeometryReader { proxy in
            // Information under the image (title, size, and price).
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
                Text(String(format: "$%.2f", viewModel.item.price))
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Styles().themePink)
                    .frame(maxWidth: proxy.size.width*0.4, alignment: .trailing)
            }
            .onAppear {
                viewModel.fetchSeller(for: id, curUser: session.currentUser) {}
            }
            .padding(.leading)
            .padding(.trailing)
            .padding(.bottom)
        }
    }
}
