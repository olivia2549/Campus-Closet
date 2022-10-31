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
        print("rendering", id)
        self.id = id
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            NavigationLink (destination: DetailView(for: id)){
                if (viewModel.itemImage != nil) {
                    Image(uiImage: viewModel.itemImage!)
                        .resizable()
                        .frame(width: 175, height: 175, alignment: .center)
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())
                }
                else {
                    Image("blank-profile")
                        .resizable()
                        .frame(width: 175, height: 175, alignment: .center)
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())
                }
            }
            HStack(alignment: .top, spacing: 0) {
                VStack(alignment: .leading) {
                    Text(viewModel.item.title)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.black)
                        .frame(maxWidth: 250, alignment: .leading)
                    Text("Size: \(viewModel.item.size ?? "")")
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
            .padding(.leading)
            .padding(.trailing)
        }
        .onAppear {
            viewModel.fetchItem(with: id)
        }
    }
}

//struct ItemCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemCardView(for: "sweater_preview")
//    }
//}
